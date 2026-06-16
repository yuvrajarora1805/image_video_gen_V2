<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use App\Models\Task;
use App\Models\BeforeGenerate;
use App\Models\TemplatesByUser;
use App\Models\Logs;
use App\Models\Errorlogs;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ProcessVideoTaskJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $taskId;
    public $timeout = 7200; // 2 hours timeout for large batches
    public $tries = 1; // Don't retry failed tasks

    /**
     * Create a new job instance.
     */
    public function __construct($taskId)
    {
        $this->taskId = $taskId;
    }

    /**
     * Execute the job - Process video task in background
     */
    public function handle()
    {
        set_time_limit(3600);
        ini_set('memory_limit', '4096M');
        
        Log::info("ProcessVideoTaskJob started for task {$this->taskId}");
        
        DB::beginTransaction();

        try {
            $task = Task::find($this->taskId);

            if (!$task || $task->status != 2) {
                Log::warning("Task {$this->taskId} not found or not in processing state");
                return;
            }

            $taskprocess = BeforeGenerate::where('taskid', $this->taskId)
                ->where('status', 1)
                ->where('content_type', 'video')
                ->get();

            if ($taskprocess->isEmpty()) {
                Log::warning("No videos to process for task {$this->taskId}");
                DB::commit();
                return;
            }

            // Collect all videos to generate in batches
            $videoBatch = [];
            $videoMetadata = [];
            
            foreach ($taskprocess as $td) {
                $backgroundVideoPath = public_path('videos/background_video/' . $td->backgroundimage);

                if (!file_exists($backgroundVideoPath)) {
                    Log::error("Background video not found: {$backgroundVideoPath}");
                    continue;
                }

                // Get customer templates
                $frontTemplates = TemplatesByUser::where('master_template_id', $td->mastertemplateid)
                    ->where('content_type', 'video')
                    ->get();

                foreach ($frontTemplates as $fi) {
                    try {
                        $frontpath = public_path('img/user_template/' . $fi->customer_template);

                        if (!file_exists($frontpath)) {
                            throw new \Exception("Customer template not found: {$frontpath}");
                        }

                        $videoName = 'combined_video_' . time() . '_' . uniqid() . '.mp4';
                        $outputPath = public_path('videos/generated_video/' . $videoName);

                        $outputDir = dirname($outputPath);
                        if (!file_exists($outputDir)) {
                            mkdir($outputDir, 0777, true);
                        }

                        $animationEffect = $td->animation_effect ?? 'wipe-in';
                        $renderingEngine = $td->rendering_engine ?? 'ffmpeg';
                        
                        $videoBatch[] = [
                            'bg_video' => $backgroundVideoPath,
                            'template' => $frontpath,
                            'output' => $outputPath,
                            'animation' => $animationEffect,
                            'rendering_engine' => $renderingEngine
                        ];
                        
                        $videoMetadata[] = [
                            'customer_id' => $fi->customer_id,
                            'master_video_id' => $td->mastertemplateid,
                            'user_video_id' => $fi->id,
                            'taskid' => $this->taskId,
                            'beforeid' => $td->id,
                            'output_path' => $outputPath,
                            'video_name' => $videoName,
                            'thumbnail_name' => 'thumb_' . pathinfo($videoName, PATHINFO_FILENAME) . '.jpg',
                            'video_type' => $td->video_type ?? 'landscape'
                        ];
                        
                    } catch (\Exception $e) {
                        Log::warning("Failed to prepare video for customer {$fi->customer_id}: " . $e->getMessage());
                        
                        $errorlog = new Errorlogs();
                        $errorlog->task_id = $this->taskId;
                        $errorlog->message = "Customer {$fi->customer_id}: " . $e->getMessage();
                        $errorlog->save();
                    }
                }

                BeforeGenerate::where('id', $td->id)->update(['status' => false]);
            }
            
            // Dispatch videos to queue
            if (!empty($videoBatch)) {
                Log::info("Dispatching " . count($videoBatch) . " videos for task {$this->taskId}");
                
                // Check GPU Status
                $settingsPath = storage_path('app/gpu_settings.json');
                $gpuEnabled = false;
                if (file_exists($settingsPath)) {
                    $s = json_decode(file_get_contents($settingsPath), true);
                    $gpuEnabled = $s['enabled'] ?? false;
                }
                
                if ($gpuEnabled) {
                    // GPU Mode - Direct execution
                    Log::info("🚀 GPU ENABLED: Starting Direct Parallel Execution");
                    
                    $taskPayload = [];
                    foreach ($videoBatch as $idx => $v) {
                        $taskPayload[] = array_merge($v, ['meta' => $videoMetadata[$idx]]);
                    }
                    
                    $jsonDir = storage_path('app/gpu_tasks');
                    if (!file_exists($jsonDir)) mkdir($jsonDir, 0777, true);
                    $jsonFile = $jsonDir . '/task_' . $this->taskId . '_' . time() . '.json';
                    file_put_contents($jsonFile, json_encode($taskPayload));
                    $renderingEngine = $videoBatch[0]['rendering_engine'] ?? 'ffmpeg';
                    $python = env('PYTHON_PATH', 'python');
                    
                    if ($renderingEngine === 'ffmpeg') {
                        $script = base_path('ffmpeg_parallel_generator.py');
                    } else {
                        $script = base_path('parallel_video_generator.py');
                    }
                    
                    $logFile = storage_path('logs/gpu_task_' . $this->taskId . '.log');
                    
                    // Prepare environment variables for FFmpeg
                    $envPrefix = '';
                    $ffmpegPath = env('FFMPEG_PATH');
                    if ($ffmpegPath && file_exists($ffmpegPath)) {
                        $ffmpegDir = dirname($ffmpegPath);
                        // Important: Add to PATH for subprocess and set for MoviePy
                        $envPrefix = "set PATH={$ffmpegDir};%PATH% && set IMAGEIO_FFMPEG_EXE={$ffmpegPath} && ";
                    }

                    // Pass file path instead of content to avoid CLI length limits
                    $cmd = "{$envPrefix}start /B \"\" \"{$python}\" \"{$script}\" \"{$jsonFile}\" > \"{$logFile}\" 2>&1";
                    
                    pclose(popen("cmd /c {$cmd}", "r"));
                    Log::info("Launched GPU Manager for task {$this->taskId}");
                    
                    // Launch result processor
                    $processorScript = base_path('gpu_result_monitor.php');
                    $phpPath = env('PHP_PATH', 'php'); // Full path to PHP
                    $processorCmd = "start /B \"\" \"{$phpPath}\" \"{$processorScript}\" {$this->taskId} \"{$logFile}\" \"{$jsonFile}\"";
                    pclose(popen("cmd /c {$processorCmd}", "r"));
                    
                } else {
                    // CPU Queue Mode
                    foreach ($videoBatch as $index => $video) {
                        \App\Jobs\GenerateVideoCPUJob::dispatch(
                            $video,
                            $videoMetadata[$index]
                        )->onQueue('video_cpu');
                    }
                    Log::info("✅ " . count($videoBatch) . " video jobs dispatched to queue");
                }
            }

            DB::commit();

            $logs = new Logs();
            $logs->task_id = $this->taskId;
            $logs->status = 'success';
            $logs->message = 'Videos queued for generation';
            $logs->save();

            Log::info("ProcessVideoTaskJob completed for task {$this->taskId}");

        } catch (\Exception $e) {
            DB::rollBack();
            Log::error("ProcessVideoTaskJob failed for task {$this->taskId}: " . $e->getMessage());
            
            $errorlog = new Errorlogs();
            $errorlog->task_id = $this->taskId;
            $errorlog->message = $e->getMessage();
            $errorlog->save();
            
            throw $e;
        }
    }
}
