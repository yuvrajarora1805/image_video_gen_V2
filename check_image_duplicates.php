<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\ImageGeneration;
use Illuminate\Support\Facades\DB;

echo "--- Checking generated_image duplicates ---\n";

// Check for duplicates based on logical uniqueness (e.g., same path/image name)
$duplicates = ImageGeneration::select('genarted_image', DB::raw('count(*) as total'))
    ->groupBy('genarted_image')
    ->having('total', '>', 1)
    ->limit(20)
    ->get();

if ($duplicates->isEmpty()) {
    echo "No duplicate filenames found in generated_image.\n";
} else {
    echo "Found duplicate filenames:\n";
    foreach ($duplicates as $dup) {
        echo "Filename: {$dup->genarted_image} - Count: {$dup->total}\n";
        
        $records = ImageGeneration::where('genarted_image', $dup->genarted_image)->get();
        foreach ($records as $r) {
             echo "   -> ID: {$r->id}, Sent: {$r->sent}, Created: {$r->created_at}\n";
        }
    }
}
