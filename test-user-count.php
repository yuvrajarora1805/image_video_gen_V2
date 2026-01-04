<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use App\Models\VideoTemplate;

echo "Testing VideoTemplate withUserCount scope:\n\n";

$template = VideoTemplate::withUserCount()
    ->where('video_templates.name', 'new temp')
    ->first();

if ($template) {
    echo "Template Name: {$template->name}\n";
    echo "User Count (from scope): {$template->user_count}\n";
} else {
    echo "Template not found\n";
}
