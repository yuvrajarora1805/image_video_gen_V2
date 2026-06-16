<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use App\Models\ImageGeneration;
use Illuminate\Support\Facades\DB;

echo "--- Testing Image Status Update ---\n";

// Find an unsent image to test
$image = ImageGeneration::where('sent', 0)->orderBy('id', 'desc')->first();

if (!$image) {
    die("No unsent images found to test.\n");
}

echo "Testing with Image ID: {$image->id}\n";
echo "Current Sent Status: {$image->sent}\n";

try {
    $currentDateTime = now();
    $updateData = [
        'sent' => 1,
        'sent_date' => $currentDateTime,
    ];
    
    // Simulate the exact logic from ApiController
    if ($image->update($updateData)) {
        echo "Update SUCCESSFUL.\n";
        
        // Refresh to verify
        $image->refresh();
        echo "New Sent Status: {$image->sent}\n";
        echo "Sent Date: {$image->sent_date}\n";
        
        // Revert changes for cleanliness
        $image->update(['sent' => 0, 'sent_date' => null]);
        echo "Reverted changes.\n";
    } else {
        echo "Update FAILED.\n";
    }
} catch (\Exception $e) {
    echo "Exception during update: " . $e->getMessage() . "\n";
}
