function Import-DevelopmentEstablishmentSeed {
    <# .SYNOPSIS
    Bulk loads core establishments, isolating and logging failed establishments.
    #>
    param([Parameter(Mandatory)]$Source,[Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory,
          [int[]]$Urn=@(),[ValidateRange(1,10000)][int]$BatchSize=1000,
          [string]$KnownBadFile=(Get-SchemaPath 'seed/known-bad-establishments.json'))
    foreach ($selectedUrn in $Urn) {
        if ($selectedUrn -lt 1 -or $selectedUrn -gt 999999) { throw "Selected URN is outside the valid range: $selectedUrn" }
    }
    $query=Get-SqlWithVariables -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-from-bau.sql') -Variables @{URN='NULL'}
    $known=@(Read-KnownBadEstablishments -Path $KnownBadFile)
    $ignored=@($known | Where-Object {$_.source_database -eq $Source.Database} | ForEach-Object {[int]$_.urn} | Sort-Object -Unique)
    if ($ignored.Count) {
        $exclude=$ignored -join ','
        $query=$query.Replace("e.status_code IN ('1','2','3')","e.status_code IN ('1','2','3') AND e.URN NOT IN ($exclude)")
        Write-Host "Known-bad list: excluding $($ignored.Count) listed URNs for $($Source.Database)."
    }
    if ($Urn.Count) {
        $values=($Urn | ForEach-Object {[string][int]$_}) -join ','
        $query=$query.Replace('(@URN IS NULL OR e.URN = @URN)',"e.URN IN ($values)")
        $query=$query.Replace('(@URN IS NULL OR a.URN = @URN)',"a.URN IN ($values)")
    }
    $queryPath=Join-Path $WorkingDirectory 'development-establishments-source.sql'
    [IO.File]::WriteAllText($queryPath,$query,[Text.UTF8Encoding]::new($false))
    $csv=Join-Path $WorkingDirectory 'development-establishments.csv'
    $count=Export-BauQueryToCsv -Source $Source -SqlFile $queryPath -CsvPath $csv `
        -Columns $script:EstablishmentFixtureColumns -RowCount Any -Description 'development establishments'
    Write-Step "Loading $count establishments in batches of $BatchSize; failed establishments will be logged and skipped"
    $sourceDatabaseSql=$Source.Database.Replace("'","''")
    $runId=[guid](Invoke-Psql -Target $Target -Output Scalar -FailureMessage 'Dev seed run creation failed' -Command "INSERT INTO migration.migration_run(run_type,source_system,source_database,status,transform_version) VALUES('development-establishment-seed','GIAS BAU','$sourceDatabaseSql','running','dev-seed-v1') RETURNING migration_run_id;")
    try {
        $loader=Get-Content (Get-SchemaPath 'establishment/load/load-establishment-fixture.sql') -Raw
        $createStart=$loader.IndexOf('CREATE TEMP TABLE source_establishment_fixture (')
        $copyStart=$loader.IndexOf('\copy source_establishment_fixture ')
        if ($createStart -lt 0 -or $copyStart -lt 0) { throw 'Core establishment staging definition not found.' }
        $definition=$loader.Substring($createStart,$copyStart-$createStart)
        $columns=[regex]::Matches($definition,'(?m)^[ \t]+(?<name>[a-z_][a-z_0-9]*)[ \t]+(?<type>integer|numeric|text|date|boolean)[ \t]*,?[ \t]*\r?$')
        if ($columns.Count -ne $script:EstablishmentFixtureColumns.Count) { throw 'Core staging column count differs from the source projection.' }
        # Stage raw values as text so per-establishment cast failures are caught
        # by the same split/retry transaction as constraint violations.
        $stageColumns=@($columns | ForEach-Object { $_.Groups['name'].Value+' '+$(if ($_.Groups['name'].Value -eq 'urn') {'integer'} else {'text'}) })
        $typedValues=@($columns | ForEach-Object { 's.'+$_.Groups['name'].Value+'::'+$_.Groups['type'].Value })
        $stage='CREATE TEMP TABLE establishment_seed_stage ('+($stageColumns -join ',')+') ON COMMIT PRESERVE ROWS;'
        # Create the reusable typed workspace once. Retrying a bad row must not
        # recreate tables/indexes or re-extract reference metadata each time.
        $alterations=[regex]::Matches($loader,'(?s)ALTER TABLE source_establishment_fixture\s+ADD COLUMN.*?;')
        $lookupStart=$loader.IndexOf('CREATE TEMP TABLE imported_reference_mapping ')
        $lookupEnd=$loader.IndexOf('\echo Resolving source-owned establishment classifications...')
        $siteStart=$loader.IndexOf('CREATE TEMP TABLE source_main_site_fixture AS')
        $siteEnd=$loader.IndexOf('INSERT INTO establishment.address (',$siteStart)
        if ($alterations.Count -ne 2 -or $lookupStart -lt 0 -or $lookupEnd -le $lookupStart -or $siteStart -lt 0 -or $siteEnd -le $siteStart) {
            throw 'Core loader workspace sections not found.'
        }
        $lookup=$loader.Substring($lookupStart,$lookupEnd-$lookupStart)
        $sites=$loader.Substring($siteStart,$siteEnd-$siteStart)
        $initialize=$definition+"`nCREATE UNIQUE INDEX ON source_establishment_fixture(urn);`n"+(@($alterations | ForEach-Object {$_.Value}) -join "`n")+"`n"+$lookup+$sites
        $initialize=$initialize.Replace('ON COMMIT DROP','ON COMMIT PRESERVE ROWS')
        $body=[regex]::Replace($loader,'(?m)^(BEGIN|COMMIT);\r?$','')
        $body=[regex]::Replace($body,'(?m)^\\echo[^\r\n]*\r?\n','')
        $body=$body.Replace($definition,'').Replace($lookup,'').Replace('DROP TABLE imported_reference_mapping;','')
        foreach ($alteration in $alterations) {$body=$body.Replace($alteration.Value,'')}
        $body=[regex]::Replace($body,'(?m)^CREATE UNIQUE INDEX ON source_establishment_fixture[^\r\n]*\r?\n','')
        $body=$body.Replace($sites,$sites.Replace('CREATE TEMP TABLE source_main_site_fixture AS','INSERT INTO source_main_site_fixture'))
        $columnNames=@($columns | ForEach-Object {$_.Groups['name'].Value})
        $insert='INSERT INTO source_establishment_fixture ('+($columnNames -join ',')+') SELECT '+($typedValues -join ',')+' FROM establishment_seed_stage s WHERE s.urn IN (__BATCH_URNS__);'
        $body=[regex]::Replace($body,'(?m)^\\copy source_establishment_fixture[^\r\n]*',$insert)
        # Dev seeding is an initial snapshot, without council/history replay logic.
        $body=$body.Replace("SELECT pg_advisory_xact_lock(hashtextextended('council-maintenance-transition',0));",'')
        $body=[regex]::Replace($body,'DELETE FROM source_establishment_fixture s\s+WHERE NOT migration\.allow_establishment_replay\([^;]+;','')
        # Successful attempts leave the reusable workspace empty. A failed
        # attempt rolls back its workspace inserts along with its target rows.
        $body+="`nDELETE FROM source_main_site_fixture; DELETE FROM source_establishment_fixture;`n"
        $runner=Get-Content (Get-SchemaPath 'migration/load-development-establishment-seed.sql') -Raw
        $runner=$runner.Replace('__BATCH_SIZE__',[string]$BatchSize).Replace('__RUN_ID__',[string]$runId).Replace('__KNOWN_BAD_COUNT__',[string]$ignored.Count).Replace('__LOAD_SQL__',$body.Replace("'","''"))
        $csvSql=$csv.Replace('\','/').Replace("'","''")
        $sql="SET synchronous_commit=off;`n"+$stage+"`n\copy establishment_seed_stage FROM '$csvSql' WITH (FORMAT csv, HEADER true, DELIMITER '|', NULL 'NULL')`nCREATE UNIQUE INDEX ON establishment_seed_stage(urn); ANALYZE establishment_seed_stage;`n"+$initialize+"`n"+$runner
        $path=Join-Path $WorkingDirectory 'load-development-establishments.sql'
        [IO.File]::WriteAllText($path,$sql,[Text.UTF8Encoding]::new($false))
        $cacheState=@{Entries=[Collections.Generic.List[object]]::new()}
        foreach ($entry in $known) {$cacheState.Entries.Add($entry)}
        $onLine={
            param($line)
            $marker='EPR_REJECTIONS '
            $position=$line.IndexOf($marker)
            if ($position -ge 0) {
                $records=ConvertFrom-Json $line.Substring($position+$marker.Length)
                foreach ($record in $records) {
                    $record | Add-Member NoteProperty source_database $Source.Database -Force
                    $cacheState.Entries.Add($record)
                }
                Save-KnownBadEstablishments -Path $KnownBadFile -Entries $cacheState.Entries.ToArray()
            } elseif ($line -match 'INFO:\s*(Establishments processed:.*)$') {
                Write-Host $Matches[1]
            } elseif ($line.Trim()) {Write-Host $line}
        }
        Invoke-Psql -Target $Target -File $path -Quiet -OnOutputLine $onLine -FailureMessage 'Development establishment seed failed'
        $summary=ConvertFrom-Json (Invoke-Psql -Target $Target -Output Scalar -Command "SELECT notes FROM migration.migration_run WHERE migration_run_id='$runId';" -FailureMessage 'Dev seed summary failed')
        $summary | Add-Member NoteProperty run_id $runId
        return $summary
    } catch {
        try {
            $null=Invoke-Psql -Target $Target -Output Scalar -Command "UPDATE migration.migration_run SET status='failed',completed_at=clock_timestamp() WHERE migration_run_id='$runId';" -FailureMessage 'Dev seed failure status update failed'
        } catch { Write-Warning 'Could not record the failed development seed status.' }
        throw
    }
}
