function Import-GovernanceFixture {
    <# Rebuild and load atomically, retaining the old schema if validation fails. #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][string]$CsvPath,
        [Parameter(Mandatory)][string]$WorkingDirectory
    )
    Assert-LocalPostgresTarget -PostgresHost $Target.PostgresHost -Database $Target.Database
    if ($Target.Database -notin @('governance_local','epr_governance','governance')) {
        throw 'Governance rebuild requires governance_local, epr_governance or governance.'
    }
    $schemaFile = Get-SchemaPath 'governance/governance-schema.sql'
    $loadFile = Get-SchemaPath 'governance/load/load-governance-appointment-fixture.sql'
    Assert-FileExists -Path @($schemaFile, $loadFile, $CsvPath)
    $schemaSql = Get-Content -LiteralPath $schemaFile -Raw
    $loadSql = Get-Content -LiteralPath $loadFile -Raw
    $fixturePath = $CsvPath.Replace('\','/').Replace("'","''")
    # The fixture loader owns BEGIN/COMMIT. Place DDL inside that transaction.
    if ([regex]::Matches($loadSql, '(?m)^BEGIN;\s*$').Count -ne 1) {
        throw 'Expected one transaction start in the Governance fixture loader.'
    }
    $loadSql = $loadSql.Replace('__FIXTURE_PATH__', $fixturePath)
    $loadSql = $loadSql.Replace('BEGIN;', "BEGIN;`n$schemaSql")
    $validationSql = @'
DO $$
BEGIN
    IF (SELECT count(*) FROM governance.governance_role_type) <> 8
       OR (SELECT count(*) FROM governance.governance_appointment) <>
          (SELECT count(*) FROM source_governance_appointment_fixture)
       OR (SELECT count(*) FROM governance.term_of_office) <>
          (SELECT count(*) FROM source_governance_appointment_fixture WHERE term_start_date IS NOT NULL OR term_end_date IS NOT NULL)
       OR (SELECT count(*) FROM governance.office_holder_assignment) <>
          (SELECT count(*) FROM source_governance_appointment_fixture WHERE office_holder_role_type_id IS NOT NULL) THEN
        RAISE EXCEPTION 'Governance seed row counts do not match the extracted fixture';
    END IF;
END $$;
SELECT 'governance_role_type' AS table_name,count(*) AS rows FROM governance.governance_role_type
UNION ALL SELECT 'governance_appointment',count(*) FROM governance.governance_appointment
UNION ALL SELECT 'term_of_office',count(*) FROM governance.term_of_office
UNION ALL SELECT 'office_holder_assignment',count(*) FROM governance.office_holder_assignment;
'@
    $loadSql = $loadSql.Replace('COMMIT;', "$validationSql`nCOMMIT;")
    $workingCopy = Join-Path $WorkingDirectory 'rebuild-governance.sql'
    [IO.File]::WriteAllText($workingCopy, $loadSql, [Text.UTF8Encoding]::new($false))
    Write-Step "Rebuilding Governance on $($Target.PostgresHost):$($Target.Port)/$($Target.Database)"
    Invoke-Psql -Target $Target -File $workingCopy -FailureMessage 'Governance rebuild failed; schema reset and load were rolled back'
}

function Import-BauGovernanceSeed {
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [ValidateRange(1,999999)][int]$Urn
    )
    $transform = Get-SchemaPath 'governance/transforms/governance-appointment-from-bau.sql'
    Assert-FileExists -Path @($transform, (Get-SchemaPath 'governance/governance-schema.sql'),
        (Get-SchemaPath 'governance/load/load-governance-appointment-fixture.sql'))
    $selection = if ($PSBoundParameters.ContainsKey('Urn')) { [string]$Urn } else { 'NULL' }
    $csv = Join-Path $WorkingDirectory 'governance-appointments.csv'
    Write-Step 'Extracting current Governance appointments from local BAU'
    $count = Export-BauQueryToCsv -Source $Source -SqlFile $transform -Variables @{URN=$selection} `
        -CsvPath $csv -RowCount AtLeastOne -Description 'Governance appointments'
    Import-GovernanceFixture -Target $Target -CsvPath $csv -WorkingDirectory $WorkingDirectory
    Write-Host "Governance development seed completed: $count appointments loaded."
}
