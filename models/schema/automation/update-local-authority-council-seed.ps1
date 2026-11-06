<# Regenerate SQL after reviewing changes to the council mapping JSON. #>
[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$jsonPath = Join-Path $root 'seed/local-authority-area-councils.json'
$templatePath = Join-Path $root 'establishment/load/load-local-authority-area-councils.sql'
$json = [IO.File]::ReadAllText($jsonPath)
$null = $json | ConvertFrom-Json
$hash = (Get-FileHash -LiteralPath $jsonPath -Algorithm SHA256).Hash.ToLowerInvariant()
$sql = [IO.File]::ReadAllText($templatePath).Replace('__MAPPING_SHA256__',$hash).Replace('__MAPPING_JSON__',$json.Replace("'","''"))
[IO.File]::WriteAllText((Join-Path $root 'seed/seed-local-authority-area-councils.sql'),$sql,[Text.UTF8Encoding]::new($false))
Write-Host 'Generated council seed; pending mappings are excluded from target loading.'
