<?php
// Database configuration
$host = '127.0.0.1';
$user = 'root';
$pass = ''; // Default XAMPP password
$db   = 'imgen';

$mysqli = new mysqli($host, $user, $pass, $db);

if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}

echo "Connected successfully\n";

// Get process list
$result = $mysqli->query("SHOW FULL PROCESSLIST");

if ($result) {
    while ($row = $result->fetch_assoc()) {
        $id = $row['Id'];
        $time = $row['Time'];
        $state = $row['State'];
        $info = $row['Info'];
        $command = $row['Command'];

        echo "Checking Process ID: $id | Time: $time | Command: $command | State: $state\n";

        // Kill any process that is Sleep or Query running longer than 30 seconds
        // Excluding the current process
        if ($id != $mysqli->thread_id && ($time > 30)) {
            echo "⚠️ KILLING Process $id (Stuck for $time seconds)\n";
            $mysqli->query("KILL $id");
        }
    }
    $result->free();
}

echo "✅ Stuck connections cleared.\n";
$mysqli->close();
?>
