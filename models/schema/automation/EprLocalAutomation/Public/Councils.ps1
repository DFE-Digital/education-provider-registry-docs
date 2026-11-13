function Assert-LocalAuthorityCouncilSeed {
    $jsonPath = Get-SchemaPath 'seed/local-authority-area-councils.json'
    $templatePath = Get-SchemaPath 'establishment/load/load-local-authority-area-councils.sql'
    $seedPath = Get-SchemaPath 'seed/seed-local-authority-area-councils.sql'
    Assert-FileExists -Path @($jsonPath,$templatePath,$seedPath)
    $json = [IO.File]::ReadAllText($jsonPath)
    $hash = (Get-FileHash -LiteralPath $jsonPath -Algorithm SHA256).Hash.ToLowerInvariant()
    $expected = [IO.File]::ReadAllText($templatePath).Replace('__MAPPING_SHA256__',$hash).Replace('__MAPPING_JSON__',$json.Replace("'","''"))
    if ([IO.File]::ReadAllText($seedPath) -cne $expected) {
        throw 'Council seed differs from its mapping/template. Review changes and regenerate seed/seed-local-authority-area-councils.sql from the mapping JSON and SQL template.'
    }
}

function Assert-CouncilEventResetAllowed {
    param([Parameter(Mandatory)]$Target)
    Invoke-Psql -Target $Target -Command @'
DO $$ BEGIN
    IF to_regclass('migration.council_reorganisation') IS NOT NULL THEN
        IF EXISTS(SELECT 1 FROM migration.council_reorganisation) THEN
            RAISE EXCEPTION 'Council event ledger is present. Export it and use additive source replay; destructive rebuild would erase reviewed history.';
        END IF;
    END IF;
END $$;
'@ -FailureMessage 'Reviewed council history prevents destructive reset'
}

function Import-LocalAuthorityCouncilFixture {
    param([Parameter(Mandatory)]$Target)
    Assert-LocalAuthorityCouncilSeed
    Write-Step 'Loading evidence-checked council identities and area periods'
    Invoke-Psql -Target $Target -File (Get-SchemaPath 'seed/seed-local-authority-area-councils.sql') -FailureMessage 'Council mapping import failed'
}
