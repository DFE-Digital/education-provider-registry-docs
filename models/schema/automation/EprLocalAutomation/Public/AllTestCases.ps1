function Get-AllTestCases {
    $catalogue = Get-Content (Get-SchemaPath 'seed/all-test-cases.json') -Raw -Encoding UTF8 | ConvertFrom-Json
    $cases = @($catalogue.cases)
    if ($cases.Count -ne 22 -or @($cases.case | Select-Object -Unique).Count -ne 22) {
        throw 'The active catalogue must contain 22 distinct test cases.'
    }
    foreach ($case in $cases) {
        if (@($case.urns).Count -eq 0) { throw "Case $($case.case) has no establishments." }
        foreach ($urn in $case.urns) {
            if ([int]$urn -lt 1 -or [int]$urn -gt 999999) { throw 'Invalid catalogue URN.' }
        }
        if ($case.runner) { Assert-FileExists (Get-SchemaPath "automation/$($case.runner)") }
        if ($case.validator) { Assert-FileExists (Get-SchemaPath "establishment/$($case.validator)") }
    }
    $baseUrns = (Get-FixtureSelection).Urns
    $declaredUrns = @($cases | ForEach-Object { $_.urns } | Sort-Object -Unique)
    if ($declaredUrns.Count -ne 41) { throw 'The active catalogue must cover 41 distinct establishments.' }
    foreach ($urn in $baseUrns) {
        if ($urn -notin $declaredUrns) { throw "Base fixture URN $urn is absent from the full catalogue." }
    }
    return $cases
}

function Test-AllEstablishmentCases {
    param([Parameter(Mandatory)]$Target)
    $cases = @(Get-AllTestCases)
    $urns = @($cases | ForEach-Object { $_.urns } | Sort-Object -Unique)
    Invoke-EstablishmentTests -Target $Target -Selection (Get-FixtureSelection) -ExpectedUrn $urns
    foreach ($case in $cases) {
        if ($case.validator) {
            Write-Step "Validating full catalogue case $($case.case)"
            Invoke-Psql -Target $Target -File (Get-SchemaPath "establishment/$($case.validator)") -FailureMessage "Case $($case.case) validation failed"
        }
    }
    Write-Host "All $($cases.Count) active cases validated across $($urns.Count) establishments." -ForegroundColor Green
}
