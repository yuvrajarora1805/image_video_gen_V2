<?php
/**
 * Mark Stuck Pending Uploads as Failed
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "============================================================\n";
echo "MARKING STUCK PENDING UPLOADS AS FAILED\n";
echo "============================================================\n\n";

// Find uploads that have been pending for more than 5 minutes
$fiveMinutesAgo = now()->subMinutes(5);

$stuckUploads = \App\Models\InstagramUploadLog::where('status', 'pending')
    ->where('created_at', '<', $fiveMinutesAgo)
    ->get();

echo "Found " . $stuckUploads->count() . " stuck pending uploads\n\n";

if ($stuckUploads->count() > 0) {
    foreach ($stuckUploads as $upload) {
        echo "  • Log ID: {$upload->id} - {$upload->platform} - " . 
             basename($upload->video_path) . " (pending for " . 
             $upload->created_at->diffForHumans() . ")\n";
    }
    
    echo "\nMarking as failed...\n";
    
    $updated = \App\Models\InstagramUploadLog::where('status', 'pending')
        ->where('created_at', '<', $fiveMinutesAgo)
        ->update([
            'status' => 'failed',
            'error_message' => 'Upload timed out - stuck in pending status'
        ]);
    
    echo "\n✅ Marked $updated uploads as failed\n";
} else {
    echo "✅ No stuck uploads found!\n";
}

echo "\n============================================================\n";
echo "Done! Refresh the upload history page.\n";
echo "============================================================\n";
