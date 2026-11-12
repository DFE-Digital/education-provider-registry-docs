# Tests that run against a loaded local establishment database. Each test can
# be run on its own; Invoke-EstablishmentTests runs them all.

function Test-EstablishmentCoreValidation {
    <#
    .SYNOPSIS
    Checks that every core establishment table is populated and the keys join up.
    #>
    param([Parameter(Mandatory)]$Target)

    Write-Step 'Test: core establishment validation'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/validate-scripts/validate-establishment-fixture.sql') -FailureMessage 'Core establishment validation failed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/validate-scripts/validate-null-reference-policy.sql') -FailureMessage 'Null reference policy failed'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/validate-scripts/validate-group-address-constraints.sql') -FailureMessage 'Group-address constraints failed'
    Test-SenMigration -Target $Target
    Test-BauReferenceData -Target $Target
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'migration/validate-scripts/validate-reference-identities.sql') -FailureMessage 'Reference identity validation failed'
}

function Test-EstablishmentBuildInputPreflight {
    Write-Step 'Test: missing rebuild input preflight'
    Assert-EstablishmentBuildInputs -IncludeReferenceSeed -FixtureSeedFile @('seed-establishment-fixture.sql')
    $missingInput = Join-Path ([System.IO.Path]::GetTempPath()) ('epr-missing-input-' + [guid]::NewGuid())
    $originalRoot = $script:SchemaRoot
    $rejected = $false
    try {
        $script:SchemaRoot = $missingInput
        try { Assert-EstablishmentBuildInputs }
        catch {
            if ($_.Exception.Message -notlike '*Required file not found:*establishment-schema.sql*') { throw }
            $rejected = $true
        }
    }
    finally { $script:SchemaRoot = $originalRoot }
    if (-not $rejected) { throw 'Missing schema creation input was accepted.' }
    $rejected = $false
    try { Assert-EstablishmentBuildInputs -IncludeReferenceSeed -FixtureSeedFile @($missingInput) }
    catch {
        if ($_.Exception.Message -notlike '*Required file not found:*') { throw }
        $rejected = $true
    }
    if (-not $rejected) { throw 'Missing fixture input was accepted.' }
    Write-Host '    Missing schema/fixture inputs rejected by read-only preflight.'
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

function Test-EstablishmentGroupDiscovery {
    # Source-free regression checks: discovery must never expand the requested
    # URNs or infer identities. Real SQL extraction is checked separately.
    Write-Step 'Test: URN-driven group discovery'
    $selection = Get-FixtureSelection -Urn @(20001, 136102, 123456)
    $rows = @(
        [pscustomobject]@{ establishment_urn=20001; source_group_id=11; group_type_code='08'; source_archived=0; source_group_closed_date='NULL' },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=12; group_type_code='01'; source_archived=0; source_group_closed_date='NULL' },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=13; group_type_code='06'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=14; group_type_code='10'; source_archived=1 },
        [pscustomobject]@{ establishment_urn=123456; source_group_id=13; group_type_code='06'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=15; group_type_code='05'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=123456; source_group_id=16; group_type_code='02'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=123456; source_group_id=17; group_type_code='11'; source_archived=0 }
    )
    $result = ConvertTo-DiscoveredGroupSelection -Selection $selection -GroupLinks $rows
    if ($result.Urns.Count -ne 3 -or (Compare-Object $selection.Urns $result.Urns) -or
        $result.PartyRoleLinks.Count -ne 5 -or $result.OrganisationGroups.Count -ne 2) {
        throw 'Group discovery changed URNs or missed routes.'
    }
    foreach ($group in $result.OrganisationGroups) {
        if (-not $group.SelectedMembersOnly -or $group.MemberUrns.Count -ne 1 -or
            @($group.MemberUrns | Where-Object { $_ -notin $selection.Urns }).Count -gt 0) {
            throw 'Discovered organisation memberships must be restricted to supplied URNs.'
        }
    }
    $historical = ConvertTo-DiscoveredGroupSelection -Selection $selection -GroupLinks $rows -IncludeArchivedLinks
    if ($historical.PartyRoleLinks.Count -ne 6 -or
        @($historical.PartyRoleLinks | Where-Object { $_.SourceGroupId -eq 14 -and $_.IncludeArchived }).Count -ne 1) {
        throw 'Archived party-link opt-in failed.'
    }
    $empty = ConvertTo-DiscoveredGroupSelection -Selection $selection
    if ($empty.Urns.Count -ne 3 -or $empty.PartyRoleLinks.Count -ne 0 -or $empty.OrganisationGroups.Count -ne 0) {
        throw 'A URN with no group links must still be selectable.'
    }
    $rejectedRows = @(
        [pscustomobject]@{ establishment_urn=999999; source_group_id=1; group_type_code='06'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=1; group_type_code='03'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=1; group_type_code='01'; source_archived=0; source_group_closed_date='2020-01-01' },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=0; group_type_code='06'; source_archived=0 },
        [pscustomobject]@{ establishment_urn=136102; source_group_id=1; group_type_code='06'; source_archived=2 }
    )
    foreach ($row in $rejectedRows) {
        $rejected = $false
        try { $null = ConvertTo-DiscoveredGroupSelection -Selection $selection -GroupLinks @($row) } catch { $rejected = $true }
        if (-not $rejected) { throw 'An invalid or unsupported discovered link was accepted.' }
    }
    $duplicateRejected = $false
    try { $null = ConvertTo-DiscoveredGroupSelection -Selection $selection -GroupLinks @($rows[0], $rows[0]) }
    catch { $duplicateRejected = $true }
    if (-not $duplicateRejected) { throw 'Duplicate discovered source links were accepted.' }
    Write-Host '    Discovery routes, selected-only scope, archive policy and rejection checks passed.'
}

function Test-EstablishmentMigrationEvidence {
    <#
    .SYNOPSIS
    Checks that the rebuild's migration run retains one extract and the source
    records for every selected group link and organisation group.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)]$Selection
    )

    Write-Step 'Test: rebuild migration-evidence grouping'
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
               WHERE r.migration_run_id = run_id AND s.source_system='GIAS BAU'
                 AND s.source_database IS DISTINCT FROM r.source_database) THEN
        RAISE EXCEPTION 'Rebuild source database and extract source database disagree';
    END IF;
END $$;
'@
    $null = Invoke-Psql -Target $Target -Command $runGroupingSql.Replace('__EXPECTED_EXTRACTS__', [string]$expectedExtracts).Replace('__EXPECTED_RECORDS__', [string]$expectedRecords) `
        -Output Scalar -FailureMessage 'Migration evidence grouping test failed'
}

function Invoke-EstablishmentTests {
    <#
    .SYNOPSIS
    Runs every establishment test: build inputs, URN boundaries, group
    discovery, core validation, migration evidence for any selected group
    links, one approval snapshot per selected URN, and scope.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)]$Selection
    )

    Test-EstablishmentBuildInputPreflight
    Test-EstablishmentUrnValidation
    Test-EstablishmentGroupDiscovery
    Test-EstablishmentCoreValidation -Target $Target
    if ($Selection.PartyRoleLinks.Count -gt 0 -or $Selection.OrganisationGroups.Count -gt 0) {
        Test-EstablishmentMigrationEvidence -Target $Target -Selection $Selection
    }
    foreach ($urn in $Selection.Urns) {
        Test-EstablishmentApproval -Target $Target -Urn $urn
    }
    Test-EstablishmentScope -Target $Target -ExpectedUrn $Selection.Urns
    Write-Host 'All establishment tests passed.' -ForegroundColor Green
}
