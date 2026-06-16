
$inputFile = "safe_structure_raw.sql"
$outputFile = "safe_structure_only.sql"
$content = Get-Content $inputFile -Raw
$content = $content -replace "CREATE TABLE", "CREATE TABLE IF NOT EXISTS"
Set-Content $outputFile $content
Write-Host "✅ Created safe_structure_only.sql"
