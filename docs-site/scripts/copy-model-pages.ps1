param(
    [string]$ModelsPath = (Join-Path (Join-Path $PSScriptRoot "..\..") "models"),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" "models"))
)

$ErrorActionPreference = "Stop"

$resolvedModelsPath = Resolve-Path -LiteralPath $ModelsPath
$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot

$staleMatrixCsv = Join-Path $resolvedOutputRoot "establishment-subtype-attribute-matrix.csv"
if (Test-Path -LiteralPath $staleMatrixCsv) {
    Remove-Item -LiteralPath $staleMatrixCsv -Force
}

$markdownFiles = Get-ChildItem -LiteralPath $resolvedModelsPath -Filter "*.md" |
    Where-Object { $_.Name -ne "README.md" -and $_.Name -ne "index.md" -and $_.Name -ne "establishment-type-field-rules.md" }

if ($markdownFiles.Count -eq 0) {
    Write-Warning "No markdown files found to copy in $resolvedModelsPath"
    return
}

$copiedCount = 0
foreach ($file in $markdownFiles) {
    $destination = Join-Path $resolvedOutputRoot $file.Name
    Copy-Item -LiteralPath $file.FullName -Destination $destination -Force
    $copiedCount++
}

Write-Host "Copied $copiedCount model markdown file(s) from models/ to $resolvedOutputRoot"
