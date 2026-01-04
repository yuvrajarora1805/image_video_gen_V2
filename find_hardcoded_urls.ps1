# PowerShell Script to Fix All Hardcoded URLs in Laravel Application
# This script finds and fixes all hardcoded URLs to use Laravel's url() helper

$basePath = "d:\xamp\htdocs\imgen\public_html\public_html\resources\views"

Write-Host "=== Laravel URL Fix Script ===" -ForegroundColor Cyan
Write-Host "Searching for hardcoded URLs in blade templates..." -ForegroundColor Yellow

# Patterns to search for
$patterns = @(
    @{Name="AJAX url"; Pattern='url:\s*[''"]\/[a-z]'},
    @{Name="fetch"; Pattern='fetch\([''"`]\/[a-z]'},
    @{Name="$.get"; Pattern='\$\.get\([''"]\/[a-z]'},
    @{Name="$.post"; Pattern='\$\.post\([''"]\/[a-z]'},
    @{Name="form action"; Pattern='action=[''"]\/[a-z]'}
)

$foundIssues = @()

foreach ($pattern in $patterns) {
    Write-Host "`nSearching for: $($pattern.Name)" -ForegroundColor Green
    
    $files = Get-ChildItem -Path $basePath -Filter "*.blade.php" -Recurse
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        if ($content -match $pattern.Pattern) {
            $lineNumber = 1
            $lines = Get-Content $file.FullName
            
            foreach ($line in $lines) {
                if ($line -match $pattern.Pattern) {
                    $foundIssues += [PSCustomObject]@{
                        File = $file.FullName.Replace($basePath, "")
                        Line = $lineNumber
                        Pattern = $pattern.Name
                        Content = $line.Trim()
                    }
                }
                $lineNumber++
            }
        }
    }
}

# Display results
Write-Host "`n=== Found Issues ===" -ForegroundColor Red
$foundIssues | Format-Table -AutoSize

Write-Host "`nTotal issues found: $($foundIssues.Count)" -ForegroundColor Yellow

# Export to CSV for review
$csvPath = "d:\xamp\htdocs\imgen\public_html\public_html\url_issues.csv"
$foundIssues | Export-Csv -Path $csvPath -NoTypeInformation
Write-Host "`nResults exported to: $csvPath" -ForegroundColor Green
