<?php

namespace App\Jobs;

use App\Models\GeneratedVideo;
use App\Models\Errorlogs;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use App\Models\Task;
use App\Models\BeforeGenerate;
use Illuminate\Support\Facades\DB;

class GenerateVideoCPUJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $video;
    public $meta;

    public $timeout = 3600;  // 1 hour timeout
    public $tries = 2;       // Retry once if fails

    public function __construct(array $video, array $meta)
    {
        $this->video = $video;
        $this->meta  = $meta;
    }

    public function handle()
    {
        try {
            Log::info("Starting video generation for: " . basename($this->video['output']));
            
            $python = env('PYTHON_PATH', 'python');
            $script = base_path('video_generator.py');

            // Check GPU settings
            $settingsPath = storage_path('app/gpu_settings.json');
            $useGpu = '1'; // Default to enabled
            
            if (file_exists($settingsPath)) {
                $settings = json_decode(file_get_contents($settingsPath), true);
                if (isset($settings['enabled']) && !$settings['enabled']) {
                    $useGpu = '0';
                }
            }
            
            Log::info("GPU Acceleration Status: " . ($useGpu == '1' ? 'Enabled' : 'Disabled'));

            // Prepare environment variables for FFmpeg
            $envPrefix = '';
            $ffmpegPath = env('FFMPEG_PATH');
            if ($ffmpegPath && file_exists($ffmpegPath)) {
                $ffmpegDir = dirname($ffmpegPath);
                $envPrefix = "set PATH={$ffmpegDir};%PATH% && set IMAGEIO_FFMPEG_EXE={$ffmpegPath} && ";
            }

            // Build command - inject USE_GPU and FFMPEG env vars
            $cmd = sprintf(
                '%s set USE_GPU=%s && "%s" "%s" "%s" "%s" "%s" "%s" 2>&1',
                $envPrefix,
                $useGpu,
                $python,
                $script,
                str_replace('/', '\\', $this->video['bg_video']),
                str_replace('/', '\\', $this->video['template']),
                str_replace('/', '\\', $this->video['output']),
                $this->video['animation']
            );

            Log::info("Executing: " . $cmd);

            exec($cmd, $out, $code);

            if ($code !== 0 || !file_exists($this->video['output'])) {
                $errorMsg = implode("\n", $out);
                Log::error("Video generation failed: " . $errorMsg);
                
                Errorlogs::create([
                    'task_id' => $this->meta['taskid'],
                    'message' => "Video generation failed for " . basename($this->video['output']) . ": " . $errorMsg
                ]);
                return;
            }

            // Generate thumbnail
            $this->generateThumbnail($this->video['output'], public_path('videos/thumbnails/' . $this->meta['thumbnail_name']));

            // Get file size and duration
            $fileSize = file_exists($this->video['output']) ? filesize($this->video['output']) : null;
            $duration = $this->getVideoDuration($this->video['output']);

            // Save to database
            GeneratedVideo::create([
                'customer_id'      => $this->meta['customer_id'],
                'master_video_id'  => $this->meta['master_video_id'],
                'user_video_id'    => $this->meta['user_video_id'],
                'taskid'           => $this->meta['taskid'],
                'beforeid'         => $this->meta['beforeid'],
                'generated_video'  => $this->meta['video_name'],
                'generated_path'   => $this->video['output'],
                'thumbnail'        => $this->meta['thumbnail_name'],
                'video_type'       => $this->meta['video_type'],
                'duration'         => $duration,
                'file_size'        => $fileSize,
                'sent'             => 0,
            ]);

            Log::info("✅ Video generated successfully: " . basename($this->video['output']));

            // Check if this was the last video for the task
            $taskId = $this->meta['taskid'];
            
            // Count generated videos
            $generatedCount = GeneratedVideo::where('taskid', $taskId)->count();
            
            // Count expected videos
            $expectedCount = DB::table('before_genration as bg')
                ->leftJoin('templates_by_user as tu', function($join) {
                    $join->on('bg.mastertemplateid', '=', 'tu.master_template_id')
                         ->where('tu.content_type', '=', 'video');
                })
                ->where('bg.taskid', $taskId)
                ->where('bg.content_type', 'video')
                ->count('tu.id');
                
            Log::info("Task {$taskId} progress: {$generatedCount}/{$expectedCount}");
            
            // Update task with real-time progress
            $task = Task::find($taskId);
            if ($task) {
                if ($generatedCount >= $expectedCount && $expectedCount > 0) {
                    Log::info("🎉 Task {$taskId} completed! Marking as done.");
                    $task->status = 1; // Completed
                    $task->remark = "Task Executed Successfully ({$generatedCount} videos generated)";
                } else {
                    // Update progress in remark
                    $task->remark = "Processing: {$generatedCount}/{$expectedCount} videos generated";
                }
                $task->save();
            }

        } catch (\Exception $e) {
            Log::error("Exception in video generation: " . $e->getMessage());
            
            Errorlogs::create([
                'task_id' => $this->meta['taskid'],
                'message' => "Exception: " . $e->getMessage()
            ]);
        }
    }

    private function generateThumbnail($videoPath, $thumbnailPath)
    {
        try {
            $thumbnailDir = dirname($thumbnailPath);
            if (!file_exists($thumbnailDir)) {
                mkdir($thumbnailDir, 0777, true);
            }

            $command = sprintf(
                'ffmpeg -i "%s" -ss 00:00:01 -vframes 1 -q:v 2 "%s" 2>&1',
                str_replace('/', '\\', $videoPath),
                str_replace('/', '\\', $thumbnailPath)
            );

            exec($command, $output, $returnCode);

            if ($returnCode !== 0 || !file_exists($thumbnailPath)) {
                Log::warning("Failed to generate thumbnail for {$videoPath}");
                return false;
            }

            return true;
        } catch (\Exception $e) {
            Log::error("Thumbnail generation error: " . $e->getMessage());
            return false;
        }
    }

    private function getVideoDuration($videoPath)
    {
        try {
            $command = sprintf(
                'ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "%s" 2>&1',
                str_replace('/', '\\', $videoPath)
            );

            exec($command, $output, $returnCode);

            if ($returnCode === 0 && !empty($output[0])) {
                return floatval($output[0]);
            }

            return null;
        } catch (\Exception $e) {
            return null;
        }
    }
}
