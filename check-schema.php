<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "==============================================\n";
echo "Generated Videos Table Schema\n";
echo "==============================================\n\n";

$columns = DB::select("DESCRIBE generated_videos");

foreach ($columns as $column) {
    echo sprintf("%-25s %-15s %s\n", 
        $column->Field, 
        $column->Type, 
        $column->Null == 'YES' ? 'NULL' : 'NOT NULL'
    );
}

echo "\n==============================================\n";
echo "Sample Data (if any):\n";
echo "==============================================\n";

$count = DB::table('generated_videos')->count();
echo "Total records: {$count}\n\n";

if ($count > 0) {
    $sample = DB::table('generated_videos')->first();
    print_r($sample);
}
