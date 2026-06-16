<?php
/**
 * GPU Result Monitor
 * Monitors GPU task completion and automatically saves results to database
 * Usage: php gpu_result_monitor.php <task_id> <log_file> <metadata_file>
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\GeneratedVideo;
use App\Models\Task;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

if ($argc < 4) {
    echo "Usage: php gpu_result_monitor.php <task_id> <log_file> <metadata_file>\n";
    exit(1);
}

$taskId = $argv[1];
$logFile = $argv[2];
$metadataFile = $argv[3];

Log::info("GPU Result Monitor started for task {$taskId}");

// Load metadata immediately
if (!file_exists($metadataFile)) {
    Log::error("Metadata file not found: {$metadataFile}");
    exit(1);
}

$metadata = json_decode(file_get_contents($metadataFile), true);
if (!$metadata) {
    Log::error("Failed to parse metadata file");
    exit(1);
}

// Map output paths to metadata for O(1) lookup
$metaMap = [];
foreach ($metadata as $item) {
    $metaMap[basename($item['output'])] = $item['meta']; // Use filename as key
}

Log::info("Helper loaded metadata for " . count($metaMap) . " videos");

// Real-time monitoring loop
$maxWaitTime = 7200; // 2 hours
$checkInterval = 2; // Check frequently (2s)
$elapsed = 0;
$processedFiles = []; // Keep track of what we've saved

// Initialize task variable for later use
$task = Task::find($taskId);
if (!$task) {
    Log::error("Task {$taskId} not found.");
    exit(1);
}

while ($elapsed < $maxWaitTime) {
    if (file_exists($logFile)) {
        $logContent = file_get_contents($logFile);
        
        // 1. Scan for SUCCESS lines to do Real-Time Updates
        if (preg_match_all('/\[FFmpeg\] SUCCESS: (.*?) \(/', $logContent, $matches)) {
            foreach ($matches[1] as $filename) {
                $filename = trim($filename);
                
                if (isset($processedFiles[$filename])) continue; // Already processed
                
                if (isset($metaMap[$filename])) {
                    $meta = $metaMap[$filename];
                    
                    // Double check DB
                    $existing = GeneratedVideo::where('generated_video', $meta['video_name'])->first();
                    
                    if (!$existing) {
                        try {
                            $video = new GeneratedVideo();
                            $video->customer_id = $meta['customer_id'];
                            $video->master_video_id = $meta['master_video_id'];
                            $video->user_video_id = $meta['user_video_id'];
                            $video->taskid = $meta['taskid'];
                            $video->beforeid = $meta['beforeid'];
                            $video->generated_video = $meta['video_name'];
                            $video->generated_path = $meta['output_path']; // Full path
                            $video->thumbnail = $meta['thumbnail_name'];
                            $video->video_type = $meta['video_type'];
                            $video->duration = 0; // Will be set later or use default
                            $video->file_size = 0;
                            $video->sent = 0;
                            $video->created_at = now();
                            $video->updated_at = now();
                            $video->save();
                            
                            Log::info("✅ Real-time Save: {$filename}");
                            
                            // Update task progress in real-time
                            $currentCount = count($processedFiles) + 1;
                            $totalExpected = count($metaMap);
                            $task->remark = "Processing: {$currentCount}/{$totalExpected} videos generated";
                            $task->save();
                            
                        } catch (\Exception $e) {
                            Log::error("Failed to save {$filename}: " . $e->getMessage());
                        }
                    }
                    $processedFiles[$filename] = true;
                }
            }
        }
        
        // 2. Check for completion marker
        if (strpos($logContent, 'RESULTS_JSON_END') !== false) {
            Log::info("GPU task {$taskId} completed!");
            
            // Fallback: Parse the JSON output at the end to ensure all successful videos are saved
            if (preg_match('/RESULTS_JSON_START\s+(.*?)\s+RESULTS_JSON_END/s', $logContent, $jsonMatches)) {
                $jsonResults = json_decode($jsonMatches[1], true);
                if (is_array($jsonResults)) {
                    foreach ($jsonResults as $res) {
                        if (!empty($res['success']) && !empty($res['output'])) {
                            $filename = basename($res['output']);
                            
                            if (!isset($processedFiles[$filename]) && isset($metaMap[$filename])) {
                                $meta = $metaMap[$filename];
                                $existing = GeneratedVideo::where('generated_video', $meta['video_name'])->first();
                                
                                if (!$existing) {
                                    try {
                                        $video = new GeneratedVideo();
                                        $video->customer_id = $meta['customer_id'];
                                        $video->master_video_id = $meta['master_video_id'];
                                        $video->user_video_id = $meta['user_video_id'];
                                        $video->taskid = $meta['taskid'];
                                        $video->beforeid = $meta['beforeid'];
                                        $video->generated_video = $meta['video_name'];
                                        $video->generated_path = $meta['output_path'];
                                        $video->thumbnail = $meta['thumbnail_name'];
                                        $video->video_type = $meta['video_type'];
                                        $video->duration = $res['time'] ?? 0;
                                        $video->file_size = $res['size'] ?? 0;
                                        $video->sent = 0;
                                        $video->created_at = now();
                                        $video->updated_at = now();
                                        $video->save();
                                        
                                        Log::info("✅ JSON Fallback Save: {$filename}");
                                        $processedFiles[$filename] = true;
                                    } catch (\Exception $e) {
                                        Log::error("Failed to save via JSON fallback {$filename}: " . $e->getMessage());
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Final update of task status
            $generatedCount = GeneratedVideo::where('taskid', $taskId)->count();
            // Refetch task to avoid stale model
            $task = Task::find($taskId);
            
            if ($task) {
                // Determine expected count
                $totalExpected = DB::table('before_genration as bg')
                    ->leftJoin('templates_by_user as tu', function($join) {
                        $join->on('bg.mastertemplateid', '=', 'tu.master_template_id')
                             ->where('tu.content_type', '=', 'video');
                    })
                    ->where('bg.taskid', $taskId)
                    ->where('bg.content_type', 'video')
                    ->count('tu.id');
                    
                $task->status = 1; // Completed
                $task->remark = "Task Executed Successfully ({$generatedCount} videos generated)";
                
                // Try to save with retry on lock
                $saved = false;
                for ($attempt = 1; $attempt <= 3; $attempt++) {
                    try {
                        $task->save();
                        $saved = true;
                        Log::info("Task {$taskId} finalized. Total Generated: {$generatedCount}");
                        break;
                    } catch (\Exception $e) {
                        Log::warning("Attempt {$attempt} to save task {$taskId} failed: " . $e->getMessage());
                        if ($attempt < 3) sleep(2); // Wait before retry
                    }
                }
                
                if (!$saved) {
                    Log::error("Failed to finalize task {$taskId} after 3 attempts");
                }
            }
            break;
        }
    }
    
    sleep($checkInterval);
    $elapsed += $checkInterval;
}

if ($elapsed >= $maxWaitTime) {
    Log::warning("GPU task {$taskId} timed out after {$maxWaitTime} seconds");
    exit(1);
}
