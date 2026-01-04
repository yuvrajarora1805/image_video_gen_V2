<?php

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Update the task status
$updated = DB::table('tasks')
    ->where('id', 20)
    ->update([
        'status' => 0,
        'remark' => 'Pending Execution',
        'finished_at' => null
    ]);

echo "Task updated: {$updated} row(s) affected\n";

// Verify the update
$task = DB::table('tasks')->where('id', 20)->first();
echo "Current Status: {$task->status}\n";
echo "Current Remark: {$task->remark}\n";
echo "Finished At: " . ($task->finished_at ?? 'NULL') . "\n";
