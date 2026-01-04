<?php
/**
 * Check VideoTask03 Configuration
 */

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "==============================================\n";
echo "VideoTask03 Configuration Check\n";
echo "==============================================\n\n";

// Get task
$task = DB::table('task')->where('taskname', 'VideoTask03')->first();

if (!$task) {
    die("Task not found!\n");
}

echo "Task ID: {$task->id}\n";
echo "Task Name: {$task->taskname}\n";
echo "Status: {$task->status}\n\n";

// Get before_genration data
$beforeGen = DB::table('before_genration')
    ->where('taskid', $task->id)
    ->where('content_type', 'video')
    ->first();

if (!$beforeGen) {
    die("No before_genration data found!\n");
}

echo "Master Template ID: {$beforeGen->mastertemplateid}\n";
echo "Background Video: {$beforeGen->backgroundimage}\n\n";

// Get customer templates assigned to this master template
$customerTemplates = DB::table('templates_by_user')
    ->where('master_template_id', $beforeGen->mastertemplateid)
    ->where('content_type', 'video')
    ->get();

echo "==============================================\n";
echo "Customer Templates Assigned:\n";
echo "==============================================\n";
echo "Total: {$customerTemplates->count()}\n\n";

foreach ($customerTemplates as $index => $template) {
    $customer = DB::table('customers')->where('id', $template->customer_id)->first();
    echo ($index + 1) . ". Customer ID: {$template->customer_id}\n";
    echo "   Customer Name: " . ($customer ? $customer->name : 'Unknown') . "\n";
    echo "   Template File: {$template->customer_template}\n";
    echo "   Template ID: {$template->id}\n\n";
}

// Check generated videos
$generatedVideos = DB::table('generated_videos')
    ->where('taskid', $task->id)
    ->count();

echo "==============================================\n";
echo "Generated Videos: {$generatedVideos}\n";
echo "==============================================\n";

if ($generatedVideos > 0) {
    $videos = DB::table('generated_videos')
        ->where('taskid', $task->id)
        ->get();
    
    foreach ($videos as $index => $video) {
        echo ($index + 1) . ". Video: {$video->generated_video}\n";
        echo "   Customer ID: {$video->customer_id}\n";
        echo "   Sent: " . ($video->sent ? 'Yes' : 'No') . "\n\n";
    }
}

echo "\n==============================================\n";
echo "Summary:\n";
echo "==============================================\n";
echo "Expected Videos (based on templates): {$customerTemplates->count()}\n";
echo "Actually Generated: {$generatedVideos}\n";
echo "Pending: " . ($customerTemplates->count() - $generatedVideos) . "\n";
