<?php

use App\Models\Customer;
use App\Models\InstagramCredential;

require __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

$customerName = 'YA2';
$customer = Customer::where('name', 'LIKE', "%{$customerName}%")->first();

if (!$customer) {
    echo "Customer '{$customerName}' NOT FOUND.\n";
    exit;
}

echo "Customer: {$customer->name} (ID: {$customer->id})\n";

$credentials = InstagramCredential::where('customer_id', $customer->id)->get();

if ($credentials->isEmpty()) {
    echo "No individual credentials found for this customer.\n";
} else {
    foreach ($credentials as $cred) {
        echo "Credential ID: {$cred->id}\n";
        echo "Name: {$cred->credential_name}\n";
        $content = "Page ID: {$cred->facebook_page_id}\n";
        $content .= "Access Token: {$cred->access_token}\n";
        file_put_contents('ya2_creds.txt', $content);
        echo "Credentials saved to ya2_creds.txt\n";
    }
}
