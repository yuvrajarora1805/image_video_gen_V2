# API Testing Script for Image Generator
# Base URL
$baseUrl = "http://127.0.0.1:8000/api"

Write-Host "`n=== TESTING IMAGE GENERATOR API ===" -ForegroundColor Cyan

# Test 1: Get Task List
Write-Host "`n1. Testing /api/task-list" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/task-list" -Method Get
    Write-Host "   Found $($response.Count) tasks" -ForegroundColor Green
    $response | Select-Object -First 3 | Format-Table id, taskname, totalimage, send, pending
    
    # Save first task ID for next test
    $taskId = $response[0].id
    Write-Host "   Using Task ID: $taskId for next tests" -ForegroundColor Gray
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: Get Subtask List
Write-Host "`n2. Testing /api/subtask-list?taskid=$taskId" -ForegroundColor Yellow
try {
    $response = Invoke-RestMethod -Uri "$baseUrl/subtask-list?taskid=$taskId" -Method Get
    if ($response.Count -eq 0) {
        Write-Host "   No subtasks found (either not executed yet or already processed)" -ForegroundColor Yellow
    } else {
        Write-Host "   Found $($response.Count) subtasks" -ForegroundColor Green
        $response | Format-Table id, taskid, mastertemplateid, backgroundimage, status
        
        # Save first subtask ID
        $subtaskId = $response[0].id
        Write-Host "   Using Subtask ID: $subtaskId for next test" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Get Image List (if we have a subtask)
if ($subtaskId) {
    Write-Host "`n3. Testing /api/image-list?subtaskid=$subtaskId" -ForegroundColor Yellow
    try {
        $response = Invoke-RestMethod -Uri "$baseUrl/image-list?subtaskid=$subtaskId" -Method Get
        if ($null -eq $response -or $response.Count -eq 0) {
            Write-Host "   No images found for this subtask" -ForegroundColor Yellow
        } else {
            Write-Host "   Found $($response.Count) images" -ForegroundColor Green
            $response | Format-Table id, taskid, beforeid, customer_id, genarted_image, sent
            
            # Save first image ID
            $imageId = $response[0].id
            Write-Host "   Using Image ID: $imageId for next test" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 4: Update Image Status (if we have an image)
if ($imageId) {
    Write-Host "`n4. Testing /api/update-image-status (POST)" -ForegroundColor Yellow
    Write-Host "   Marking image $imageId as sent..." -ForegroundColor Gray
    try {
        $body = @{
            imageid = $imageId
        } | ConvertTo-Json
        
        $response = Invoke-RestMethod -Uri "$baseUrl/update-image-status" `
            -Method Post `
            -Body $body `
            -ContentType "application/json"
        
        Write-Host "   SUCCESS: $($response.message)" -ForegroundColor Green
    } catch {
        Write-Host "   ERROR: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Summary: Check database directly
Write-Host "`n=== DATABASE VERIFICATION ===" -ForegroundColor Cyan

Write-Host "`n5. Tasks with status breakdown:" -ForegroundColor Yellow
mysql -u root -e "SELECT status, COUNT(*) as count, GROUP_CONCAT(taskname SEPARATOR ', ') as tasks FROM laravel.task GROUP BY status;" 2>&1

Write-Host "`n6. Before_genration status breakdown:" -ForegroundColor Yellow
mysql -u root -e "SELECT status, COUNT(*) as count FROM laravel.before_genration GROUP BY status;" 2>&1

Write-Host "`n7. Generated images status breakdown:" -ForegroundColor Yellow
mysql -u root -e "SELECT sent, COUNT(*) as count FROM laravel.generated_image GROUP BY sent;" 2>&1

Write-Host "`n=== COMMON QUERIES ===" -ForegroundColor Cyan

Write-Host "`n8. Tasks ready to execute (status=0):" -ForegroundColor Yellow
mysql -u root -e "SELECT id, taskname, status, remark FROM laravel.task WHERE status = 0 LIMIT 5;" 2>&1

Write-Host "`n9. Tasks executed but not downloaded (status=1, images with sent=0):" -ForegroundColor Yellow
mysql -u root -e "SELECT t.id, t.taskname, COUNT(gi.id) as pending_images FROM laravel.task t LEFT JOIN laravel.generated_image gi ON t.id = gi.taskid AND gi.sent = 0 WHERE t.status = 1 GROUP BY t.id HAVING pending_images > 0 LIMIT 5;" 2>&1

Write-Host "`n=== TEST COMPLETE ===" -ForegroundColor Cyan
