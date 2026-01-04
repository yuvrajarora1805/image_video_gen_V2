# Convert SQL file paths from Linux to Windows format
# This script updates all file paths in img_generation.sql for Windows

$inputFile = "img_generation.sql"
$outputFile = "img_generation_windows.sql"

Write-Host "Converting SQL file paths to Windows format..." -ForegroundColor Cyan

# Read the entire file
$content = Get-Content $inputFile -Raw

# Old Linux path pattern
$oldPath = "/home/oaul5xmpdb34/public_html/public"

# New Windows path with forward slashes (works in PHP/Laravel)
$newPath = "C:/xampp/htdocs/public_html/public_html/public"

# Replace all occurrences
$content = $content -replace [regex]::Escape($oldPath), $newPath

# Save to new file
$content | Set-Content $outputFile -NoNewline

Write-Host "✓ Conversion complete!" -ForegroundColor Green
Write-Host "  Input:  $inputFile" -ForegroundColor Gray
Write-Host "  Output: $outputFile" -ForegroundColor Gray
Write-Host ""
Write-Host "Path conversion:" -ForegroundColor Yellow
Write-Host "  FROM: $oldPath" -ForegroundColor Red
Write-Host "  TO:   $newPath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Copy this file to production PC" -ForegroundColor Gray
Write-Host "2. Import: mysql -u root laravel < img_generation_windows.sql" -ForegroundColor Gray
