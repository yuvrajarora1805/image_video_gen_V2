<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "==============================================\n";
echo "VideoTask09 (Task ID: 28) - Verification\n";
echo "==============================================\n\n";

$videos = DB::table('generated_videos')->where('taskid', 28)->get();

echo "Total Videos Generated: {$videos->count()}\n\n";

foreach ($videos as $i => $v) {
    $customer = DB::table('customers')->where('id', $v->customer_id)->first();
    
    echo ($i+1) . ". Video ID: {$v->id}\n";
    echo "   Customer: " . ($customer ? $customer->name : 'Unknown') . " (ID: {$v->customer_id})\n";
    echo "   Video File: {$v->generated_video}\n";
    echo "   File Size: " . round($v->file_size/1024/1024, 2) . " MB\n";
    echo "   Duration: {$v->duration}s\n";
    echo "   Sent: " . ($v->sent ? 'Yes' : 'No') . "\n";
    echo "   Created: {$v->created_at}\n\n";
}

echo "==============================================\n";
echo "✓ VideoTask09 successfully generated {$videos->count()} videos!\n";
echo "==============================================\n";
