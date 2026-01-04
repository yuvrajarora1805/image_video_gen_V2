<?php
/**
 * Execute pending video tasks
 */

require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Http\Controllers\VideoGenerationController;
use Illuminate\Http\Request;

echo "==============================================\n";
echo "Executing Pending Video Tasks\n";
echo "==============================================\n\n";

// Get pending tasks (status = 0)
$tasks = DB::table('task')
    ->where('task_type', 'video')
    ->where('status', 0)
    ->where('is_active', 1)
    ->orderBy('id', 'asc')
    ->get();

if ($tasks->isEmpty()) {
    echo "No pending tasks found.\n";
    exit;
}

echo "Found {$tasks->count()} pending task(s):\n\n";

foreach ($tasks as $task) {
    echo "Task ID: {$task->id}\n";
    echo "Task Name: {$task->taskname}\n";
    echo "Status: Pending\n";
    echo "Executing...\n";
    
    try {
        $controller = new VideoGenerationController();
        $response = $controller->executeVideoTask($task->id);
        $data = $response->getData();
        
        if ($data->success) {
            echo "✓ SUCCESS: {$data->message}\n";
        } else {
            echo "✗ FAILED: {$data->message}\n";
        }
    } catch (\Exception $e) {
        echo "✗ ERROR: {$e->getMessage()}\n";
    }
    
    echo "\n";
}

echo "==============================================\n";
echo "All tasks processed!\n";
echo "==============================================\n";
