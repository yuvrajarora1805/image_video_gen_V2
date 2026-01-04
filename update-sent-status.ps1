# Update sent status for all generated tasks
# This marks all images as sent and updates task status

Write-Host "`n=== UPDATING SENT STATUS FOR ALL TASKS ===" -ForegroundColor Cyan

# Get all tasks with generated images
$tasksToUpdate = @(10, 11, 14)

foreach ($taskId in $tasksToUpdate) {
    Write-Host "`nProcessing Task ID: $taskId" -ForegroundColor Yellow
    
    # Count images before
    $beforeCount = mysql -u root -e "SELECT COUNT(*) as count FROM laravel.generated_image WHERE taskid = $taskId AND sent = 0;" 2>&1 | Select-String -Pattern '\d+' | Select-Object -Last 1
    
    # Update images to sent
    mysql -u root -e "UPDATE laravel.generated_image SET sent = 1, sent_date = NOW() WHERE taskid = $taskId AND sent = 0;" 2>&1 | Out-Null
    
    # Update task status
    mysql -u root -e "UPDATE laravel.task SET sent_status = 1, remark = 'Success - All Images Sent' WHERE id = $taskId;" 2>&1 | Out-Null
    
    Write-Host "  ✓ Updated task $taskId - Marked images as sent" -ForegroundColor Green
}

Write-Host "`n=== VERIFICATION ===" -ForegroundColor Cyan
mysql -u root -e "SELECT t.id, t.taskname, t.status, t.sent_status, t.remark, COUNT(gi.id) as total_images, SUM(gi.sent) as sent_images FROM laravel.task t LEFT JOIN laravel.generated_image gi ON t.id = gi.taskid WHERE t.status = 1 GROUP BY t.id;" 2>&1

Write-Host "`n=== UPDATE COMPLETE ===" -ForegroundColor Green
Write-Host "Refresh http://127.0.0.1:8000/generate to see 'Sent Successfully' status" -ForegroundColor Cyan
