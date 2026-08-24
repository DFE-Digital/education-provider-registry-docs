function Assert-LocalBauSource {
    param([Parameter(Mandatory)][string]$SqlServer, [Parameter(Mandatory)][string]$SourceDatabase)
    if ($SqlServer -notin @('localhost', '127.0.0.1', 'SL646104')) { throw "The source SQL Server must be the local BAU copy. Received: $SqlServer" }
    if ($SourceDatabase -ne 'gias_bau_test_local') { throw "The source database must be gias_bau_test_local. Received: $SourceDatabase" }
}

function Assert-LocalPostgresTarget {
    param([Parameter(Mandatory)][string]$PostgresHost, [Parameter(Mandatory)][string]$PostgresDatabase)
    if ($PostgresHost -notin @('localhost', '127.0.0.1')) { throw "The PostgreSQL host must be local. Received: $PostgresHost" }
    if ($PostgresDatabase -notin @('establishment_local', 'governance_local')) { throw "The PostgreSQL target must be establishment_local or governance_local. Received: $PostgresDatabase" }
}
