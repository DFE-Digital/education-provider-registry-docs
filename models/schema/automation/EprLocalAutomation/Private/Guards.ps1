# Safety guards. The automation may read only the laptop-local BAU copy and
# write only to local PostgreSQL databases. It must never reach a shared,
# Test, staging or production system.

$script:AllowedBauServers = @('localhost', '127.0.0.1', '.', '(local)', [System.Environment]::MachineName)
$script:AllowedPostgresHosts = @('localhost', '127.0.0.1')
$script:AllowedPostgresDatabases = @('establishment_local', 'governance_local')

function Assert-LocalBauSource {
    param(
        [Parameter(Mandatory)][string]$SqlServer,
        [Parameter(Mandatory)][string]$Database
    )
    # Allow a local named instance and optional TCP port, but not arbitrary
    # remote hosts or connection-string fragments.
    $serverMatch = [regex]::Match($SqlServer, '^(?<host>[^\\,;]+)(?:\\[A-Za-z0-9_-]+)?(?:,[0-9]{1,5})?$')
    if (-not $serverMatch.Success -or $serverMatch.Groups['host'].Value -notin $script:AllowedBauServers) {
        throw "The source SQL Server must be the local BAU copy. Received: $SqlServer"
    }
    if ($Database -notmatch '^[A-Za-z0-9_]+_local$') {
        throw "The source database must be a local BAU copy with a name ending '_local' (letters, digits and underscores only). Received: $Database"
    }
}

function Assert-LocalPostgresTarget {
    param(
        [Parameter(Mandatory)][string]$PostgresHost,
        [Parameter(Mandatory)][string]$Database
    )
    if ($PostgresHost -notin $script:AllowedPostgresHosts) {
        throw "The PostgreSQL host must be local. Received: $PostgresHost"
    }
    if ($Database -notin $script:AllowedPostgresDatabases) {
        throw "The PostgreSQL target must be establishment_local or governance_local. Received: $Database"
    }
}
