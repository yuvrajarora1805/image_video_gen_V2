# Cleanup Script - Remove Unnecessary Files for Distribution
# Run this script before sharing the software

Write-Host "Cleaning up project for distribution..." -ForegroundColor Cyan
Write-Host ""

$projectRoot = $PSScriptRoot
$deletedCount = 0

# Delete test files
Write-Host "Deleting test files..." -ForegroundColor Yellow
$testPatterns = @("test_*.py", "test_*.php", "test_*.bat", "test_*.txt", "test_*.json", "test-*.php", "test-*.ps1")
foreach ($pattern in $testPatterns) {
    Get-ChildItem -Path $projectRoot -Filter $pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete log files
Write-Host "Deleting log files..." -ForegroundColor Yellow
$logPatterns = @("*.log", "debug_*.php", "debug_*.py", "debug_*.json", "error_*.log")
foreach ($pattern in $logPatterns) {
    Get-ChildItem -Path $projectRoot -Filter $pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete check/verify files
Write-Host "Deleting check/verify files..." -ForegroundColor Yellow
$checkPatterns = @("check_*.php", "check_*.py", "check-*.php", "verify_*.php", "verify-*.php")
foreach ($pattern in $checkPatterns) {
    Get-ChildItem -Path $projectRoot -Filter $pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete reset/fix files
Write-Host "Deleting reset/fix files..." -ForegroundColor Yellow
$resetPatterns = @("reset_*.php", "reset_*.py", "reset-*.php", "fix_*.php", "fix-*.sql")
foreach ($pattern in $resetPatterns) {
    Get-ChildItem -Path $projectRoot -Filter $pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete specific files
Write-Host "Deleting specific unnecessary files..." -ForegroundColor Yellow
$specificFiles = @(
    "animated.py", "animation_suite_tester.py", "benchmark_limit.py",
    "blur_animation_tester.py", "diagnose_blur.py", "enhanced_blur_test.py",
    "fixed_yuv_blur_test.py", "gpu_blur_test.py", "gpu_vs_cpu_test.py",
    "real_blur_test.py", "testani.py", "testffmpeg11.py", "ffmpeg_final_11_test.py",
    "validate_animations.py", "bupvideogenerattor.py", "ImageGenerationController_UPDATED.php",
    "UPDATE_FOR_OTHER_SYSTEM.php", "api-response.json", "blur_animation_comparison.png",
    "database_backup.sql", "database_migration.sql", "error_log", "quote.html",
    "url_issues.csv", "execute-pending-tasks.php", "compare_files_db.php",
    "setup-database.php", "update_password.php", "temp_cleanup.php",
    "send.py", "savemusic.py", "test.py", "schema-output.txt", "schema.txt",
    "script_check.txt", "task09-result.txt", "url.txt", "reqbup.txt",
    "ya2_creds.txt", "gpu_test_output.txt", "gpu_test_result.txt"
)
foreach ($file in $specificFiles) {
    $filePath = Join-Path $projectRoot $file
    if (Test-Path $filePath) {
        Remove-Item $filePath -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $file" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete markdown docs (keep only README.md)
Write-Host "Deleting extra documentation..." -ForegroundColor Yellow
$docPatterns = @("AUTOMATION_PLAN.md", "DEBUG_CHECKLIST.md", "ENABLE_PARALLEL_PROCESSING.md",
    "IMAGE_VS_VIDEO_COMPARISON.md", "MIGRATION_GUIDE.md", "OPTIMIZATION_COMPLETE.md",
    "PARALLEL_PROCESSING_*.md", "POWERSHELL_COMMANDS.md", "QUEUE_*.md",
    "QUICK_VIDEO_SETUP.md", "VIDEO_GENERATION_CHECKLIST.md", "VIDEO_GENERATION_GUIDE.md",
    "VIDEO_SYSTEM_REBUILD_COMPLETE.md", "VIDEO_TEMPLATE_ASSIGNMENT_GUIDE.md")
foreach ($pattern in $docPatterns) {
    Get-ChildItem -Path $projectRoot -Filter $pattern -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete PowerShell scripts
Write-Host "Deleting development PowerShell scripts..." -ForegroundColor Yellow
$psPatterns = @("cleanup-broken-tasks.ps1", "complete-api-workflow.ps1", "convert-sql-paths.ps1",
    "find_hardcoded_urls.ps1", "kill_locks.ps1", "quick-api-test.ps1", "update-sent-status.ps1")
foreach ($file in $psPatterns) {
    $filePath = Join-Path $projectRoot $file
    if (Test-Path $filePath) {
        Remove-Item $filePath -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted: $file" -ForegroundColor Green
        $deletedCount++
    }
}

# Delete directories
Write-Host "Deleting unnecessary directories..." -ForegroundColor Yellow
$dirsToDelete = @("animation_test_outputs", "push_limit_outputs", "output", "temp", "__pycache__")
foreach ($dir in $dirsToDelete) {
    $dirPath = Join-Path $projectRoot $dir
    if (Test-Path $dirPath) {
        Remove-Item $dirPath -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted directory: $dir" -ForegroundColor Green
        $deletedCount++
    }
}

# Clean storage logs
Write-Host "Cleaning storage logs..." -ForegroundColor Yellow
$logsPath = Join-Path $projectRoot "storage\logs"
if (Test-Path $logsPath) {
    Get-ChildItem -Path $logsPath -Filter "*.log" -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted log: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

# Clean GPU tasks
$gpuTasksPath = Join-Path $projectRoot "storage\app\gpu_tasks"
if (Test-Path $gpuTasksPath) {
    Get-ChildItem -Path $gpuTasksPath -Filter "*.json" -File -ErrorAction SilentlyContinue | ForEach-Object {
        Remove-Item $_.FullName -Force -ErrorAction SilentlyContinue
        Write-Host "  Deleted GPU task: $($_.Name)" -ForegroundColor Green
        $deletedCount++
    }
}

Write-Host ""
Write-Host "Cleanup complete! Deleted $deletedCount items." -ForegroundColor Green
Write-Host ""
Write-Host "Project is ready for distribution!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Review .env file and remove sensitive data"
Write-Host "  2. Ensure .env.example is up to date"
Write-Host "  3. Clear any database credentials from config files"
Write-Host "  4. Create a ZIP archive of the project"
Write-Host ""
