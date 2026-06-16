<!DOCTYPE html>
<html>
<head>
<title>Server Diagnostics</title>
<style>
body { font-family: -apple-system, system-ui, sans-serif; background: #f0f2f5; padding: 20px; line-height: 1.5; }
.card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 20px; border-top: 4px solid #3182ce; }
h2 { margin-top: 0; color: #2d3748; }
.status { font-weight: bold; }
.success { color: #38a169; }
.error { color: #e53e3e; }
.warning { color: #d69e2e; }
code { background: #edf2f7; padding: 2px 6px; border-radius: 4px; font-family: 'Consolas', monospace; color: #4a5568; }
pre { background: #1a202c; color: #a0aec0; padding: 15px; border-radius: 8px; overflow-x: auto; }
.log-entry { margin-bottom: 5px; border-bottom: 1px solid #2d3748; padding-bottom: 2px; }
.btn { display: inline-block; background: #3182ce; color: white; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 500; }
</style>
</head>
<body>

<div class="card">
    <h2>1. URL Configuration</h2>
    <?php
    $protocol = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http");
    if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') $protocol = 'https';
    $host = $_SERVER['HTTP_HOST'];
    $filename = '/' . basename(__FILE__);
    $path = str_replace($filename, '', $_SERVER['SCRIPT_NAME']);
    $baseUrl = $protocol . "://" . $host . rtrim($path, '/');
    echo "<p>Recommended <code>APP_URL</code>: <strong>$baseUrl</strong></p>";
    ?>
    <a href="<?php echo $baseUrl; ?>/optimize" class="btn" target="_blank">Clear Cache</a>
</div>

<div class="card">
    <h2>2. Environment Check (Web Server User)</h2>
    
    <p><strong>PHP Version:</strong> <?php echo phpversion(); ?></p>
    
    <p><strong>FFmpeg Check:</strong> 
    <?php
    // Attempt to run FFmpeg
    $output = [];
    $return = -1;
    // Check PATH
    exec('ffmpeg -version 2>&1', $output, $return);
    
    if ($return === 0) {
        echo "<span class='status success'>DETECTED ✅</span>";
        echo "<br><small>" . substr($output[0], 0, 60) . "...</small>";
    } else {
        echo "<span class='status error'>NOT FOUND ❌</span>";
        echo "<br><small>If you installed it, restart Apache! Or set <code>FFMPEG_PATH</code> in .env</small>";
        echo "<br><code>Output: " . implode("\n", $output) . "</code>";
    }
    ?>
    </p>

    <p><strong>Python Check:</strong> 
    <?php
    $output = [];
    $return = -1;
    exec('python --version 2>&1', $output, $return);
    
    if ($return === 0) {
        echo "<span class='status success'>DETECTED ✅</span>";
        echo "<br><small>" . implode(" ", $output) . "</small>";
    } else {
        // Try 'python3'
        exec('python3 --version 2>&1', $output, $return);
        if ($return === 0) {
            echo "<span class='status success'>DETECTED (as python3) ✅</span>";
        } else {
             echo "<span class='status error'>NOT FOUND ❌</span>";
             echo "<br><small>Set <code>PYTHON_PATH</code> in .env to full path (e.g. C:\Python39\python.exe)</small>";
        }
    }
    ?>
    </p>
</div>

<div class="card">
    <h2>3. Recent Task Logs</h2>
    <p>Showing last 5 GPU logs from <code>storage/logs/</code>:</p>
    <?php
    // Go up two levels to find storage (public -> public_html -> ??? Wait, structure varies)
    // Assume standard Laravel: public/../storage
    $baseDir = __DIR__;
    $storageLogs = realpath($baseDir . '/../storage/logs');
    
    if (!$storageLogs || !is_dir($storageLogs)) {
        // Try going up one more level if double public_html
        $storageLogs = realpath($baseDir . '/../../storage/logs');
    }
    
    if ($storageLogs && is_dir($storageLogs)) {
        $files = glob($storageLogs . '/gpu_task_*.log');
        if ($files) {
            usort($files, function($a, $b) { return filemtime($b) - filemtime($a); }); // Sort by newest
            $files = array_slice($files, 0, 5);
            
            foreach ($files as $file) {
                echo "<h3>📄 " . basename($file) . " (" . date("H:i:s", filemtime($file)) . ")</h3>";
                $content = file_get_contents($file);
                // Get last 20 lines
                $lines = explode("\n", $content);
                $lines = array_slice($lines, -20);
                echo "<pre>";
                foreach ($lines as $line) {
                    echo "<div class='log-entry'>" . htmlspecialchars($line) . "</div>";
                }
                echo "</pre>";
            }
        } else {
            echo "<p>No 'gpu_task_*.log' files found. Tasks might not have started python.</p>";
        }
    } else {
        echo "<p class='error'>Could not locate storage/logs directory.</p>";
    }
    ?>
</div>

</body>
</html>
