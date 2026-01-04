<?php
/**
 * Cleanup Upload Logs for Missing Videos
 * Marks upload logs as failed if their video files don't exist
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "============================================================\n";
echo "UPLOAD LOGS CLEANUP\n";
echo "============================================================\n\n";

echo "Searching for upload logs with missing video files...\n\n";

$logs = \App\Models\InstagramUploadLog::whereIn('status', ['pending', 'processing'])->get();
$missing = [];
$existing = 0;

foreach ($logs as $log) {
    // Extract filename from video_path
    $filename = basename($log->video_path);
    $path = public_path('videos/generated_video/' . $filename);
    
    if (!file_exists($path)) {
        $missing[] = [
            'id' => $log->id,
            'filename' => $filename,
            'status' => $log->status
        ];
    } else {
        $existing++;
    }
}

echo "Found:\n";
echo "  ✅ Logs with existing videos: $existing\n";
echo "  ❌ Logs with missing videos: " . count($missing) . "\n\n";

if (count($missing) > 0) {
    echo "Upload logs with missing videos:\n";
    foreach ($missing as $m) {
        echo "  • Log ID: {$m['id']} - {$m['filename']} (status: {$m['status']})\n";
    }
    
    echo "\nMarking as failed...\n";
    
    // Mark as failed
    $ids = array_column($missing, 'id');
    $updated = \App\Models\InstagramUploadLog::whereIn('id', $ids)
        ->update([
            'status' => 'failed',
            'error_message' => 'Video file not found (deleted)'
        ]);
    
    echo "\n✅ Marked $updated upload logs as failed\n";
} else {
    echo "✅ No upload logs with missing videos found!\n";
}

echo "\n============================================================\n";
echo "Cleanup completed!\n";
echo "============================================================\n";
