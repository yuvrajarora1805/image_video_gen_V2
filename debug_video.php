<?php

use App\Models\Customer;
use App\Models\GeneratedVideo;
use App\Models\Task;

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$customerName = 'YA2';
$customer = Customer::where('name', 'LIKE', "%{$customerName}%")->first();

if (!$customer) {
    echo "Customer '{$customerName}' NOT FOUND.\n";
    exit;
}

echo "Customer Found: {$customer->name} (ID: {$customer->id})\n";

$videos = GeneratedVideo::where('customer_id', $customer->id)->get();
echo "Total Generated Videos for this customer: " . $videos->count() . "\n";

if ($videos->count() > 0) {
    foreach ($videos as $video) {
        $task = Task::find($video->taskid);
        $taskStatus = $task ? $task->status : 'NULL';
        $sentStatus = $video->sent ? 'SENT (1)' : 'UNSENT (0)';
        
        echo " - Video ID: {$video->id} | Task ID: {$video->taskid} (Status: {$taskStatus}) | Send Status: {$sentStatus}\n";
    }
} else {
    echo "No videos found for this customer.\n";
}

echo "\n----------------SUMMARY----------------\n";
echo "Customer: {$customer->name} (ID: {$customer->id})\n";
echo "Total Videos: " . $videos->count() . "\n";
echo "---------------------------------------\n";
