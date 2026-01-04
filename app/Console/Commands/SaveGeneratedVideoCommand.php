<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\GeneratedVideo;
use App\Models\Errorlogs;
use App\Models\Task;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class SaveGeneratedVideoCommand extends Command
{
    protected $signature = 'video:save-generated {--file= : Path to JSON metadata file}';
    protected $description = 'Save generated video record to database from external script';

    public function handle()
    {
        $filePath = $this->option('file');

        if (!file_exists($filePath)) {
            $this->error("Metadata file not found: $filePath");
            return 1;
        }

        $data = json_decode(file_get_contents($filePath), true);
        if (!$data) {
            $this->error("Invalid JSON metadata");
            return 1;
        }

        try {
            // Calculate Duration/Size
            $videoPath = $data['output_path'];
            $fileSize = file_exists($videoPath) ? filesize($videoPath) : 0;
            $duration = $this->getVideoDuration($videoPath);
            
            // Generate Thumbnail
            $thumbPath = public_path('videos/thumbnails/' . $data['thumbnail_name']);
            $this->generateThumbnail($videoPath, $thumbPath);

            // Create Record
            GeneratedVideo::create([
                'customer_id'      => $data['customer_id'],
                'master_video_id'  => $data['master_video_id'],
                'user_video_id'    => $data['user_video_id'],
                'taskid'           => $data['taskid'],
                'beforeid'         => $data['beforeid'],
                'generated_video'  => $data['video_name'],
                'generated_path'   => $videoPath,
                'thumbnail'        => $data['thumbnail_name'],
                'video_type'       => $data['video_type'],
                'duration'         => $duration,
                'file_size'        => $fileSize,
                'sent'             => 0,
            ]);

            $this->info("Saved video: " . basename($videoPath));
            
            // Check Task Completion
            $this->checkTaskCompletion($data['taskid']);

            return 0;

        } catch (\Exception $e) {
            $this->error("Error saving video: " . $e->getMessage());
            Log::error("SaveGeneratedVideoCommand Error: " . $e->getMessage());
            return 1;
        }
    }

    private function checkTaskCompletion($taskId)
    {
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
            
        if ($generatedCount >= $expectedCount && $expectedCount > 0) {
            $task = Task::find($taskId);
            if ($task) {
                $task->status = 1; // Completed
                $task->remark = 'Generated - Ready to Send';
                $task->finished_at = now();
                $task->save();
                Log::info("Task $taskId completed via Direct GPU Execution");
            }
        }
    }

    private function generateThumbnail($videoPath, $thumbnailPath)
    {
        $thumbnailDir = dirname($thumbnailPath);
        if (!file_exists($thumbnailDir)) mkdir($thumbnailDir, 0777, true);

        $cmd = sprintf(
            'ffmpeg -i "%s" -ss 00:00:01 -vframes 1 -q:v 2 "%s" 2>&1',
            str_replace('/', '\\', $videoPath),
            str_replace('/', '\\', $thumbnailPath)
        );
        exec($cmd);
    }

    private function getVideoDuration($videoPath)
    {
        $cmd = sprintf(
            'ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "%s" 2>&1',
            str_replace('/', '\\', $videoPath)
        );
        exec($cmd, $output, $returnCode);
        return ($returnCode === 0 && !empty($output[0])) ? floatval($output[0]) : null;
    }
}
