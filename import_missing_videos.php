<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\Task;
use App\Models\GeneratedVideo;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

$taskId = 148;
$logFile = storage_path('logs/gpu_task_' . $taskId . '.log');
$metadataDir = storage_path('app/gpu_tasks');

echo "Recovering Task {$taskId}...\n";

// 1. Find Metadata File
// Need to find matching json file for task 148
$metaFiles = glob($metadataDir . '/task_' . $taskId . '_*.json');
if (empty($metaFiles)) {
    // Try manual prefix
    $metaFiles = glob($metadataDir . '/manual_task_' . $taskId . '_*.json');
}

if (empty($metaFiles)) {
    die("❌ No metadata file found for Task {$taskId}\n");
}

// Sort by time descending
usort($metaFiles, function($a, $b) {
    return filemtime($b) - filemtime($a);
});

$metadataFile = $metaFiles[0];
echo "Using metadata: " . basename($metadataFile) . "\n";
$metadata = json_decode(file_get_contents($metadataFile), true);

// 2. Parse Log Results
$logContent = file_get_contents($logFile);
if (preg_match('/RESULTS_JSON_START\s*(.*?)\s*RESULTS_JSON_END/s', $logContent, $matches)) {
    $jsonResults = trim($matches[1]);
    $results = json_decode($jsonResults, true);
    
    if (!$results) {
        die("❌ Failed to parse JSON results from log.\n");
    }
    
    echo "Found " . count($results) . " results in log.\n";
    
    $imported = 0;
    foreach ($results as $index => $result) {
        if ($result['success'] && isset($result['output'])) {
            // Find corresponding metadata
            // Note: index in results matches index in metadata array
            if (isset($metadata[$index]['meta'])) {
                $meta = $metadata[$index]['meta'];
                
                // Check DB
                $exists = GeneratedVideo::where('generated_video', $meta['video_name'])->exists();
                if (!$exists) {
                     try {
                        $video = new GeneratedVideo();
                        $video->customer_id = $meta['customer_id'];
                        $video->master_video_id = $meta['master_video_id'];
                        $video->user_video_id = $meta['user_video_id'];
                        $video->taskid = $meta['taskid'];
                        $video->beforeid = $meta['beforeid'];
                        $video->generated_video = $meta['video_name']; // key
                        $video->generated_path = $meta['output_path'];
                        $video->thumbnail = $meta['thumbnail_name'];
                        $video->video_type = $meta['video_type'];
                        $video->duration = $result['time'] ?? 0;
                        $video->file_size = $result['size'] ?? 0;
                        $video->sent = 0;
                        $video->created_at = now();
                        $video->updated_at = now();
                        $video->save();
                        $imported++;
                     } catch (\Exception $e) {
                         echo "  -> Error saving video {$index}: " . $e->getMessage() . "\n";
                     }
                }
            }
        }
    }
    
    echo "✅ Imported {$imported} missing videos.\n";
    
    // 3. Mark Task Completed
    $count = GeneratedVideo::where('taskid', $taskId)->count();
    $task = Task::find($taskId);
    $task->status = 1;
    $task->remark = 'Recovered ' . $count . '/' . $task->totalvideos;
    $task->totalvideos = max($task->totalvideos, $count);
    $task->finished_at = now();
    $task->save();
    
    echo "✅ Task marked as COMPLETED.\n";
    
} else {
    echo "❌ Could not find RESULTS block in log file.\n";
}
