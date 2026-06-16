<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\GeneratedVideo;
use App\Models\Task;

$taskId = 151;

echo "=== Importing Missing Videos for Task {$taskId} ===\n\n";

// Get recent video files (last 2 hours)
$videoDir = public_path('videos/generated_video');
$allFiles = glob($videoDir . '/*.mp4');
$recentFiles = [];

foreach ($allFiles as $file) {
    if (filemtime($file) > time() - 7200) { // Last 2 hours
        $recentFiles[] = [
            'path' => $file,
            'name' => basename($file),
            'time' => filemtime($file)
        ];
    }
}

echo "Found " . count($recentFiles) . " recent video files\n\n";

$imported = 0;
foreach ($recentFiles as $file) {
    // Check if already in DB
    $exists = GeneratedVideo::where('generated_video', $file['name'])->exists();
    
    if (!$exists) {
        echo "Importing: {$file['name']}\n";
        
        try {
            $video = new GeneratedVideo();
            $video->customer_id = 1; // Default - adjust as needed
            $video->master_video_id = 1; // Default
            $video->user_video_id = 1; // Default  
            $video->taskid = $taskId;
            $video->beforeid = 0;
            $video->generated_video = $file['name'];
            $video->generated_path = $file['path'];
            $video->thumbnail = 'thumb_' . pathinfo($file['name'], PATHINFO_FILENAME) . '.jpg';
            $video->video_type = 'landscape';
            $video->duration = 0;
            $video->file_size = filesize($file['path']);
            $video->sent = 0;
            $video->created_at = date('Y-m-d H:i:s', $file['time']);
            $video->updated_at = now();
            $video->save();
            
            $imported++;
            echo "  ✅ Imported\n";
        } catch (\Exception $e) {
            echo "  ❌ Error: " . $e->getMessage() . "\n";
        }
    }
}

echo "\n✅ Imported {$imported} videos\n";

// Update task status
$count = GeneratedVideo::where('taskid', $taskId)->count();
$task = Task::find($taskId);
if ($task && $count >= $task->totalvideos * 0.8) {
    $task->status = 1;
    $task->remark = "Completed ({$count}/{$task->totalvideos})";
    $task->finished_at = now();
    $task->save();
    echo "✅ Task marked as completed\n";
}
