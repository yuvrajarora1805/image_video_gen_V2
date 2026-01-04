$mysql = "D:\xamp\mysql\bin\mysql.exe"
$user = "root"

$output = & $mysql -u $user -e "SHOW PROCESSLIST" 2>&1

echo "Checking for stuck connections..."

$output | ForEach-Object {
    # Split by tab or pipe depending on formatting, usually mysql -e returns tab separated
    # Id | User | Host | db | Command | Time | State | Info
    $parts = $_ -split "\t"
    
    if ($parts.Count -gt 5) {
        $id = $parts[0]
        $time = $parts[5]
        $command = $parts[4]
        
        # Skip header
        if ($id -ne "Id" -and $time -match "^\d+$") {
            if ([int]$time -gt 30) {
                 echo "⚠️ Killing stuck process ID: $id (Time: $time, Cmd: $command)"
                 & $mysql -u $user -e "KILL $id"
            }
        }
    }
}

echo "Done."
