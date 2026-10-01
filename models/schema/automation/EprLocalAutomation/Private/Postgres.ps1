# Running psql and pg_dump against a local PostgreSQL target.

function Get-PostgresClientPath {
    <#
    .SYNOPSIS
    Finds psql or pg_dump on the PATH, then in the default Windows install folder.
    #>
    param([Parameter(Mandatory)][ValidateSet('psql', 'pg_dump')][string]$Tool)

    foreach ($name in @($Tool, "$Tool.exe")) {
        $command = Get-Command $name -ErrorAction SilentlyContinue
        if ($command) { return $command.Source }
    }
    $windowsDefault = "C:\Program Files\PostgreSQL\18\bin\$Tool.exe"
    if (Test-Path -LiteralPath $windowsDefault) { return $windowsDefault }
    throw "$Tool not found. Add the PostgreSQL bin folder to PATH."
}

function Get-PsqlArgumentList {
    <#
    .SYNOPSIS
    Builds the psql argument list. Kept separate from Invoke-Psql so that it can
    be checked without a database.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [string]$File,
        [string]$Command,
        [hashtable]$Variables,
        [ValidateSet('Console', 'Csv', 'Scalar')][string]$Output = 'Console'
    )

    $arguments = @(
        '-X',
        '-h', $Target.PostgresHost,
        '-p', [string]$Target.Port,
        '-U', $Target.User,
        '-d', $Target.Database,
        '-w',
        '-v', 'ON_ERROR_STOP=1'
    )
    if ($Output -eq 'Csv') { $arguments += @('-q', '-P', 'format=csv') }
    if ($Output -eq 'Scalar') { $arguments += @('-A', '-t', '-q') }
    if ($Variables) {
        foreach ($name in ($Variables.Keys | Sort-Object)) {
            $arguments += @('-v', "$name=$($Variables[$name])")
        }
    }
    if ($File) { $arguments += @('-f', $File) }
    if ($Command) { $arguments += @('-c', $Command) }
    return $arguments
}

function Invoke-WithPostgresPassword {
    <#
    .SYNOPSIS
    Runs a script block with PGPASSWORD set from the target, then restores it.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][scriptblock]$ScriptBlock
    )

    $passwordBefore = $env:PGPASSWORD
    if ($Target.Password) { $env:PGPASSWORD = $Target.Password }
    try { & $ScriptBlock }
    finally { $env:PGPASSWORD = $passwordBefore }
}

function Invoke-Psql {
    <#
    .SYNOPSIS
    Runs a SQL file or command with psql and fails on any SQL error.
    .PARAMETER Output
    Console prints psql output. Csv and Scalar return it as text.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [string]$File,
        [string]$Command,
        [hashtable]$Variables,
        [ValidateSet('Console', 'Csv', 'Scalar')][string]$Output = 'Console',
        [Parameter(Mandatory)][string]$FailureMessage
    )

    if ([bool]$File -eq [bool]$Command) { throw 'Invoke-Psql needs exactly one of -File and -Command.' }
    if ($File) { Assert-FileExists -Path $File }

    $psql = Get-PostgresClientPath -Tool 'psql'
    $arguments = Get-PsqlArgumentList -Target $Target -File $File -Command $Command -Variables $Variables -Output $Output

    $result = Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
        if ($Output -eq 'Console') {
            & $psql @arguments | Out-Host
        }
        else {
            (& $psql @arguments | Out-String)
        }
        if ($LASTEXITCODE -ne 0) { throw "$FailureMessage (psql exit code $LASTEXITCODE)" }
    }

    if ($Output -eq 'Scalar') { return ([string]$result).Trim() }
    if ($Output -eq 'Csv') { return [string]$result }
}

function Invoke-PgDump {
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][string[]]$Arguments,
        [Parameter(Mandatory)][string]$FailureMessage
    )

    $pgDump = Get-PostgresClientPath -Tool 'pg_dump'
    $connection = @('-h', $Target.PostgresHost, '-p', [string]$Target.Port, '-U', $Target.User, '-d', $Target.Database)
    $allArguments = $connection + $Arguments
    Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
        & $pgDump @allArguments
        if ($LASTEXITCODE -ne 0) { throw "$FailureMessage (pg_dump exit code $LASTEXITCODE)" }
    }
}
