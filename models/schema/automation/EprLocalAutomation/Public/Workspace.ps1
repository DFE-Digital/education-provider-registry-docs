# A working folder for one run. Every extracted CSV fixture and working copy of
# load SQL goes here, so clean-up is a single folder delete.

function New-RunWorkspace {
    <#
    .SYNOPSIS
    Creates a new, empty working folder for one run and returns its path.
    #>
    param([string]$ParentDirectory = [System.IO.Path]::GetTempPath())

    $name = 'epr-local-run-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
    $path = Join-Path $ParentDirectory $name
    New-Item -ItemType Directory -Path $path -Force | Out-Null
    return $path
}

function Remove-RunWorkspace {
    <#
    .SYNOPSIS
    Deletes a run's working folder, or keeps it for troubleshooting with -Keep.
    #>
    param(
        [Parameter(Mandatory)][string]$Path,
        [switch]$Keep
    )

    if ($Keep) {
        Write-Host "Working files kept in: $Path"
        return
    }
    if (Test-Path -LiteralPath $Path) {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}
