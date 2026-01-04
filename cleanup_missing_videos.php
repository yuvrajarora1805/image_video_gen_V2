<?php
/**
 * Cleanup Missing Videos
 * Marks videos as sent if their files don't exist
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "============================================================\n";
echo "VIDEO DATABASE CLEANUP\n";
echo "============================================================\n\n";

echo "Searching for videos in database that don't exist on disk...\n\n";

$videos = \App\Models\GeneratedVideo::where('sent', 0)->get();
$missing = [];
$existing = 0;

foreach ($videos as $video) {
    $path = public_path('videos/generated_video/' . $video->generated_video);
    if (!file_exists($path)) {
        $missing[] = [
            'id' => $video->id,
            'filename' => $video->generated_video,
            'customer_id' => $video->customer_id
        ];
    } else {
        $existing++;
    }
}

echo "Found:\n";
echo "  ✅ Existing videos: $existing\n";
echo "  ❌ Missing videos: " . count($missing) . "\n\n";

if (count($missing) > 0) {
    echo "Missing videos:\n";
    foreach ($missing as $m) {
        echo "  • ID: {$m['id']} - {$m['filename']}\n";
    }
    
    echo "\nMarking missing videos as sent...\n";
    
    // Mark as sent
    $ids = array_column($missing, 'id');
    $updated = \App\Models\GeneratedVideo::whereIn('id', $ids)->update(['sent' => 1]);
    
    echo "\n✅ Marked $updated missing videos as sent\n";
} else {
    echo "✅ No missing videos found!\n";
}

echo "\n============================================================\n";
echo "Cleanup completed!\n";
echo "Refresh the master uploader page - missing videos won't show\n";
echo "============================================================\n";
