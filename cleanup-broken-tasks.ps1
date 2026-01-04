# Script to delete broken/failed tasks
# Tasks that show as "executed" but have no images

Write-Host "`n=== CLEANING UP BROKEN TASKS ===" -ForegroundColor Cyan

# List of task IDs with status=1 but no images
$brokenTasks = @(2, 3, 8, 12, 13)

Write-Host "`nBroken tasks to delete: $($brokenTasks -join ', ')" -ForegroundColor Yellow

foreach ($taskId in $brokenTasks) {
    Write-Host "`nDeleting Task ID $taskId..." -ForegroundColor Gray
    
    # Delete from all related tables
    mysql -u root -e "DELETE FROM laravel.generated_image WHERE taskid = $taskId;" 2>&1 | Out-Null
    mysql -u root -e "DELETE FROM laravel.before_genration WHERE taskid = $taskId;" 2>&1 | Out-Null
    mysql -u root -e "DELETE FROM laravel.logs WHERE task_id = $taskId;" 2>&1 | Out-Null
    mysql -u root -e "DELETE FROM laravel.errorlogs WHERE task_id = $taskId;" 2>&1 | Out-Null
    mysql -u root -e "DELETE FROM laravel.task WHERE id = $taskId;" 2>&1 | Out-Null
    
    Write-Host "   Task $taskId deleted" -ForegroundColor Green
}

Write-Host "`n=== CLEANUP COMPLETE ===" -ForegroundColor Cyan
Write-Host "`nRemaining tasks:" -ForegroundColor Yellow
mysql -u root -e "SELECT t.id, t.taskname, t.status, t.remark, COUNT(gi.id) as images FROM laravel.task t LEFT JOIN laravel.generated_image gi ON t.id = gi.taskid GROUP BY t.id;" 2>&1
