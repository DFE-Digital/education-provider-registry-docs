# Current SEN reference meanings and complete establishment association sets.
function Import-SenReferenceData {
    param([Parameter(Mandatory)]$Source, [Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory)
    Write-Step 'Reconciling current SEN reference data'
    $csvPath = Join-Path $WorkingDirectory 'sen-reference.csv'
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/sen-reference-from-bau.sql') `
        -CsvPath $csvPath -RowCount AtLeastOne -Description 'SEN reference data' | Out-Null
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-sen-reference-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description 'SEN reference data'
}

function Import-EstablishmentSenFromBau {
    param([Parameter(Mandatory)]$Source, [Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][ValidateRange(1,999999)][int]$Urn,
          [Parameter(Mandatory)][string]$WorkingDirectory)
    Write-Step "Loading SEN associations for URN $Urn"
    $csvPath = Join-Path $WorkingDirectory "establishment-sen-$Urn.csv"
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-sen-from-bau.sql') `
        -Variables @{ URN = $Urn } -CsvPath $csvPath -RowCount AtLeastOne -Description "SEN associations for $Urn" | Out-Null
    Invoke-FixtureLoad -Target $Target -LoadSqlFile (Get-SchemaPath 'establishment/load/load-establishment-sen-fixture.sql') `
        -CsvPath $csvPath -WorkingDirectory $WorkingDirectory -Description "SEN associations for $Urn" `
        -TemplateValues @{ EXPECTED_URN = $Urn; SOURCE_DATABASE = $Source.Database }
}

function Update-EstablishmentSenFromBau {
    <#
    .SYNOPSIS
    Adds and migrates SEN for every establishment already in the local target.
    Extracts first, takes a full database backup, then applies one transaction.
    #>
    param([Parameter(Mandatory)]$Source, [Parameter(Mandatory)]$Target,
          [Parameter(Mandatory)][string]$WorkingDirectory)
    Write-Step 'Preparing additive SEN migration for the existing local selection'
    $urnText = Invoke-Psql -Target $Target -Command 'SELECT urn FROM establishment.establishment ORDER BY urn' `
        -Output Scalar -FailureMessage 'Cannot read existing target selection'
    $urns = @($urnText -split '\s+' | Where-Object { $_ } | ForEach-Object { [int]$_ })
    if ($urns.Count -eq 0) { throw 'The local target contains no establishments.' }
    $referenceCsv = Join-Path $WorkingDirectory 'sen-reference.csv'
    Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/sen-reference-from-bau.sql') `
        -CsvPath $referenceCsv -RowCount AtLeastOne -Description 'SEN reference data' | Out-Null
    foreach ($urn in $urns) {
        Export-BauQueryToCsv -Source $Source -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-sen-from-bau.sql') `
            -Variables @{ URN=$urn } -CsvPath (Join-Path $WorkingDirectory "establishment-sen-$urn.csv") `
            -RowCount AtLeastOne -Description "SEN associations for $urn" | Out-Null
    }
    $backupPath = Join-Path $WorkingDirectory 'before-sen-migration.sql'
    Invoke-PgDump -Target $Target -Arguments @('--no-owner','--no-privileges','--file',$backupPath) `
        -FailureMessage 'Pre-migration backup failed'

    $sql = "BEGIN;`n" + (Get-Content -LiteralPath (Get-SchemaPath 'establishment/sen-schema.sql') -Raw) + "`n"
    $referenceSql = Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-sen-reference-fixture.sql') -Raw
    $sql += [regex]::Replace($referenceSql, '(?m)^(BEGIN|COMMIT);\r?$', '').Replace('__FIXTURE_PATH__',
        ($referenceCsv.Replace('\','/').Replace("'","''"))) + "`n"
    $linkSql = Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-establishment-sen-fixture.sql') -Raw
    foreach ($urn in $urns) {
        $csv = Join-Path $WorkingDirectory "establishment-sen-$urn.csv"
        $sql += [regex]::Replace($linkSql, '(?m)^(BEGIN|COMMIT);\r?$', '').Replace('__FIXTURE_PATH__',
            $csv.Replace('\','/').Replace("'","''")).Replace('__EXPECTED_URN__',[string]$urn).Replace(
            '__SOURCE_DATABASE__',$Source.Database.Replace("'","''")) + "`n"
    }
    $sql += (Get-Content -LiteralPath (Get-SchemaPath 'migration/validate-scripts/validate-sen.sql') -Raw) + "`nCOMMIT;`n"
    $upgradePath = Join-Path $WorkingDirectory 'migrate-sen.sql'
    [System.IO.File]::WriteAllText($upgradePath, $sql, [System.Text.UTF8Encoding]::new($false))
    Invoke-Psql -Target $Target -File $upgradePath -FailureMessage 'Additive SEN migration failed; transaction rolled back'
    Write-Host "SEN migrated for $($urns.Count) establishments. Pre-migration backup: $backupPath"
}

function Test-SenMigration {
    # Exercise the actual loader, rolling every case back in its own session.
    param([Parameter(Mandatory)]$Target)
    Write-Step 'Test: SEN lookup, constraints and migration replay'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/validate-scripts/validate-sen.sql') -FailureMessage 'SEN validation failed'
    $urn = [int](Invoke-Psql -Target $Target -Command 'SELECT min(urn) FROM establishment.establishment' `
        -Output Scalar -FailureMessage 'Cannot choose SEN test owner')
    $workspace = Join-Path ([System.IO.Path]::GetTempPath()) ('epr-sen-test-' + [guid]::NewGuid())
    New-Item -ItemType Directory -Path $workspace | Out-Null
    try {
        $header = 'urn|source_bucket|sen_code|source_sen_name|source_archived'
        $cases = @(
            @{ Name='multiple'; Rows=@("$urn|1|04|ASD - Autistic Spectrum Disorder|NULL", "$urn|1|07|PD - Physical Disability|0"); Codes='04,07' },
            @{ Name='excluded-na'; Rows=@("$urn|1|00|Not Applicable|0"); Codes='' },
            @{ Name='mixed-na'; Rows=@("$urn|1|00|Not Applicable|0", "$urn|1|04|ASD - Autistic Spectrum Disorder|NULL"); Codes='04' },
            @{ Name='legacy-na'; Rows=@("$urn|2|00|Not Applicable|0"); Codes='' },
            @{ Name='absent'; Rows=@("$urn|NULL|NULL|NULL|NULL"); Codes='' },
            @{ Name='archived-only'; Rows=@("$urn|1|13|Hospital School|1"); Codes='' },
            @{ Name='archive-exclusion'; Rows=@("$urn|1|04|ASD - Autistic Spectrum Disorder|NULL", "$urn|2|13|Hospital School|1"); Codes='04' },
            @{ Name='duplicate'; Rows=@("$urn|1|04|ASD - Autistic Spectrum Disorder|NULL", "$urn|1|04|ASD - Autistic Spectrum Disorder|NULL"); Error='Invalid or duplicate SEN' },
            @{ Name='legacy-current'; Rows=@("$urn|2|04|ASD - Autistic Spectrum Disorder|NULL"); Error='legacy bucket 2-4' },
            @{ Name='orphan'; Rows=@("$urn|1|04|NULL|NULL"); Error='missing lookup reference' },
            @{ Name='unsupported'; Rows=@("$urn|1|98|Unsupported|0"); Error='Unsupported current SEN' },
            @{ Name='invalid-flag'; Rows=@("$urn|1|04|ASD - Autistic Spectrum Disorder|2"); Error='archive flag' },
            @{ Name='missing-source'; Rows=@(); Error='requested existing establishment' },
            @{ Name='wrong-owner'; Rows=@('0|1|04|ASD - Autistic Spectrum Disorder|NULL'); Error='requested existing establishment' }
        )
        foreach ($case in $cases) {
            $csv = Join-Path $workspace ($case.Name + '.csv')
            $csvText = $header + "`n"
            if ($case.Rows.Count) { $csvText += ($case.Rows -join "`n") + "`n" }
            [System.IO.File]::WriteAllText($csv, $csvText, [System.Text.UTF8Encoding]::new($false))
            $body = Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-establishment-sen-fixture.sql') -Raw
            $body = [regex]::Replace($body, '(?m)^(BEGIN|COMMIT);\r?$', '').Replace('__FIXTURE_PATH__',
                $csv.Replace('\','/').Replace("'","''")).Replace('__EXPECTED_URN__',[string]$urn).Replace('__SOURCE_DATABASE__','sen-test_local')
            $sql = "BEGIN;`nCREATE TEMP TABLE before_sen AS SELECT * FROM establishment.establishment_sen;`n" + $body
            if (-not $case.Error) {
                $expected = $case.Codes
                $assertion = @'
DO $$
BEGIN
    IF coalesce((SELECT string_agg(s.code, ',' ORDER BY s.code)
        FROM establishment.establishment_sen l JOIN establishment.sen s USING(sen_id)
        JOIN establishment.establishment e USING(establishment_id) WHERE e.urn=__TEST_URN__),'') <> '__EXPECTED_CODES__' THEN
        RAISE EXCEPTION 'SEN complete-set reconciliation failed';
    END IF;
    IF EXISTS (SELECT 1 FROM before_sen b JOIN establishment.establishment_sen l
        USING(establishment_id,sen_id) WHERE b.establishment_sen_id <> l.establishment_sen_id) THEN
        RAISE EXCEPTION 'SEN replay changed an existing association UUID';
    END IF;
END $$;
'@
                $sql += $assertion.Replace('__TEST_URN__',[string]$urn).Replace('__EXPECTED_CODES__',$expected)
                # Run the same input twice and verify complete-set idempotence.
                $sql += "`nCREATE TEMP TABLE first_sen AS SELECT * FROM establishment.establishment_sen;`n" + $body + @'

DO $$ BEGIN
    IF EXISTS ((SELECT * FROM first_sen EXCEPT SELECT * FROM establishment.establishment_sen)
        UNION ALL (SELECT * FROM establishment.establishment_sen EXCEPT SELECT * FROM first_sen)) THEN
        RAISE EXCEPTION 'SEN replay is not idempotent';
    END IF;
END $$;
'@
            }
            $sql += "`nROLLBACK;`n"
            $path = Join-Path $workspace ($case.Name + '.sql')
            [System.IO.File]::WriteAllText($path,$sql,[System.Text.UTF8Encoding]::new($false))
            $client = Get-PostgresClientPath -Tool psql
            $arguments = Get-PsqlArgumentList -Target $Target -File $path -Output Scalar
            $result = Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
                $previousPreference = $ErrorActionPreference
                try { $ErrorActionPreference='Continue'; $output = & $client @arguments 2>&1; $code=$LASTEXITCODE }
                finally { $ErrorActionPreference=$previousPreference }
                # Out-String formats native ErrorRecords to the host width and
                # can wrap an expected message in the middle of a phrase.
                # Keep the original stderr messages without display formatting.
                [pscustomobject]@{ Code=$code; Text=(($output | ForEach-Object { $_.ToString() }) -join [Environment]::NewLine) }
            }
            if ($case.Error) {
                $errorText = [regex]::Replace($result.Text, '\s+', ' ')
                if ($result.Code -eq 0 -or $errorText -notlike "*$($case.Error)*") { throw "SEN case $($case.Name) failed: $($result.Text)" }
            } elseif ($result.Code -ne 0) { throw "SEN case $($case.Name) failed: $($result.Text)" }
        }
        Write-Host "    $($cases.Count) SEN loader cases passed; all changes rolled back."
    } finally { Remove-RunWorkspace -Path $workspace }
}
