# Complete API Workflow Example
# This demonstrates the exact workflow your external system should follow

$baseUrl = "http://127.0.0.1:8000"

Write-Host "`n=== STEP 1: GET TASK LIST ===" -ForegroundColor Cyan
$tasks = Invoke-RestMethod "$baseUrl/api/task-list"
Write-Host "Found $($tasks.Count) tasks with generated images`n"
$tasks | Format-Table id, taskname, totalimage, send, pending

# Pick first task with pending images
$task = $tasks | Where-Object { $_.pending -gt 0 } | Select-Object -First 1

if (-not $task) {
    Write-Host "No tasks with pending images!" -ForegroundColor Yellow
    exit
}

Write-Host "`n=== STEP 2: GET SUBTASKS FOR TASK $($task.id) ===" -ForegroundColor Cyan
$subtasks = Invoke-RestMethod "$baseUrl/api/subtask-list?taskid=$($task.id)"
Write-Host "Found $($subtasks.Count) subtasks`n"
$subtasks | Format-Table id, mastertemplateid, backgroundimage

if ($subtasks.Count -eq 0) {
    Write-Host "No subtasks found!" -ForegroundColor Yellow
    exit
}

Write-Host "`n=== STEP 3: GET IMAGES FOR EACH SUBTASK ===" -ForegroundColor Cyan
$allImages = @()
foreach ($subtask in $subtasks) {
    $images = Invoke-RestMethod "$baseUrl/api/image-list?subtaskid=$($subtask.id)"
    if ($images -and $images.Count -gt 0) {
        Write-Host "Subtask $($subtask.id): Found $($images.Count) images"
        $allImages += $images
    }
}

Write-Host "`nTotal images to download: $($allImages.Count)`n"
$allImages | Format-Table id, genarted_image, customer_id, sent

Write-Host "`n=== STEP 4: DOWNLOAD IMAGES ===" -ForegroundColor Cyan
foreach ($image in $allImages) {
    $imageUrl = "$baseUrl/img/generated_image/$($image.genarted_image)"
    $savePath = "downloaded_$($image.genarted_image)"
    
    Write-Host "Downloading: $imageUrl" -ForegroundColor Gray
    try {
        Invoke-WebRequest $imageUrl -OutFile $savePath -UseBasicParsing
        Write-Host "  ✓ Saved to: $savePath" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== STEP 5: MARK IMAGES AS SENT ===" -ForegroundColor Cyan
foreach ($image in $allImages) {
    Write-Host "Marking image $($image.id) as sent..." -ForegroundColor Gray
    
    $body = @{ imageid = $image.id } | ConvertTo-Json
    
    try {
        $response = Invoke-RestMethod "$baseUrl/api/update-image-status" `
            -Method Post `
            -Body $body `
            -ContentType "application/json"
        Write-Host "  ✓ $($response.message)" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`n=== VERIFICATION ===" -ForegroundColor Cyan
Write-Host "Checking task status after marking as sent...`n"
$updatedTask = Invoke-RestMethod "$baseUrl/api/task-list" | Where-Object { $_.id -eq $task.id }
$updatedTask | Format-Table id, taskname, totalimage, send, pending

Write-Host "`n=== COMPLETE ===" -ForegroundColor Green
