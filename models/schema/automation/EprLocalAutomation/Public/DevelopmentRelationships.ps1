# Bulk relationships are scoped in PostgreSQL before validation and logging.

function Test-DevelopmentDataRejection {
    param([Parameter(Mandatory)][Exception]$Exception)
    # Execution/configuration/client errors are not ordinary lossy source rows.
    $state=[string]$Exception.Data['SqlState']
    return $state -match '^(22|23)' -or $state -eq 'P0001'
}

function Write-DevelopmentRelationshipError {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][guid]$MigrationRunId,
          [Parameter(Mandatory)][int]$Urn,[Parameter(Mandatory)][string]$Kind,
          [Parameter(Mandatory)][string]$Message,$SourceRow)
    $messageSql=$Message.Replace("'","''")
    $rowSql='NULL'
    if ($null -ne $SourceRow) {
        $json=(ConvertTo-Json -InputObject $SourceRow -Compress -Depth 5).Replace("'","''")
        $rowSql="'$json'::jsonb"
    }
    $kindSql=$Kind.Replace("'","''")
    $path=Join-Path ([IO.Path]::GetTempPath()) ('log-development-relationship-error-'+[guid]::NewGuid().ToString('N')+'.sql')
    try {
        [IO.File]::WriteAllText($path,"INSERT INTO migration.relationship_load_error(migration_run_id,urn,relationship_kind,error_message,source_row) VALUES('$MigrationRunId',$Urn,'$kindSql','$messageSql',$rowSql);",[Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $Target -Quiet -FailureMessage 'Development relationship error logging failed' -File $path | Out-Null
    } finally { Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue }
}

function Import-DevelopmentRelationships {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory,[Parameter(Mandatory)][guid]$MigrationRunId)
    $scope=ConvertFrom-Json (Invoke-Psql -Target $Target -Output Scalar -FailureMessage 'Relationship scope query failed' `
        -Command "SELECT json_build_object('count',count(*),'first',min(urn)) FROM establishment.establishment;")
    if ($scope.count -eq 0) {Write-Host 'No loaded establishments; relationship phases have no owners.';return}
    $datasets=@(
        @{Name='party';Transform='development-party-relationships-from-bau.sql';Load='load-development-party-relationships.sql';Variables=@{}},
        @{Name='organisation-group';Transform='development-organisation-groups-from-bau.sql';Load='load-development-organisation-groups.sql';Variables=@{}},
        @{Name='sen';Transform='establishment-sen-from-bau.sql';Load='load-development-establishment-sen.sql';Variables=@{URN='NULL'}},
        @{Name='maintenance';Transform='maintenance-responsibility-from-bau.sql';Variables=@{URNS='0';ALL_SOURCE=1}}
    )
    foreach ($dataset in $datasets) {
        Write-Step "Loading development $($dataset.Name): bulk source extract, PostgreSQL owner filtering"
        try {
            if ($dataset.Name -eq 'sen') {Import-SenReferenceData -Source $Source -Target $Target -WorkingDirectory $WorkingDirectory}
            $csv=Join-Path $WorkingDirectory ("development-"+$dataset.Name+".csv")
            $count=Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath ("establishment/transforms/"+$dataset.Transform)) `
                -Variables $dataset.Variables -CsvPath $csv -RowCount Any -Description ("development "+$dataset.Name)
            if ($dataset.Name -eq 'maintenance') {
                Import-MaintenanceObservationFixture -Target $Target -CsvPath $csv -SourceDatabase $Source.Database `
                    -WorkingDirectory $WorkingDirectory -SkipDerivation -MigrationRunId $MigrationRunId
            } else {
                Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath ("migration/"+$dataset.Load)) `
                    -CsvPath $csv -WorkingDirectory $WorkingDirectory -Description ("development "+$dataset.Name) `
                    -MigrationRunId $MigrationRunId -Quiet
            }
            Write-Host "    $count source rows staged; only loaded establishment owners processed."
        } catch {
            $failure=$_.Exception
            Write-DevelopmentRelationshipError -Target $Target -MigrationRunId $MigrationRunId -Urn ([int]$scope.first) `
                -Kind ($dataset.Name+'-phase') -Message $failure.Message `
                -SourceRow ([pscustomobject]@{scope='all seeded establishments';establishments=$scope.count;phase_failed=$true})
            if (-not (Test-DevelopmentDataRejection -Exception $failure)) {throw}
            Write-Warning "$($dataset.Name) phase skipped: $($failure.Message)"
        }
    }
}
