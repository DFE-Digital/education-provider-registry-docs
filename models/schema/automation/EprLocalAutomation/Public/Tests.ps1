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
    $null = Invoke-Psql -Target $Target -Command $successSql -Output Scalar -FailureMessage 'Repeated source UID test failed'

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
    foreach ($collisionCase in $collisionCases) {
        $collisionSql = [regex]::Replace($loader, '(?m)^\\copy[^\r\n]*', $collisionCase.Insert)
        $collisionSql = [regex]::Replace($collisionSql, '(?m)^COMMIT;', 'ROLLBACK;')
        $psql = Get-PostgresClientPath -Tool psql
        $arguments = Get-PsqlArgumentList -Target $Target -Command $collisionSql -Output Scalar
        $result = Invoke-WithPostgresPassword -Target $Target -ScriptBlock {
            $preferenceBefore = $ErrorActionPreference
            try {
                $ErrorActionPreference = 'Continue'
                $messages = (& $psql @arguments 2>&1 | Out-String)
                [pscustomobject]@{ ExitCode = $LASTEXITCODE; Messages = $messages }
            } finally { $ErrorActionPreference = $preferenceBefore }
        }
        if ($result.ExitCode -eq 0 -or $result.Messages -notlike $collisionCase.Expected) {
            throw "Identity collision was not rejected as expected: $($result.Messages)"
        }
    }
    Write-Host '    Existing source UID retained; name-only and conflicting-identifier collisions rejected. Test loads rolled back.' -ForegroundColor Green
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
    }
    if ($Selection.PartyRoleLinks.Count -gt 0 -or $Selection.OrganisationGroups.Count -gt 0) {
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
               WHERE r.migration_run_id = run_id AND s.source_database IS DISTINCT FROM r.source_database) THEN
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
