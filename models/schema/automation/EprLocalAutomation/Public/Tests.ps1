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
        [Parameter(Mandatory)][ValidateRange(100000, 999999)][int]$Urn,
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
    Write-Host "    🙂 Approval test passed for URN $Urn." -ForegroundColor Green
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

function Invoke-EstablishmentTests {
    <#
    .SYNOPSIS
    Runs every establishment test for the fixture selection: core validation,
    groups validation, one approval snapshot per selected URN, and scope.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)]$Selection
    )

    Test-EstablishmentCoreValidation -Target $Target
    if ($Selection.PartyRoleLinks.Count -gt 0) {
        Test-EstablishmentGroupsValidation -Target $Target
    }
    foreach ($urn in $Selection.Urns) {
        Test-EstablishmentApproval -Target $Target -Urn $urn
    }
    Test-EstablishmentScope -Target $Target -ExpectedUrn $Selection.Urns
    Write-Host 'All establishment tests passed.' -ForegroundColor Green
}
