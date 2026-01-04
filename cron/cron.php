<?php

$servername = "localhost";
$username = "rannlab";
$password = "AQ^M-TIZiWUR";
$dbname = "img_generation";
$publicFolderPath = 'public/img/generated_image';

$conn = new mysqli($servername, $username, $password, $dbname);


if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

function updateAndDelete($conn, $table, $folderPath = null) {
  
    $sql = "SELECT id, file_name FROM $table WHERE created_at < NOW() - INTERVAL 5 DAY AND is_active = 1";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $updateSql = "UPDATE $table SET is_active = 0 WHERE id = ?";
            $stmt = $conn->prepare($updateSql);
            $stmt->bind_param("i", $row['id']);
            $stmt->execute();

            if ($folderPath && !empty($row['file_name'])) {
                $filePath = $folderPath . DIRECTORY_SEPARATOR . $row['file_name'];
                if (is_file($filePath)) {
                    unlink($filePath);
                    echo "Deleted file: $filePath\n";
                }
            }
        }
    }
}

updateAndDelete($conn, 'generated_image', $publicFolderPath);

updateAndDelete($conn, 'before_generation');

updateAndDelete($conn, 'task');

$conn->close();
echo "Cleanup and database update completed successfully.\n";
?>
