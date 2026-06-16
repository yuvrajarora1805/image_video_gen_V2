<?php
/**
 * GPU Task Result Processor
 * Monitors GPU task log files and saves generated videos to database
 * Run this after GPU tasks complete
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\GeneratedVideo;
use App\Models\Task;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

function processGpuTaskLog($taskId) {
    $logFile = storage_path("logs/gpu_task_{$taskId}.log");
    
    if (!file_exists($logFile)) {
        echo "Log file not found: {$logFile}\n";
        return false;
    }
    
    $logContent = file_get_contents($logFile);
    
    // Extract JSON results between markers
    if (preg_match('/RESULTS_JSON_START\s*(.*?)\s*RESULTS_JSON_END/s', $logContent, $matches)) {
        $jsonResults = trim($matches[1]);
        
        try {
            $results = json_decode($jsonResults, true);
            
            if (!$results) {
                echo "Failed to parse JSON results\n";
                return false;
            }
            
            echo "Found " . count($results) . " video results\n";
            
            $task = Task::find($taskId);
            if (!$task) {
                echo "Task not found: {$taskId}\n";
                return false;
            }
            
            $savedCount = 0;
            
            foreach ($results as $result) {
                if ($result['success'] && isset($result['output'])) {
                    $outputPath = $result['output'];
                    
                    // Extract metadata from path or use defaults
                    // Path format: public/videos/generated_video/video_TIMESTAMP_TASKID_CUSTOMERID_MASTERID_USERID.mp4
                    if (preg_match('/video_\d+_\d+_(\d+)_(\d+)_(\d+)\.mp4$/', $outputPath, $pathMatches)) {
                        $customerId = $pathMatches[1];
                        $masterVideoId = $pathMatches[2];
                        $userVideoId = $pathMatches[3];
                        
                        // Check if already exists
                        $existing = GeneratedVideo::where('videopath', $outputPath)->first();
                        
                        if (!$existing) {
                            $video = new GeneratedVideo();
                            $video->customer_id = $customerId;
                            $video->master_video_id = $masterVideoId;
                            $video->user_video_id = $userVideoId;
                            $video->taskid = $taskId;
                            $video->videopath = $outputPath;
                            $video->save();
                            
                            $savedCount++;
                            echo "Saved video: {$outputPath}\n";
                        } else {
                            echo "Video already exists: {$outputPath}\n";
                        }
                    } else {
                        echo "Could not parse path: {$outputPath}\n";
                    }
                }
            }
            
            echo "Saved {$savedCount} videos to database\n";
            
            // Update task status if all videos processed
            $totalExpected = DB::table('before_genration as bg')
                ->leftJoin('templates_by_user as tu', function($join) {
                    $join->on('bg.mastertemplateid', '=', 'tu.master_template_id')
                         ->where('tu.content_type', '=', 'video');
                })
                ->where('bg.taskid', $taskId)
                ->where('bg.content_type', 'video')
                ->count('tu.id');
            
            $generated = GeneratedVideo::where('taskid', $taskId)->count();
            
            if ($generated >= $totalExpected && $totalExpected > 0) {
                $task->status = 1; // Completed
                $task->remark = 'Task Executed Successfully';
                $task->finished_at = now();
                $task->save();
                echo "Task marked as completed\n";
            }
            
            return true;
            
        } catch (Exception $e) {
            echo "Error processing results: " . $e->getMessage() . "\n";
            Log::error("GPU task processor error for task {$taskId}: " . $e->getMessage());
            return false;
        }
    } else {
        echo "No JSON results found in log file\n";
        return false;
    }
}

// Process task ID from command line argument
if ($argc < 2) {
    echo "Usage: php process_gpu_results.php <task_id>\n";
    exit(1);
}

$taskId = $argv[1];
echo "Processing GPU task results for task ID: {$taskId}\n";

if (processGpuTaskLog($taskId)) {
    echo "✓ Successfully processed task {$taskId}\n";
    exit(0);
} else {
    echo "✗ Failed to process task {$taskId}\n";
    exit(1);
}
