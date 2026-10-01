# Connection settings for the local BAU source and the local PostgreSQL
# targets. Every other function takes one of these objects, so connection
# details are set once per run.

function New-BauSource {
    <#
    .SYNOPSIS
    Describes the laptop-local BAU SQL Server copy to read from.
    .DESCRIPTION
    With SQL authentication, the password is taken from -SqlPassword, then from
    the EPR_BAU_SQL_PASSWORD environment variable, and otherwise prompted for.
    .EXAMPLE
    $source = New-BauSource -SqlServer SL646104 -UseWindowsAuthentication
    #>
    param(
        [string]$SqlServer = 'localhost',
        [string]$Database = 'gias_bau_test_local',
        [string]$SqlUser = 'reader',
        [securestring]$SqlPassword,
        [switch]$UseWindowsAuthentication
    )

    Assert-LocalBauSource -SqlServer $SqlServer -Database $Database

    if (-not $UseWindowsAuthentication -and -not $SqlPassword) {
        if ($env:EPR_BAU_SQL_PASSWORD) {
            $SqlPassword = ConvertTo-SecureString -String $env:EPR_BAU_SQL_PASSWORD -AsPlainText -Force
        }
        else {
            $SqlPassword = Read-Host -Prompt 'Local SQL Server reader password' -AsSecureString
        }
    }

    return [pscustomobject]@{
        PSTypeName               = 'Epr.BauSource'
        SqlServer                = $SqlServer
        Database                 = $Database
        SqlUser                  = $SqlUser
        SqlPassword              = $SqlPassword
        UseWindowsAuthentication = [bool]$UseWindowsAuthentication
    }
}

function New-PostgresTarget {
    <#
    .SYNOPSIS
    Describes a local PostgreSQL database to write to.
    .DESCRIPTION
    The password is optional; without it, psql uses pgpass.conf.
    .EXAMPLE
    $target = New-PostgresTarget
    $governance = New-PostgresTarget -Database governance_local
    #>
    param(
        [string]$PostgresHost = '127.0.0.1',
        [int]$Port = 5432,
        [string]$Database = 'establishment_local',
        [string]$User = 'postgres',
        [string]$Password = $env:PGPASSWORD
    )

    Assert-LocalPostgresTarget -PostgresHost $PostgresHost -Database $Database

    return [pscustomobject]@{
        PSTypeName   = 'Epr.PostgresTarget'
        PostgresHost = $PostgresHost
        Port         = $Port
        Database     = $Database
        User         = $User
        Password     = $Password
    }
}
