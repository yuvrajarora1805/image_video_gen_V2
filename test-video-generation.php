<?php
/**
 * Test Video Generation Script
 * This script fetches actual data from task 20 and tests the Python video generator
 */

require __DIR__.'/vendor/autoload.php';

$app = require_once __DIR__.'/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "==============================================\n";
echo "Video Generation Test Script\n";
echo "==============================================\n\n";

// Get task data
$taskId = 20;
echo "Fetching data for Task ID: {$taskId}\n\n";

// Get background video info
$beforeGen = DB::table('before_genration')
    ->where('taskid', $taskId)
    ->where('content_type', 'video')
    ->first();

if (!$beforeGen) {
    die("ERROR: No video task data found for task {$taskId}\n");
}

echo "Background Video File: {$beforeGen->backgroundimage}\n";
echo "Master Template ID: {$beforeGen->mastertemplateid}\n\n";

// Get customer templates
$customerTemplates = DB::table('templates_by_user')
    ->where('master_template_id', $beforeGen->mastertemplateid)
    ->where('content_type', 'video')
    ->get();

if ($customerTemplates->isEmpty()) {
    die("ERROR: No customer templates found for master template {$beforeGen->mastertemplateid}\n");
}

echo "Found {$customerTemplates->count()} customer template(s)\n\n";

// Get first customer template for testing
$firstTemplate = $customerTemplates->first();
echo "Testing with first customer template:\n";
echo "  Customer ID: {$firstTemplate->customer_id}\n";
echo "  Template File: {$firstTemplate->customer_template}\n\n";

// Build file paths
$bgVideoPath = public_path('videos/background_video/' . $beforeGen->backgroundimage);
$templatePath = public_path('img/user_template/' . $firstTemplate->customer_template);
$outputPath = public_path('videos/generated_video/test_output_' . time() . '.mp4');

echo "==============================================\n";
echo "File Paths:\n";
echo "==============================================\n";
echo "Background Video: {$bgVideoPath}\n";
echo "Template Image:   {$templatePath}\n";
echo "Output Video:     {$outputPath}\n\n";

// Check if files exist
echo "==============================================\n";
echo "File Existence Check:\n";
echo "==============================================\n";

$bgExists = file_exists($bgVideoPath);
$templateExists = file_exists($templatePath);

echo "Background Video: " . ($bgExists ? "✓ EXISTS" : "✗ NOT FOUND") . "\n";
echo "Template Image:   " . ($templateExists ? "✓ EXISTS" : "✗ NOT FOUND") . "\n\n";

if (!$bgExists || !$templateExists) {
    die("ERROR: Required files are missing. Cannot proceed with test.\n");
}

// Build Python command
$pythonScript = base_path('video_generator.py');
$command = sprintf(
    'python "%s" "%s" "%s" "%s"',
    $pythonScript,
    $bgVideoPath,
    $templatePath,
    $outputPath
);

echo "==============================================\n";
echo "Python Command:\n";
echo "==============================================\n";
echo $command . "\n\n";

echo "==============================================\n";
echo "Executing Python Script...\n";
echo "==============================================\n\n";

// Execute the command
$startTime = microtime(true);
exec($command . ' 2>&1', $output, $returnCode);
$endTime = microtime(true);
$executionTime = round($endTime - $startTime, 2);

// Display output
echo "Python Output:\n";
echo "---\n";
echo implode("\n", $output) . "\n";
echo "---\n\n";

echo "Return Code: {$returnCode}\n";
echo "Execution Time: {$executionTime} seconds\n\n";

// Check if output file was created
$outputExists = file_exists($outputPath);
echo "Output File Created: " . ($outputExists ? "✓ YES" : "✗ NO") . "\n";

if ($outputExists) {
    $fileSize = filesize($outputPath);
    $fileSizeMB = round($fileSize / 1024 / 1024, 2);
    echo "Output File Size: {$fileSizeMB} MB\n";
}

echo "\n==============================================\n";
if ($returnCode === 0 && $outputExists) {
    echo "✓ TEST PASSED - Video generated successfully!\n";
} else {
    echo "✗ TEST FAILED - Video generation failed\n";
}
echo "==============================================\n";
