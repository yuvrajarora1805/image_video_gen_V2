<?php

use App\Models\InstagramUploadLog;

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$logs = InstagramUploadLog::where('status', 'failed')
    ->orderBy('id', 'desc')
    ->take(5)
    ->get();

echo "---------------- ERROR LOGS ----------------\n";
if ($logs->isEmpty()) {
    echo "No failed logs found.\n";
} else {
    foreach ($logs as $log) {
        echo "[Log ID: {$log->id}] [Platform: {$log->platform}]\n";
        echo "Error: {$log->error_message}\n";
        echo "--------------------------------------------\n";
    }
}
