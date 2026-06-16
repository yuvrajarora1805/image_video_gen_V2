<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\Task;
use Illuminate\Support\Facades\DB;

if (!isset($_GET['task_name'])) {
    echo "Usage: Please add ?task_name=VideoTask12 to the URL.<br>";
    exit(1);
}

$taskName = $_GET['task_name'];
$task = Task::where('taskname', $taskName)->first();

if (!$task) {
    echo "Task not found.\n";
    exit;
}

$taskId = $task->id;
$logFile = storage_path("logs/gpu_task_{$taskId}.log");
if (!file_exists($logFile)) {
    echo "Log file not found: {$logFile}\n";
    exit;
}

$jsonDir = storage_path('app/gpu_tasks');
$files = glob($jsonDir . "/task_{$taskId}_*.json");
if (empty($files)) {
    echo "Metadata JSON file not found.\n";
    exit;
}

rsort($files);
$metadataFile = $files[0];

$logContent = file_get_contents($logFile);
$metadata = json_decode(file_get_contents($metadataFile), true);

$metaMap = [];
foreach ($metadata as $item) {
    $metaMap[basename($item['output'])] = $item['meta'];
}

$sqlFile = "recovery_task_{$taskId}.sql";
$sqlContent = "-- SQL Recovery for Task {$taskId}\n";
$sqlContent .= "-- Run this in phpMyAdmin or your MySQL client\n\n";

$savedCount = 0;
if (preg_match('/RESULTS_JSON_START\s+(.*?)\s+RESULTS_JSON_END/s', $logContent, $jsonMatches)) {
    $jsonResults = json_decode($jsonMatches[1], true);
    if (is_array($jsonResults)) {
        foreach ($jsonResults as $res) {
            if (!empty($res['success']) && !empty($res['output'])) {
                $filename = basename($res['output']);
                if (isset($metaMap[$filename])) {
                    $meta = $metaMap[$filename];
                    
                    // Check if exists first to avoid duplicates
                    $existing = DB::table('generated_videos')->where('generated_video', $meta['video_name'])->first();
                    if (!$existing) {
                        $now = date('Y-m-d H:i:s');
                        // Escape strings for safe SQL
                        $customer_id = (int)$meta['customer_id'];
                        $master_id = (int)$meta['master_video_id'];
                        $user_video_id = (int)$meta['user_video_id'];
                        $task_id = (int)$meta['taskid'];
                        $beforeid = (int)$meta['beforeid'];
                        $video_name = addslashes($meta['video_name']);
                        $path = addslashes($meta['output_path']);
                        $thumb = addslashes($meta['thumbnail_name']);
                        $type = addslashes($meta['video_type']);
                        $duration = (float)($res['time'] ?? 0);
                        $size = (float)($res['size'] ?? 0);
                        
                        $sqlContent .= "INSERT INTO generated_videos ";
                        $sqlContent .= "(customer_id, master_video_id, user_video_id, taskid, beforeid, generated_video, generated_path, thumbnail, video_type, duration, file_size, sent, created_at, updated_at) ";
                        $sqlContent .= "VALUES ($customer_id, $master_id, $user_video_id, $task_id, $beforeid, '$video_name', '$path', '$thumb', '$type', $duration, $size, 0, '$now', '$now');\n";
                        $savedCount++;
                    }
                }
            }
        }
    }
}

$sqlContent .= "\n-- Update task status\n";
$sqlContent .= "UPDATE task SET status = 1, remark = 'Task Executed Successfully ({$savedCount} videos recovered)' WHERE id = {$taskId};\n";

echo "<h3>Successfully generated SQL for {$savedCount} videos!</h3>";
echo "<p>Copy the code below and paste it into your MySQL CLI or phpMyAdmin:</p>";
echo "<textarea style='width:100%; height:500px;'>" . htmlspecialchars($sqlContent) . "</textarea>";
