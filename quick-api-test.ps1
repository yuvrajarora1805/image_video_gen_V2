# Quick API Test Commands
# Copy and paste these one by one to test the API

# 1. Get all tasks
Invoke-RestMethod "http://127.0.0.1:8000/api/task-list" | Format-Table id, taskname, totalimage, send, pending

# 2. Get subtasks for Task 10 (replace 10 with any task ID)
$taskId = 10
Invoke-RestMethod "http://127.0.0.1:8000/api/subtask-list?taskid=$taskId" | Format-Table

# 3. Get images for a subtask (replace 11 with subtask ID from above)
$subtaskId = 11
Invoke-RestMethod "http://127.0.0.1:8000/api/image-list?subtaskid=$subtaskId" | Format-Table

# 4. Mark an image as sent (replace 3 with image ID from above)
$imageId = 3
$body = @{ imageid = $imageId } | ConvertTo-Json
Invoke-RestMethod "http://127.0.0.1:8000/api/update-image-status" -Method Post -Body $body -ContentType "application/json"

# 5. Check database directly
mysql -u root -e "SELECT * FROM laravel.generated_image WHERE taskid = 10;"
