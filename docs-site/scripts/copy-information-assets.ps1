param(
    [string]$InformationPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "information" "fields")),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "output" (Join-Path "information" (Join-Path "fields" "establishment-subtype-attribute-matrix"))))
)

$ErrorActionPreference = "Stop"

$source = Join-Path $InformationPath "establishment-subtype-attribute-matrix.csv"
if (-not (Test-Path -LiteralPath $source)) {
    throw "Required information asset not found: $source"
}

$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot
Copy-Item -LiteralPath $source -Destination (Join-Path $resolvedOutputRoot "establishment-subtype-attribute-matrix.csv") -Force

$legacyOutput = Join-Path (Split-Path -Parent $resolvedOutputRoot) "establishment-subtype-attribute-matrix.csv"
if (Test-Path -LiteralPath $legacyOutput) {
    Remove-Item -LiteralPath $legacyOutput -Force
}

Write-Host "Copied establishment subtype attribute matrix CSV to $resolvedOutputRoot"
