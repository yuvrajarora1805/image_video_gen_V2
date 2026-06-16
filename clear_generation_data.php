<?php
/**
 * Script to clear unwanted generation data from the database.
 * Run via command line: php clear_generation_data.php
 */

require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\DB;

echo "=========================================\n";
echo "  DATABASE GENERATION CLEANUP TOOL\n";
echo "=========================================\n\n";

echo "Select an option:\n";
echo "1. Delete ONLY records with missing files (Safe)\n";
echo "2. TRUNCATE ALL generated videos and images (Keeps tasks)\n";
echo "3. TRUNCATE EVERYTHING (Tasks, Queues, Videos, Images)\n";
echo "Enter choice (1/2/3): ";

$handle = fopen ("php://stdin","r");
$line = fgets($handle);
$choice = trim($line);

if ($choice == '1') {
    echo "\nCleaning up records with missing files...\n";
    
    // Clean Videos
    $videos = DB::table('generated_videos')->get();
    $deletedVideos = 0;
    foreach ($videos as $video) {
        $path = public_path('videos/generated_video/' . $video->generated_video);
        if (!file_exists($path)) {
            DB::table('generated_videos')->where('id', $video->id)->delete();
            $deletedVideos++;
        }
    }
    
    // Clean Images
    $images = DB::table('generated_image')->get();
    $deletedImages = 0;
    foreach ($images as $image) {
        $path = public_path('images/generated_image/' . $image->genarted_image);
        if (!file_exists($path)) {
            DB::table('generated_image')->where('id', $image->id)->delete();
            $deletedImages++;
        }
    }
    
    echo "✅ Deleted $deletedVideos video records that were missing files.\n";
    echo "✅ Deleted $deletedImages image records that were missing files.\n";

} elseif ($choice == '2') {
    echo "\nTruncating generated_videos and generated_image tables...\n";
    DB::statement('SET FOREIGN_KEY_CHECKS=0;');
    DB::table('generated_videos')->truncate();
    DB::table('generated_image')->truncate();
    DB::statement('SET FOREIGN_KEY_CHECKS=1;');
    echo "✅ All generated images and videos have been cleared from the database.\n";

} elseif ($choice == '3') {
    echo "\nTruncating all generation-related tables...\n";
    DB::statement('SET FOREIGN_KEY_CHECKS=0;');
    DB::table('generated_videos')->truncate();
    DB::table('generated_image')->truncate();
    DB::table('task')->truncate();
    DB::table('before_genration')->truncate();
    DB::table('tempgeneration')->truncate();
    DB::statement('SET FOREIGN_KEY_CHECKS=1;');
    echo "✅ Complete wipe of all tasks, queue, and generated files data finished.\n";

} else {
    echo "Invalid choice. Exiting...\n";
}
echo "\nDone!\n";
