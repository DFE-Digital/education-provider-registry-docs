param(
    [string]$InformationPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "information" "fields")),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" "models"))
)

$ErrorActionPreference = "Stop"

$resolvedInformationPath = Resolve-Path -LiteralPath $InformationPath
$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot

$files = @("establishment-subtype-attribute-matrix.md")

foreach ($file in $files) {
    $source = Join-Path $resolvedInformationPath $file
    if (-not (Test-Path -LiteralPath $source)) {
        throw "Required information file not found: $source"
    }

    Copy-Item -LiteralPath $source -Destination (Join-Path $resolvedOutputRoot $file) -Force
}

$staleCsv = Join-Path $resolvedOutputRoot "establishment-subtype-attribute-matrix.csv"
if (Test-Path -LiteralPath $staleCsv) {
    Remove-Item -LiteralPath $staleCsv -Force
}

Write-Host "Copied establishment subtype attribute matrix context into the models section at $resolvedOutputRoot"
