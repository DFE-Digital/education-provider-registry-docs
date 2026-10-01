# Paths to files under models/schema, and progress messages.

function Get-SchemaPath {
    <#
    .SYNOPSIS
    Returns the full path of a file under models/schema.
    .EXAMPLE
    Get-SchemaPath 'establishment/core-establishment-schema.sql'
    #>
    param([Parameter(Mandatory)][string]$RelativePath)

    $path = $script:SchemaRoot
    foreach ($part in ($RelativePath -split '[\\/]')) {
        if ($part) { $path = Join-Path $path $part }
    }
    return $path
}

function Assert-FileExists {
    param([Parameter(Mandatory)][string[]]$Path)

    foreach ($candidate in $Path) {
        if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            throw "Required file not found: $candidate"
        }
    }
}

function Write-Step {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "==> $Message" -ForegroundColor Cyan
}
