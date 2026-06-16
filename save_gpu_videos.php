<?php
/**
 * Simple GPU Result Saver
 * Directly saves videos from metadata file to database
 * Usage: php save_gpu_videos.php <task_id>
 */

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\GeneratedVideo;
use App\Models\Task;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

if ($argc < 2) {
    echo "Usage: php save_gpu_videos.php <task_id>\n";
    exit(1);
}

$taskId = $argv[1];

// Find metadata file
$metadataPattern = storage_path("app/gpu_tasks/task_{$taskId}_*.json");
$files = glob($metadataPattern);

if (empty($files)) {
    echo "No metadata file found for task {$taskId}\n";
    exit(1);
}

$metadataFile = $files[0];
echo "Using metadata file: {$metadataFile}\n";

$metadata = json_decode(file_get_contents($metadataFile), true);
if (!$metadata) {
    echo "Failed to parse metadata\n";
    exit(1);
}

echo "Found " . count($metadata) . " videos in metadata\n";

$savedCount = 0;
$skippedCount = 0;

foreach ($metadata as $item) {
    if (isset($item['meta'])) {
        $meta = $item['meta'];
        $outputPath = $meta['output_path'];
        
        // Check if file exists
        if (!file_exists($outputPath)) {
            echo "Video file not found: {$outputPath}\n";
            continue;
        }
        
        // Check if already in database
        $existing = GeneratedVideo::where('generated_path', $outputPath)->first();
        if ($existing) {
            echo "Already exists: {$meta['video_name']}\n";
            $skippedCount++;
            continue;
        }
        
        try {
            $video = new GeneratedVideo();
            $video->customer_id = $meta['customer_id'];
            $video->master_video_id = $meta['master_video_id'];
            $video->user_video_id = $meta['user_video_id'];
            $video->taskid = $meta['taskid'];
            $video->beforeid = $meta['beforeid'] ?? null;
            $video->generated_path = $outputPath;
            $video->generated_video = $meta['video_name'];
            $video->thumbnail = $meta['thumbnail_name'];
            $video->video_type = $meta['video_type'];
            $video->save();
            
            echo "✓ Saved: {$meta['video_name']}\n";
            $savedCount++;
        } catch (Exception $e) {
            echo "✗ Failed to save {$meta['video_name']}: " . $e->getMessage() . "\n";
        }
    }
}

echo "\nResults: {$savedCount} saved, {$skippedCount} skipped\n";

// Update task status
$task = Task::find($taskId);
if ($task && $savedCount > 0) {
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
        $task->status = 1;
        $task->remark = 'Task Executed Successfully';
        $task->finished_at = now();
        $task->save();
        echo "Task marked as completed ({$generated}/{$totalExpected} videos)\n";
    } else {
        echo "Task progress: {$generated}/{$totalExpected} videos\n";
    }
}

exit(0);
