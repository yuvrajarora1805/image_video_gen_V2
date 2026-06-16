<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\DB;

$customerName = $_GET['customer'] ?? 'B90 KRISHNA BANSAL BJP LONI GZB';

echo "<html><body style='font-family: Arial; padding: 20px;'>";
echo "<h2>Diagnosing Duplicates for: {$customerName}</h2>";

$customer = DB::table('customers')->where('name', 'LIKE', '%' . $customerName . '%')->first();

if (!$customer) {
    echo "Customer not found.<br>";
    exit;
}

echo "Customer ID: <b>{$customer->id}</b><br><br>";

echo "<h3>1. Check Templates Assigned to this Customer</h3>";
$templates = DB::select("SELECT master_template_id, content_type, COUNT(*) as count FROM templates_by_user WHERE customer_id = ? GROUP BY master_template_id, content_type", [$customer->id]);
foreach($templates as $t) {
    if ($t->count > 1) {
        echo "<span style='color:red;'>WARNING: Master Template {$t->master_template_id} ({$t->content_type}) is assigned {$t->count} times to this customer!</span><br>";
    } else {
        echo "Template {$t->master_template_id} ({$t->content_type}) is assigned once. (OK)<br>";
    }
}

echo "<h3>2. Check Generated Images for this Customer</h3>";
$generations = DB::select("SELECT taskid, COUNT(*) as copies, MIN(created_at) as first_gen, MAX(created_at) as last_gen FROM generated_image WHERE customer_id = ? GROUP BY taskid ORDER BY taskid DESC LIMIT 10", [$customer->id]);
foreach($generations as $g) {
    if ($g->copies > 1) {
        echo "<span style='color:red;'>Task {$g->taskid} generated {$g->copies} images for this customer! (Between {$g->first_gen} and {$g->last_gen})</span><br>";
    } else {
        echo "Task {$g->taskid} generated 1 image. (OK)<br>";
    }
}

echo "<h3>3. Check if Master Templates were queued multiple times in the SAME task</h3>";
$dupTasks = DB::select("SELECT taskid, mastertemplateid, COUNT(*) as copies FROM before_genration GROUP BY taskid, mastertemplateid HAVING copies > 1 LIMIT 10");
if (count($dupTasks) > 0) {
    foreach($dupTasks as $d) {
        echo "<span style='color:red;'>In Task {$d->taskid}, Master Template {$d->mastertemplateid} was added to the queue {$d->copies} times!</span><br>";
    }
} else {
    echo "No duplicate templates found inside any single task. (OK)<br>";
}

echo "</body></html>";
