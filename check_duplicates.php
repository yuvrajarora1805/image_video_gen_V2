<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\TemplatesByUser;
use Illuminate\Support\Facades\DB;

$output = "";

$output .= "--- Checking templates_by_user duplicates ---\n";
$duplicates = TemplatesByUser::select('customer_id', 'master_template_id', DB::raw('count(*) as total'))
    ->groupBy('customer_id', 'master_template_id')
    ->having('total', '>', 1)
    ->get();

if ($duplicates->isEmpty()) {
    $output .= "No duplicates found based on (customer_id, master_template_id).\n";
} else {
    $output .= "Found duplicates:\n";
    foreach ($duplicates as $dup) {
        $output .= "Customer: {$dup->customer_id}, MasterTpl: {$dup->master_template_id}, Count: {$dup->total}\n";
        
        $records = TemplatesByUser::where('customer_id', $dup->customer_id)
            ->where('master_template_id', $dup->master_template_id)
            ->orderBy('created_at', 'desc')
            ->get();
            
        foreach ($records as $rec) {
             $output .= "   -> ID: {$rec->id}, Created: {$rec->created_at}, File: {$rec->customer_template}\n";
        }
    }
}

file_put_contents('duplicates_report.txt', $output);
echo "Report written to duplicates_report.txt\n";
