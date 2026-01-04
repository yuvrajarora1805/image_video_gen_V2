<?php
// Quick reset for VideoTask03 (Task ID 22)
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$task = \App\Models\Task::find(22);
if ($task) {
    $task->status = 0;
    $task->remark = 'Pending Execution';
    $task->finished_at = null;
    $task->save();
    echo "✓ VideoTask03 (ID: 22) reset successfully!\n";
    echo "Status: Pending\n";
    echo "Now go to http://localhost:8000/generate-videos and click Execute\n";
} else {
    echo "✗ Task 22 not found\n";
}
