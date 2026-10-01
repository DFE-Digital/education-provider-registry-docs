# Safety guards. The automation may read only the laptop-local BAU copy and
# write only to local PostgreSQL databases. It must never reach a shared,
# Test, staging or production system.

$script:AllowedBauServers = @('localhost', '127.0.0.1', 'SL646104')
$script:AllowedBauDatabases = @('gias_bau_test_local')
$script:AllowedPostgresHosts = @('localhost', '127.0.0.1')
$script:AllowedPostgresDatabases = @('establishment_local', 'governance_local')

function Assert-LocalBauSource {
    param(
        [Parameter(Mandatory)][string]$SqlServer,
        [Parameter(Mandatory)][string]$Database
    )
    if ($SqlServer -notin $script:AllowedBauServers) {
        throw "The source SQL Server must be the local BAU copy. Received: $SqlServer"
    }
    if ($Database -notin $script:AllowedBauDatabases) {
        throw "The source database must be gias_bau_test_local. Received: $Database"
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
