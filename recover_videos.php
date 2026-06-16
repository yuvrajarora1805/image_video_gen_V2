<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\Task;
use App\Models\GeneratedVideo;
use Illuminate\Support\Facades\DB;

if ($argc < 2) {
    echo "Usage: php recover_videos.php <task_name>\nExample: php recover_videos.php VideoTask12\n";
    exit(1);
}

$taskName = $argv[1];
$task = Task::where('taskname', $taskName)->first();

if (!$task) {
    echo "Task not found.";
    exit;
}

$taskId = $task->id;
echo "Found Task ID: {$taskId}\n";

$logFile = storage_path("logs/gpu_task_{$taskId}.log");
if (!file_exists($logFile)) {
    echo "Log file not found: {$logFile}\n";
    exit;
}

$jsonDir = storage_path('app/gpu_tasks');
$files = glob($jsonDir . "/task_{$taskId}_*.json");
if (empty($files)) {
    echo "Metadata JSON file not found for task {$taskId}.\n";
    exit;
}

// Get the latest json file
rsort($files);
$metadataFile = $files[0];

echo "Using Log File: {$logFile}\n";
echo "Using Meta File: {$metadataFile}\n";

$logContent = file_get_contents($logFile);
$metadata = json_decode(file_get_contents($metadataFile), true);

if (!$metadata) {
    echo "Failed to parse metadata file.\n";
    exit;
}

$metaMap = [];
foreach ($metadata as $item) {
    $metaMap[basename($item['output'])] = $item['meta'];
}

$savedCount = 0;
if (preg_match('/RESULTS_JSON_START\s+(.*?)\s+RESULTS_JSON_END/s', $logContent, $jsonMatches)) {
    $jsonResults = json_decode($jsonMatches[1], true);
    if (is_array($jsonResults)) {
        foreach ($jsonResults as $res) {
            if (!empty($res['success']) && !empty($res['output'])) {
                $filename = basename($res['output']);
                if (isset($metaMap[$filename])) {
                    $meta = $metaMap[$filename];
                    $existing = GeneratedVideo::where('generated_video', $meta['video_name'])->first();
                    if (!$existing) {
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
                        $savedCount++;
                    }
                }
            }
        }
    }
}

$totalGenerated = GeneratedVideo::where('taskid', $taskId)->count();
$task->status = 1;
$task->remark = "Task Executed Successfully ({$totalGenerated} videos generated)";
$task->save();

echo "Recovery complete. Saved {$savedCount} new videos. Total is now {$totalGenerated}.\n";
