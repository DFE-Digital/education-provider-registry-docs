# Database validation and separately invoked tooling regression checks.

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
        foreach ($testUrn in @(-1,0,1000000)) {
            $rejected=$false
            try { Import-DevelopmentEstablishmentSeed -Source @{} -Target @{} -WorkingDirectory ([IO.Path]::GetTempPath()) -Urn $testUrn }
            catch {
                if ($_.Exception.Message -notlike '*outside the valid range*') {throw}
                $rejected=$true
            }
            if (-not $rejected) {throw 'Development seed accepted an invalid URN.'}
        }
        Write-Host '    URN validation boundary tests passed.' -ForegroundColor Green
    } finally {
        Remove-Item -LiteralPath $selectionTestPath -ErrorAction SilentlyContinue
    }
}



function Invoke-EstablishmentToolingTests {
    <#
    .SYNOPSIS
    Runs tooling regression checks without connecting to either database.
    #>
    Test-EstablishmentBuildInputPreflight
    Test-EstablishmentUrnValidation
    Write-Host 'All establishment tooling tests passed.' -ForegroundColor Green
}

function Invoke-EstablishmentTests {
    <#
    .SYNOPSIS
    Validates the loaded database: core validation, one approval snapshot per
    selected URN, and scope.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)]$Selection,
        [int[]]$ApprovalUrn = $Selection.Urns
    )

    Test-EstablishmentCoreValidation -Target $Target
    foreach ($urn in $ApprovalUrn) {
        Test-EstablishmentApproval -Target $Target -Urn $urn
    }
    Test-EstablishmentScope -Target $Target -ExpectedUrn $Selection.Urns
    Write-Host 'All establishment tests passed.' -ForegroundColor Green
}
