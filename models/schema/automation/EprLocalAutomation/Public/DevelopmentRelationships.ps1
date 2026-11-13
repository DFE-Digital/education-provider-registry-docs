# Lossy relationship loading for the disposable BAU development seed. It has no
# reviewed identity mappings: rows that the normal model rejects are logged and
# omitted without changing the already loaded establishments.

function Get-DevelopmentSeedUrns {
    param([Parameter(Mandatory)]$Target)
    $text=Invoke-Psql -Target $Target -Output Csv -Command 'SELECT urn FROM establishment.establishment ORDER BY urn' -FailureMessage 'Development relationship scope query failed'
    return @($text -split "`r?`n" | Where-Object {$_ -match '^"?\d+"?$'} | ForEach-Object {[int]$_.Trim('"')})
}

function Write-DevelopmentRelationshipError {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][guid]$MigrationRunId,
          [Parameter(Mandatory)][int]$Urn,[Parameter(Mandatory)][string]$Kind,
          [Parameter(Mandatory)][string]$Message,$SourceRow)
    $messageSql=$Message.Replace("'","''")
    # This is a fallback logger reached while handling a loader exception.
    # Keep its insert deliberately scalar-only: PowerShell CSV objects can
    # contain quotes/newlines which must not turn error logging into a second
    # failure. The source extract remains in the run workspace when requested.
    $rowSql='NULL'
    $kindSql=$Kind.Replace("'","''")
    $path=Join-Path ([IO.Path]::GetTempPath()) ('log-development-relationship-error-'+[guid]::NewGuid().ToString('N')+'.sql')
    try {
        [IO.File]::WriteAllText($path,"INSERT INTO migration.relationship_load_error(migration_run_id,urn,relationship_kind,error_message,source_row) VALUES('$MigrationRunId',$Urn,'$kindSql','$messageSql',$rowSql);",[Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $Target -Quiet -FailureMessage 'Development relationship error logging failed' -File $path | Out-Null
    } finally { Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue }
}

function Write-DevelopmentRelationshipErrors {
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)][guid]$MigrationRunId,
          [Parameter(Mandatory)][object[]]$Rows,[Parameter(Mandatory)][string]$Kind,
          [Parameter(Mandatory)][string]$Message,[Parameter(Mandatory)][string]$WorkingDirectory)
    if ($Rows.Count -eq 0) { return }
    $messageSql=$Message.Replace("'","''")
    $kindSql=$Kind.Replace("'","''")
    $values=@(foreach($row in $Rows) { "('$MigrationRunId',$([int]$row.establishment_urn),'$kindSql','$messageSql',NULL)" })
    # A rejected 250-row slice can exceed Windows' command-line limit when the
    # database error is repeated for every row. Use a SQL file, not -Command.
    $path=Join-Path $WorkingDirectory ('log-development-relationship-errors-'+[guid]::NewGuid().ToString('N')+'.sql')
    try {
        [IO.File]::WriteAllText($path,"INSERT INTO migration.relationship_load_error(migration_run_id,urn,relationship_kind,error_message,source_row) VALUES $($values -join ',');",[Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $Target -Quiet -FailureMessage 'Development relationship error logging failed' -File $path | Out-Null
    } finally { Remove-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue }
}

function Write-DevelopmentCsv {
    param([Parameter(Mandatory)][object[]]$Rows,[Parameter(Mandatory)][string]$Path)
    if ($Rows.Count -eq 0) { return }
    $columns=@($Rows[0].PSObject.Properties.Name)
    $writer=[IO.StreamWriter]::new($Path,$false,[Text.UTF8Encoding]::new($false),65536)
    try {
        $writer.WriteLine(($columns -join '|'))
        foreach($row in $Rows) {
            $values=foreach($column in $columns) {
                $value=$row.$column
                if ($null -eq $value -or $value -eq 'NULL') { 'NULL'; continue }
                $text=[string]$value
                if ($text.IndexOfAny([char[]]@('|','"',"`r","`n")) -ge 0) { '"'+$text.Replace('"','""')+'"' } else {$text}
            }
            $writer.WriteLine(($values -join '|'))
        }
    } finally { $writer.Dispose() }
}

function Import-DevelopmentPartyRelationships {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][int[]]$LoadedUrns,[Parameter(Mandatory)][string]$WorkingDirectory,
          [Parameter(Mandatory)][guid]$MigrationRunId)
    Write-Step 'Loading lossy party relationships for seeded establishments'
    $csv=Join-Path $WorkingDirectory 'development-party-relationships.csv'
    $count=Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/development-party-relationships-from-bau.sql') `
        -CsvPath $csv -RowCount Any -Description 'development party relationships'
    if ($count -eq 0) { return }
    $scope=[Collections.Generic.HashSet[int]]::new([int[]]$LoadedUrns)
    $rows=@(Import-Csv -LiteralPath $csv -Delimiter '|' | Where-Object {$scope.Contains([int]$_.establishment_urn)})
    Write-Host "    Attempting $($rows.Count) party links in $([Math]::Ceiling($rows.Count / 250.0)) lossy slices."
    $failed=0; $loaded=0
    function Invoke-PartySlice {
        param([object[]]$Slice)
        if ($Slice.Count -eq 0) { return }
        $sliceCsv=Join-Path $WorkingDirectory ('development-party-'+[guid]::NewGuid().ToString('N')+'.csv')
        try {
            Write-DevelopmentCsv -Rows $Slice -Path $sliceCsv
            Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') `
                -CsvPath $sliceCsv -WorkingDirectory $WorkingDirectory -Description "development party relationship slice ($($Slice.Count))" -MigrationRunId $MigrationRunId -Quiet
            $script:developmentPartyLoaded += $Slice.Count
        } catch {
            # This is intentionally lossy and fast: do not split a failed
            # development slice into serial single-row loads. All rows in the
            # failed slice are recorded and omitted together.
            Write-DevelopmentRelationshipErrors -Target $Target -MigrationRunId $MigrationRunId -Rows $Slice -Kind 'party' -Message $_.Exception.Message -WorkingDirectory $WorkingDirectory
            $script:developmentPartyFailed += $Slice.Count
        } finally { Remove-Item -LiteralPath $sliceCsv -Force -ErrorAction SilentlyContinue }
    }
    $script:developmentPartyLoaded=0; $script:developmentPartyFailed=0
    for($offset=0;$offset -lt $rows.Count;$offset+=250) {
        $end=[Math]::Min($offset+249,$rows.Count-1)
        Invoke-PartySlice -Slice @($rows[$offset..$end])
    }
    Write-Host "    $script:developmentPartyLoaded party links loaded; $script:developmentPartyFailed skipped."
}

function Import-DevelopmentSenRelationships {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][int[]]$LoadedUrns,[Parameter(Mandatory)][string]$WorkingDirectory,
          [Parameter(Mandatory)][guid]$MigrationRunId)
    Import-SenReferenceData -Source $Source -Target $Target -WorkingDirectory $WorkingDirectory
    Write-Step 'Loading lossy SEN relationships for seeded establishments'
    $sourceCsv=Join-Path $WorkingDirectory 'development-sen-source.csv'
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-sen-from-bau.sql') `
        -Variables @{URN='NULL'} -CsvPath $sourceCsv -RowCount Any -Description 'development SEN relationships' | Out-Null
    $scope=[Collections.Generic.HashSet[int]]::new([int[]]$LoadedUrns)
    $rows=@(Import-Csv -LiteralPath $sourceCsv -Delimiter '|' | Where-Object {$scope.Contains([int]$_.urn)})
    $csv=Join-Path $WorkingDirectory 'development-sen.csv'
    Write-DevelopmentCsv -Rows $rows -Path $csv
    $sql=(Get-Content -LiteralPath (Get-SchemaPath 'migration/load-development-establishment-sen.sql') -Raw).
        Replace('__FIXTURE_PATH__',$csv.Replace('\','/').Replace("'","''")).Replace('__RUN_ID__',$MigrationRunId)
    $path=Join-Path $WorkingDirectory 'load-development-sen.sql'
    [IO.File]::WriteAllText($path,$sql,[Text.UTF8Encoding]::new($false))
    Invoke-Psql -Target $Target -File $path -Quiet -FailureMessage 'Development SEN relationship load failed'
}

function Import-DevelopmentOrganisationGroups {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][int[]]$LoadedUrns,[Parameter(Mandatory)][string]$WorkingDirectory,
          [Parameter(Mandatory)][guid]$MigrationRunId)
    Write-Step 'Loading lossy organisation-group memberships for seeded establishments'
    $scope=[Collections.Generic.HashSet[int]]::new([int[]]$LoadedUrns)
    $bulkCsv=Join-Path $WorkingDirectory 'development-organisation-groups.csv'
    $bulkCount=Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/development-organisation-groups-from-bau.sql') `
        -CsvPath $bulkCsv -RowCount Any -Description 'development organisation groups'
    if ($bulkCount -eq 0) { return }
    $loaded=0; $skipped=0
    $bulkRows=@(Import-Csv -LiteralPath $bulkCsv -Delimiter '|' | Where-Object {$scope.Contains([int]$_.establishment_urn)})
    $groups=@($bulkRows | Group-Object group_uid)
    Write-Host "    Attempting $($groups.Count) organisation groups from one bulk extract."
    if ($bulkRows.Count -eq 0) { return }
    $fixture=Join-Path $WorkingDirectory 'development-organisation-groups-filtered.csv'
    Write-DevelopmentCsv -Rows $bulkRows -Path $fixture
    $sql=(Get-Content -LiteralPath (Get-SchemaPath 'migration/load-development-organisation-groups.sql') -Raw).
        Replace('__FIXTURE_PATH__',$fixture.Replace('\','/').Replace("'","''"))
    $path=Join-Path $WorkingDirectory 'load-development-organisation-groups.sql'
    [IO.File]::WriteAllText($path,"SELECT set_config('epr.migration_run_id','$MigrationRunId',false);`n$sql",[Text.UTF8Encoding]::new($false))
    Invoke-Psql -Target $Target -File $path -Quiet -FailureMessage 'Development organisation-group load failed'
    Write-Host "    Organisation groups loaded in one PostgreSQL batch."
}

function Import-DevelopmentRelationships {
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory,[Parameter(Mandatory)][guid]$MigrationRunId)
    # Core seeding owns this run and completes it before returning. Reopen it
    # while its dependent development relationships are being loaded, because
    # the relationship fixtures intentionally require one running shared run.
    Invoke-Psql -Target $Target -Quiet -FailureMessage 'Could not reopen development migration run' -Command "UPDATE migration.migration_run SET status='running', completed_at=NULL WHERE migration_run_id='$MigrationRunId';" | Out-Null
    try {
        $urns=Get-DevelopmentSeedUrns -Target $Target
        if ($urns.Count -gt 0) {
            $scope=[Collections.Generic.HashSet[int]]::new([int[]]$urns)
            Import-DevelopmentPartyRelationships -Source $Source -Target $Target -LoadedUrns $urns -WorkingDirectory $WorkingDirectory -MigrationRunId $MigrationRunId
            Import-DevelopmentOrganisationGroups -Source $Source -Target $Target -LoadedUrns $urns -WorkingDirectory $WorkingDirectory -MigrationRunId $MigrationRunId
            Import-DevelopmentSenRelationships -Source $Source -Target $Target -LoadedUrns $urns -WorkingDirectory $WorkingDirectory -MigrationRunId $MigrationRunId
            try {
                Write-Step 'Loading lossy maintenance relationships for seeded establishments'
                # Extract the simple all-source query once. Do not interpolate
                # tens of thousands of URNs into SQL Server's IN clause.
                $maintenanceSource=Join-Path $WorkingDirectory 'development-maintenance-source-all.csv'
                Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/maintenance-responsibility-from-bau.sql') `
                    -Variables @{ URNS='0'; ALL_SOURCE=1 } -CsvPath $maintenanceSource -RowCount Any -Description 'development maintenance source observations' | Out-Null
                $maintenanceRows=@(Import-Csv -LiteralPath $maintenanceSource -Delimiter '|' | Where-Object {$scope.Contains([int]$_.urn)})
                $maintenanceCsv=Join-Path $WorkingDirectory 'development-maintenance-source.csv'
                Write-DevelopmentCsv -Rows $maintenanceRows -Path $maintenanceCsv
                Import-MaintenanceObservationFixture -Target $Target -CsvPath $maintenanceCsv -SourceDatabase $Source.Database -WorkingDirectory $WorkingDirectory -SkipDerivation
            }
            catch { Write-Warning "Maintenance relationships were skipped: $($_.Exception.Message)" }
        }
        $complete="UPDATE migration.migration_run SET status=CASE WHEN EXISTS (SELECT 1 FROM migration.establishment_load_error WHERE migration_run_id='$MigrationRunId') OR EXISTS (SELECT 1 FROM migration.relationship_load_error WHERE migration_run_id='$MigrationRunId') THEN 'completed_with_errors' ELSE 'completed' END, completed_at=clock_timestamp() WHERE migration_run_id='$MigrationRunId';"
        Invoke-Psql -Target $Target -Quiet -FailureMessage 'Could not complete development migration run' -Command $complete | Out-Null
    } catch {
        Invoke-Psql -Target $Target -Quiet -FailureMessage 'Could not fail development migration run' -Command "UPDATE migration.migration_run SET status='failed', completed_at=clock_timestamp() WHERE migration_run_id='$MigrationRunId';" | Out-Null
        throw
    }
}
