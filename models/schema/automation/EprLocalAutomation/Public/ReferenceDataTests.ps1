function Test-BauReferenceData {
    # Exercise the actual importer using the retained source extract. Every
    # test is rolled back, including source provenance and label changes.
    param([Parameter(Mandatory)]$Target)
    Write-Step 'Test: source-owned reference import and reconciliation'
    $json=Invoke-Psql -Target $Target -Command @'
SELECT notes::jsonb->'source_rows' FROM migration.migration_run
WHERE run_type='reference-data' AND status='completed' ORDER BY completed_at DESC LIMIT 1;
'@ -Output Scalar -FailureMessage 'Cannot read reference-source evidence'
    if (-not $json) { throw 'No source reference extract has been retained for this target.' }
    $parsedRows=ConvertFrom-Json -InputObject $json
    $baseRows=@(foreach($row in $parsedRows) { $row })
    $columns=@('reference_list','source_table','code','name','archived','group_code')
    $workspace=Join-Path ([IO.Path]::GetTempPath()) ('epr-reference-test-'+[guid]::NewGuid())
    New-Item -ItemType Directory -Path $workspace | Out-Null
    try {
        $cases=@(
            @{Name='replay'},
            @{Name='source-label';Label='Label supplied by the source';Assert="IF (SELECT name FROM establishment.boarding_provision WHERE boarding_provision_id=4)<>'Label supplied by the source' THEN RAISE EXCEPTION 'Source label was not imported'; END IF;"},
            @{Name='new-diocese';AddCode='ZZ99';AddName='New source diocese';Archive=0;Assert="IF NOT EXISTS(SELECT 1 FROM establishment.diocese WHERE code='ZZ99' AND name='New source diocese') THEN RAISE EXCEPTION 'Complete source list was not imported'; END IF;"},
            @{Name='archived-diocese';AddCode='ZZ99';AddName='Archived source diocese';Archive=1;Assert="IF EXISTS(SELECT 1 FROM establishment.diocese WHERE code='ZZ99') THEN RAISE EXCEPTION 'Archived source row was imported'; END IF;"},
            @{Name='absence';AddCode='ZZ99';AddName='Not applicable';Archive=0;Assert="IF EXISTS(SELECT 1 FROM establishment.diocese WHERE code='ZZ99') THEN RAISE EXCEPTION 'Absence row was imported'; END IF;"},
            @{Name='missing-dictionary';Omit='boarding_provision';Error='cover all 19 dictionaries'},
            @{Name='duplicate-code';Duplicate=$true;Error='duplicate key'},
            @{Name='invalid-flag';InvalidFlag=$true;Error='archive flag'},
            @{Name='invalid-code';InvalidCode=$true;Error='Non-numeric business code'}
        )
        foreach($case in $cases) {
            $rows=@($baseRows | Select-Object $columns)
            if($case.Omit) { $rows=@($rows | Where-Object { $_.reference_list -ne $case.Omit }) }
            if($case.Label) { ($rows | Where-Object { $_.reference_list -eq 'boarding_provision' -and $_.code -eq '4' }).name=$case.Label }
            if($case.InvalidFlag) { ($rows | Where-Object { $_.reference_list -eq 'boarding_provision' -and $_.code -eq '4' }).archived=7 }
            if($case.InvalidCode) { ($rows | Where-Object { $_.reference_list -eq 'boarding_provision' -and $_.code -eq '4' }).code='X' }
            if($case.Duplicate) { $rows+=@($rows[0]) }
            if($case.AddCode) { $rows+=@([pscustomobject]@{reference_list='diocese';source_table='dbo.Diocese';code=$case.AddCode;name=$case.AddName;archived=$case.Archive;group_code=$null}) }
            $csv=Join-Path $workspace ($case.Name+'.csv')
            $lines=@($columns -join '|') + @(foreach($row in $rows) {
                $values=foreach($column in $columns) { ConvertTo-FixtureValue -Value $row.$column }
                $values -join '|'
            })
            [IO.File]::WriteAllLines($csv,[string[]]$lines,[Text.UTF8Encoding]::new($false))
            $body=Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-reference-data-fixture.sql') -Raw
            $body=[regex]::Replace($body,'(?m)^(BEGIN|COMMIT);\r?$','').Replace('__FIXTURE_PATH__',
                $csv.Replace('\','/').Replace("'","''")).Replace('__SOURCE_DATABASE__','reference-test_local')
            $sql="BEGIN;`nCREATE TEMP TABLE before_diocese AS SELECT * FROM establishment.diocese;`n"+$body
            if(-not $case.Error) {
                $sql+=@'

DO $$ BEGIN
    IF EXISTS(SELECT 1 FROM before_diocese b JOIN establishment.diocese d USING(code)
        WHERE b.diocese_id<>d.diocese_id) THEN RAISE EXCEPTION 'Reference replay changed a diocese UUID'; END IF;
'@
                $sql+="`n"+$case.Assert+"`nEND `$$;`n"
            }
            $sql+="`nROLLBACK;`n"
            $path=Join-Path $workspace ($case.Name+'.sql')
            [IO.File]::WriteAllText($path,$sql,[Text.UTF8Encoding]::new($false))
            $client=Get-PostgresClientPath -Tool psql
            $arguments=Get-PsqlArgumentList -Target $Target -File $path -Output Scalar
            $result=Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
                $previousPreference=$ErrorActionPreference
                try { $ErrorActionPreference='Continue'; $output=& $client @arguments 2>&1; $code=$LASTEXITCODE }
                finally { $ErrorActionPreference=$previousPreference }
                [pscustomobject]@{Code=$code;Text=(($output | ForEach-Object {$_.ToString()}) -join [Environment]::NewLine)}
            }
            if($case.Error) {
                if($result.Code -eq 0 -or [regex]::Replace($result.Text,'\s+',' ') -notlike "*$($case.Error)*") {throw "Reference case $($case.Name) failed: $($result.Text)"}
            } elseif($result.Code -ne 0) {throw "Reference case $($case.Name) failed: $($result.Text)"}
        }
        Write-Host "    $($cases.Count) source-reference importer cases passed; all changes rolled back."
    } finally { Remove-RunWorkspace -Path $workspace }
}
