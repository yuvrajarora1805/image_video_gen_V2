<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "==============================================\n";
echo "Checking 'new temp' Template\n";
echo "==============================================\n\n";

// Find the template
$template = DB::table('video_templates')->where('name', 'new temp')->first();

if (!$template) {
    die("Template 'new temp' not found!\n");
}

echo "Template ID: {$template->id}\n";
echo "Template Name: {$template->name}\n\n";

// Check how many customer templates are assigned
$customerTemplates = DB::table('templates_by_user')
    ->where('master_template_id', $template->id)
    ->where('content_type', 'video')
    ->get();

echo "==============================================\n";
echo "Customer Templates Assigned (content_type='video'):\n";
echo "==============================================\n";
echo "Total: {$customerTemplates->count()}\n\n";

foreach ($customerTemplates as $index => $ct) {
    $customer = DB::table('customers')->where('id', $ct->customer_id)->first();
    echo ($index + 1) . ". Customer ID: {$ct->customer_id}\n";
    echo "   Customer Name: " . ($customer ? $customer->name : 'Unknown') . "\n";
    echo "   Template File: {$ct->customer_template}\n";
    echo "   Template ID: {$ct->id}\n\n";
}

// Check if there are any tasks using this template
$tasks = DB::table('before_genration')
    ->where('mastertemplateid', $template->id)
    ->where('content_type', 'video')
    ->get();

echo "==============================================\n";
echo "Tasks Using This Template:\n";
echo "==============================================\n";
echo "Total: {$tasks->count()}\n\n";

foreach ($tasks as $task) {
    $taskInfo = DB::table('task')->where('id', $task->taskid)->first();
    echo "Task ID: {$task->taskid}\n";
    echo "Task Name: " . ($taskInfo ? $taskInfo->taskname : 'Unknown') . "\n";
    echo "Background Video: {$task->backgroundimage}\n\n";
}
