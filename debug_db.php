<?php
require __DIR__ . '/vendor/autoload.php';
$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\InstagramUploadLog;

$logs = InstagramUploadLog::orderBy('id', 'desc')->take(5)->get();

foreach ($logs as $log) {
    echo "ID: {$log->id}\n";
    echo "Platform: {$log->platform}\n";
    echo "Status: {$log->status}\n";
    echo "Container ID: {$log->media_container_id}\n";
    echo "Post ID: {$log->instagram_post_id}\n";
    echo "-------------------\n";
}
