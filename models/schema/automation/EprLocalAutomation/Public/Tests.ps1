# Tests that run against a loaded local establishment database. Each test can
# be run on its own; Invoke-EstablishmentTests runs them all.

function Test-EstablishmentCoreValidation {
    <#
    .SYNOPSIS
    Checks that every core establishment table is populated and the keys join up.
    #>
    param([Parameter(Mandatory)]$Target)

    Write-Step 'Test: core establishment validation'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-establishment-fixture.sql') -FailureMessage 'Core establishment validation failed'
}

function Test-EstablishmentGroupsValidation {
    <#
    .SYNOPSIS
    Checks the legal entities, roles, classifications, responsibilities and
    group identifiers loaded for the selected establishments.
    #>
    param([Parameter(Mandatory)]$Target)

    Write-Step 'Test: establishment-groups validation'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-academy-trust-responsibilities.sql') -FailureMessage 'Establishment-groups validation failed'
    Test-EstablishmentIdentityResolution -Target $Target
}

function Test-EstablishmentIdentityResolution {
    # Use the bounded T1 sponsor fixture to test the actual loader, rolling
    # back successful loads and allowing failed transactions to disconnect.
    param([Parameter(Mandatory)]$Target)
    $hasSponsor = Invoke-Psql -Target $Target -Output Scalar -FailureMessage 'Identity fixture lookup failed' -Command @'
SELECT count(*) FROM establishment.group_identifier i
JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
WHERE t.name = 'Group UID' AND i.value = '4949';
'@
    if ($hasSponsor -ne '1') { throw 'Identity resolution tests require the T1 sponsor fixture.' }
    Write-Step 'Test: migration identity resolution'
    $loader = Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw
    $insertTemplate = @'
INSERT INTO establishment_party_role_fixture (
    legal_entity_name, group_uid, group_id, establishment_party_role_type,
    responsibility_type, is_current, establishment_urn,
    responsibility_start_date, responsibility_is_current
) VALUES ('The Co-operative Group', '__TEST_UID__', NULL, 'School sponsor',
          'Sponsored by', true, 136102, DATE '2010-09-01', true);
'@
    $assertion = @'
DO $$ BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM establishment_party_role_fixture f
        JOIN establishment.group_identifier i ON i.value = '4949'
        JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
        JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
        WHERE t.name = 'Group UID' AND f.resolved_legal_entity_id = r.legal_entity_id
          AND f.identity_resolution_method = 'existing-source-group-uid'
    ) THEN RAISE EXCEPTION 'Repeated source UID did not retain its resolved owner'; END IF;
END $$;
ROLLBACK;
'@
    $successSql = [regex]::Replace($loader, '(?m)^\\copy[^\r\n]*', $insertTemplate.Replace('__TEST_UID__', '4949'))
    $successSql = [regex]::Replace($successSql, '(?m)^COMMIT;', [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $assertion })
    # Loader SQL can exceed Windows' command-line length limit. Execute a
    # temporary file instead of passing the whole loader through psql -c.
    $successPath = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($successPath, $successSql, [System.Text.UTF8Encoding]::new($false))
        $null = Invoke-Psql -Target $Target -File $successPath -Output Scalar -FailureMessage 'Repeated source UID test failed'
    } finally { Remove-Item -LiteralPath $successPath -ErrorAction SilentlyContinue }

    $conflictingIdentifiers = @'
INSERT INTO establishment_party_role_fixture (
    legal_entity_name, companies_house_number, ukprn, group_uid,
    establishment_party_role_type, responsibility_type, academy_trust_type,
    is_current, establishment_urn, responsibility_start_date, responsibility_is_current
) VALUES ('M1 conflicting identity', '07747126', '10061289', '2777',
          'Academy trust', 'Run by academy trust', 'Multi-academy trust',
          true, 136102, DATE '2015-07-01', true);
'@
    $collisionCases = @(
        @{ Insert = $insertTemplate.Replace('__TEST_UID__', 'M1_TEST_UNKNOWN_UID'); Expected = '*only a name match; identity review required*' },
        @{ Insert = $conflictingIdentifiers; Expected = '*conflicting company and UKPRN owners; identity review required*' }
    )
    $personCount = Invoke-Psql -Target $Target -Output Scalar -FailureMessage 'Person sponsor lookup failed' -Command @'
SELECT count(*) FROM establishment.group_identifier i
JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
WHERE t.name='Group UID' AND i.value='2613' AND r.person_id IS NOT NULL;
'@
    if ($personCount -eq '1') {
        $personInsert = @'
INSERT INTO establishment_party_role_fixture (
 legal_entity_name,group_uid,group_id,establishment_party_role_type,responsibility_type,
 is_current,establishment_urn,responsibility_start_date,responsibility_is_current,party_kind,party_mapping_evidence
) VALUES ('Charles Dunstone','2613','SP00099','School sponsor','Sponsored by',true,135936,
          DATE '2009-09-01',true,'person','T7 reviewed person sponsor repeat-import regression test');
'@
        $personAssertion = @'
DO $$ BEGIN
 IF (SELECT count(*) FROM establishment.person)<>(SELECT row_count FROM person_reimport_count)
    OR NOT EXISTS (SELECT 1 FROM establishment_party_role_fixture f
       JOIN establishment.group_identifier i ON i.value='2613'
       JOIN establishment.group_identifier_type t USING (group_identifier_type_id)
       JOIN establishment.establishment_party_role r USING (establishment_party_role_id)
       WHERE t.name='Group UID' AND f.resolved_person_id=r.person_id
         AND f.resolved_legal_entity_id IS NULL AND f.identity_resolution_method='existing-source-group-uid')
 THEN RAISE EXCEPTION 'Person sponsor reimport must retain its endpoint without a legal entity'; END IF;
END $$;
ROLLBACK;
'@
        $personSql = [regex]::Replace($loader, '(?m)^\\copy[^\r\n]*', $personInsert)
        $personSql = [regex]::Replace($personSql, '(?m)^COMMIT;', [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $personAssertion })
        $personSql = "CREATE TEMP TABLE person_reimport_count AS SELECT count(*) AS row_count FROM establishment.person;`n" + $personSql
        $personPath = [System.IO.Path]::GetTempFileName()
        try {
            [System.IO.File]::WriteAllText($personPath, $personSql, [System.Text.UTF8Encoding]::new($false))
            $null = Invoke-Psql -Target $Target -File $personPath -Output Scalar -FailureMessage 'Person sponsor reimport test failed'
        } finally { Remove-Item -LiteralPath $personPath -ErrorAction SilentlyContinue }
        $collisionCases += @(
            @{ Insert = $personInsert.Replace("true,'person',", "true,'legal_entity',"); Expected = '*Legal-entity source UID already belongs to a person*' },
            @{ Insert = $personInsert.Replace("'T7 reviewed person sponsor repeat-import regression test'", 'NULL'); Expected = '*Person sponsor requires an explicit reviewed mapping*' }
        )
    }
    foreach ($collisionCase in $collisionCases) {
        $collisionSql = [regex]::Replace($loader, '(?m)^\\copy[^\r\n]*', $collisionCase.Insert)
        $collisionSql = [regex]::Replace($collisionSql, '(?m)^COMMIT;', 'ROLLBACK;')
        $psql = Get-PostgresClientPath -Tool psql
        $collisionPath = [System.IO.Path]::GetTempFileName()
        try {
            [System.IO.File]::WriteAllText($collisionPath, $collisionSql, [System.Text.UTF8Encoding]::new($false))
            $arguments = Get-PsqlArgumentList -Target $Target -File $collisionPath -Output Scalar
            $result = Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
                $preferenceBefore = $ErrorActionPreference
                try {
                    $ErrorActionPreference = 'Continue'
                    $messages = (& $psql @arguments 2>&1 | ForEach-Object { $_.ToString() } | Out-String -Width 4096)
                    [pscustomobject]@{ ExitCode = $LASTEXITCODE; Messages = $messages }
                } finally { $ErrorActionPreference = $preferenceBefore }
            }
            if ($result.ExitCode -eq 0 -or $result.Messages -notlike $collisionCase.Expected) {
                throw "Identity collision was not rejected as expected: $($result.Messages)"
            }
        } finally { Remove-Item -LiteralPath $collisionPath -ErrorAction SilentlyContinue }
    }
    Write-Host '    Existing source UID retained; name-only and conflicting-identifier collisions rejected. Test loads rolled back.' -ForegroundColor Green
    if ($personCount -eq '1') {
        Write-Host '    Person sponsor endpoint retained on reimport; party-kind conflicts and missing review evidence rejected. Test loads rolled back.' -ForegroundColor Green
    }
}

function Test-ControlledProprietorReimport {
    # Execute the real loader again, then roll it back. No source connection
    # is needed, so the same regression test runs after checked-in replay.
    param([Parameter(Mandatory)]$Target,[Parameter(Mandatory)]$Fixture)
    Write-Step 'Test: controlled proprietor reimport and required review'
    $loader = Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-controlled-proprietor-fixture.sql') -Raw
    $context = @'
INSERT INTO proprietor_local_context VALUES
 (112461,'Underley Garden School','10','1','01','Individual Proprietor',1),
 (119009,'Heath Farm School','10','1','01','Individual Proprietor',1);
'@
    $loader = [regex]::Replace($loader, '(?m)^\\copy[^\r\n]*', $context)
    $baseline = @'
SELECT set_config('epr.migration_run_id',
 (SELECT migration_run_id::text FROM migration.migration_run WHERE run_type='establishment-rebuild'),false);
CREATE TEMP TABLE proprietor_reimport_baseline AS SELECT
 (SELECT count(*) FROM establishment.legal_entity) AS parties,
 (SELECT count(*) FROM establishment.establishment_responsibility) AS responsibilities,
 (SELECT count(*) FROM migration.source_snapshot) AS snapshots,
 (SELECT count(*) FROM migration.source_record) AS sources,
 (SELECT count(*) FROM migration.identity_resolution) AS decisions,
 (SELECT count(*) FROM migration.establishment_responsibility_evidence) AS evidence;
'@
    $assertion = @'
DO $$ BEGIN
 IF EXISTS (SELECT 1 FROM proprietor_reimport_baseline b WHERE
   b.parties<>(SELECT count(*) FROM establishment.legal_entity) OR
   b.responsibilities<>(SELECT count(*) FROM establishment.establishment_responsibility) OR
   b.snapshots<>(SELECT count(*) FROM migration.source_snapshot) OR
   b.sources<>(SELECT count(*) FROM migration.source_record) OR
   b.decisions<>(SELECT count(*) FROM migration.identity_resolution) OR
   b.evidence<>(SELECT count(*) FROM migration.establishment_responsibility_evidence))
 THEN RAISE EXCEPTION 'Controlled proprietor reimport duplicated parties, relationships or evidence'; END IF;
END $$;
ROLLBACK;
'@
    $reimport = $loader.Replace('__CONTROLLED_PROPRIETOR_JSON__',
        ($Fixture | ConvertTo-Json -Depth 6 -Compress).Replace("'", "''"))
    $reimport = [regex]::Replace($reimport,'(?m)^COMMIT;', [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $assertion })
    $path = [System.IO.Path]::GetTempFileName()
    try {
        [System.IO.File]::WriteAllText($path, $baseline + "`n" + $reimport, [System.Text.UTF8Encoding]::new($false))
        $null = Invoke-Psql -Target $Target -File $path -Output Scalar -FailureMessage 'Controlled proprietor reimport test failed'
        foreach ($test in @(
            @{ Change='reviewEvidence'; Value=''; Expected='*requires an explicit accepted identity decision*' },
            @{ Change='name'; Value='T9 conflicting accepted party'; Expected='*identity collision; review required*' }
        )) {
            $badFixture = $Fixture | ConvertTo-Json -Depth 6 | ConvertFrom-Json
            $badFixture.($test.Change) = $test.Value
            $badSql = $loader.Replace('__CONTROLLED_PROPRIETOR_JSON__',
                ($badFixture | ConvertTo-Json -Depth 6 -Compress).Replace("'", "''"))
            $badSql = [regex]::Replace($badSql,'(?m)^COMMIT;','ROLLBACK;')
            [System.IO.File]::WriteAllText($path, $baseline + "`n" + $badSql, [System.Text.UTF8Encoding]::new($false))
            $psql = Get-PostgresClientPath -Tool psql
            $arguments = Get-PsqlArgumentList -Target $Target -File $path -Output Scalar
            $result = Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
                $previousPreference = $ErrorActionPreference
                try {
                    $ErrorActionPreference = 'Continue'
                    $messages = (& $psql @arguments 2>&1 | ForEach-Object { $_.ToString() } | Out-String -Width 4096)
                    [pscustomobject]@{ ExitCode=$LASTEXITCODE; Messages=$messages }
                } finally { $ErrorActionPreference=$previousPreference }
            }
            if ($result.ExitCode -eq 0 -or $result.Messages -notlike $test.Expected) {
                throw "Controlled proprietor invalid decision was not rejected: $($result.Messages)"
            }
        }
    } finally { Remove-Item -LiteralPath $path -ErrorAction SilentlyContinue }
    Write-Host '    Reimport retained parties, responsibilities and evidence; missing review and identity conflicts rejected. Test loads rolled back.' -ForegroundColor Green
}

function Test-EstablishmentApproval {
    <#
    .SYNOPSIS
    Compares the complete loaded record for one establishment with its approved
    snapshot in tests/approval.
    .PARAMETER UpdateApproval
    Replaces the approved snapshot with the current result instead of comparing.
    Use only for a reviewed, deliberate change.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][ValidateRange(1, 999999)][int]$Urn,
        [switch]$UpdateApproval
    )

    Write-Step "Test: approval snapshot for URN $Urn"
    $approvalFile = Get-SchemaPath "tests/approval/establishment-$Urn.approved.json"
    if (-not $UpdateApproval) { Assert-FileExists -Path $approvalFile }

    $actual = ConvertTo-ApprovalText (Invoke-Psql -Target $Target -Output 'Csv' `
        -File (Get-SchemaPath 'establishment/transforms/select-establishment-by-urn.sql') `
        -Variables @{ urn = $Urn } -FailureMessage "Approval query failed for URN $Urn")

    if ($UpdateApproval) {
        Set-Content -LiteralPath $approvalFile -Value $actual -Encoding utf8
        Write-Host "    Updated approval snapshot: $approvalFile"
        return
    }

    $expected = ConvertTo-ApprovalText (Get-Content -LiteralPath $approvalFile -Raw)
    if ($actual -cne $expected) {
        Write-Host "    Approval test failed for URN $Urn." -ForegroundColor Red
        Write-Host 'Expected:'
        Write-Host $expected
        Write-Host 'Actual:'
        Write-Host $actual
        throw "Establishment approval test failed for URN $Urn."
    }
    Write-Host "    Approval test passed for URN $Urn." -ForegroundColor Green
}

function Test-EstablishmentScope {
    <#
    .SYNOPSIS
    Checks that the database holds exactly the expected establishments.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][int[]]$ExpectedUrn
    )

    Write-Step 'Test: establishment scope'
    $loaded = Invoke-Psql -Target $Target -Output 'Scalar' -FailureMessage 'Establishment scope query failed' `
        -Command 'SELECT string_agg(urn::text, '','' ORDER BY urn) FROM establishment.establishment;'
    $loadedUrns = @()
    if ($loaded) { $loadedUrns = @($loaded -split ',' | ForEach-Object { [int]$_ }) }
    $expectedUrns = @($ExpectedUrn | Sort-Object)

    $difference = Compare-Object -ReferenceObject $expectedUrns -DifferenceObject $loadedUrns
    if ($difference) {
        throw "Expected establishments $($expectedUrns -join ', '), but the database holds $($loadedUrns -join ', ')."
    }
    Write-Host "    Scope test passed: $($expectedUrns -join ', ')." -ForegroundColor Green
}

function Test-EstablishmentUrnValidation {
    # Exercise selection boundaries and ensure command validation stays aligned.
    Write-Step 'Test: URN validation boundaries'
    $selectionTestPath = [System.IO.Path]::GetTempFileName()
    try {
        foreach ($testUrn in @(1, 20001, 136102, 999999, -1, 0, 1000000)) {
            @{
                organisationType = 'establishment-fixture-set'
                urns = @($testUrn)
                establishmentPartyRoleResponsibilities = @()
            } | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $selectionTestPath -Encoding utf8
            $accepted = $false
            try {
                $null = Get-FixtureSelection -Path $selectionTestPath
                $accepted = $true
            } catch {
                if ($_.Exception.Message -notlike '*outside the valid range*') { throw }
            }
            if ($accepted -ne ($testUrn -ge 1 -and $testUrn -le 999999)) {
                throw "Fixture selection accepted/rejected URN $testUrn incorrectly."
            }
        }
        foreach ($commandName in @('Import-EstablishmentFromBau', 'Import-EstablishmentPartyRoleFromBau', 'Import-GovernanceFromBau', 'Test-EstablishmentApproval')) {
            $range = @((Get-Command $commandName).Parameters['Urn'].Attributes |
                Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] })
            if ($range.Count -ne 1 -or $range[0].MinRange -ne 1 -or $range[0].MaxRange -ne 999999) {
                throw "URN validation is inconsistent on $commandName."
            }
        }
        $approvalScript = Get-SchemaPath 'tests/assert-establishment-approval.ps1'
        $range = @((Get-Command $approvalScript).Parameters['Urn'].Attributes |
            Where-Object { $_ -is [System.Management.Automation.ValidateRangeAttribute] })
        if ($range.Count -ne 1 -or $range[0].MinRange -ne 1 -or $range[0].MaxRange -ne 999999) {
            throw 'URN validation is inconsistent on the standalone approval script.'
        }
        Write-Host '    URN validation boundary tests passed.' -ForegroundColor Green
    } finally {
        Remove-Item -LiteralPath $selectionTestPath -ErrorAction SilentlyContinue
    }
}

function Invoke-EstablishmentTests {
    <#
    .SYNOPSIS
    Runs every establishment test for the fixture selection: URN boundaries,
    core validation, groups validation, one approval snapshot per selected URN,
    and scope.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)]$Selection
    )

    Test-EstablishmentUrnValidation
    Test-EstablishmentCoreValidation -Target $Target
    if ($Selection.PartyRoleLinks.Count -gt 0) {
        Test-EstablishmentGroupsValidation -Target $Target
        if (@($Selection.PartyRoleLinks | Where-Object { $_.Urn -eq 135936 -and $_.SourceGroupId -eq 2613 }).Count -gt 0) {
            Write-Step 'Test: person sponsorship and separate academy-trust operation'
            Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-person-sponsor-responsibilities.sql') -FailureMessage 'Person-sponsor validation failed'
        }
        if (@($Selection.PartyRoleLinks | Where-Object { $_.Urn -eq 132141 -and $_.SourceGroupId -eq 1337 }).Count -gt 0) {
            Write-Step 'Test: foundation-trust support'
            Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-foundation-trust-responsibilities.sql') -FailureMessage 'Foundation-trust validation failed'
        }
    }
    if (@($Selection.ControlledProprietors | Where-Object { $_.fixture -eq 'T9' }).Count -gt 0) {
        Write-Step 'Test: shared proprietor responsibilities and controlled evidence'
        Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-proprietor-responsibilities.sql') -FailureMessage 'Proprietor validation failed'
        Test-ControlledProprietorReimport -Target $Target -Fixture ($Selection.ControlledProprietors | Where-Object { $_.fixture -eq 'T9' })
    }
    if ($Selection.PartyRoleLinks.Count -gt 0 -or $Selection.OrganisationGroups.Count -gt 0 -or $Selection.ControlledProprietors.Count -gt 0) {
        Write-Step 'Test: rebuild migration-evidence grouping'
        if ($Selection.OrganisationGroups.Count -gt 0) {
            Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-federation-memberships.sql') -FailureMessage 'Federation validation failed'
            if (@($Selection.OrganisationGroups | Where-Object { $_.SourceGroupId -eq 86052 }).Count -gt 0) {
                Invoke-Psql -Target $Target -File (Get-SchemaPath 'establishment/validate-childrens-centre-memberships.sql') -FailureMessage 'Childrens-centre validation failed'
            }
        }
        $expectedExtracts = [int]($Selection.PartyRoleLinks.Count + $Selection.OrganisationGroups.Count)
        $expectedRecords = [int]$Selection.PartyRoleLinks.Count
        foreach ($group in $Selection.OrganisationGroups) { $expectedRecords += $group.MemberUrns.Count }
        foreach ($proprietor in $Selection.ControlledProprietors) {
            $expectedExtracts += 2
            $expectedRecords += 2 * @($proprietor.schools).Count
        }
        $runGroupingSql = @'
DO $$
DECLARE
    run_id uuid;
BEGIN
    SELECT migration_run_id INTO STRICT run_id FROM migration.migration_run
    WHERE run_type = 'establishment-rebuild';
    IF NOT EXISTS (SELECT 1 FROM migration.migration_run
                   WHERE migration_run_id = run_id AND status IN ('running', 'completed')) THEN
        RAISE EXCEPTION 'Establishment rebuild run is not running or completed';
    END IF;
    IF (SELECT count(*) FROM migration.source_snapshot WHERE migration_run_id = run_id) <> __EXPECTED_EXTRACTS__
       OR (SELECT count(*) FROM migration.source_record r JOIN migration.source_snapshot s USING (source_snapshot_id)
           WHERE s.migration_run_id = run_id) <> __EXPECTED_RECORDS__ THEN
        RAISE EXCEPTION 'Rebuild evidence must retain the selected extracts and source records';
    END IF;
    IF EXISTS (SELECT 1 FROM migration.source_snapshot s JOIN migration.migration_run r USING (migration_run_id)
               WHERE r.migration_run_id = run_id AND s.source_system='GIAS BAU'
                 AND s.source_database IS DISTINCT FROM r.source_database) THEN
        RAISE EXCEPTION 'Rebuild source database and extract source database disagree';
    END IF;
END $$;
'@
        $null = Invoke-Psql -Target $Target -Command $runGroupingSql.Replace('__EXPECTED_EXTRACTS__', [string]$expectedExtracts).Replace('__EXPECTED_RECORDS__', [string]$expectedRecords) `
            -Output Scalar -FailureMessage 'Migration evidence grouping test failed'
    }
    foreach ($urn in $Selection.Urns) {
        Test-EstablishmentApproval -Target $Target -Urn $urn
    }
    Test-EstablishmentScope -Target $Target -ExpectedUrn $Selection.Urns
    Write-Host 'All establishment tests passed.' -ForegroundColor Green
}
