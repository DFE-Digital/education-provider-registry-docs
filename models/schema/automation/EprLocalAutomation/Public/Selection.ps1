# The fixture selection: which establishments and establishment-party links
# the local build contains. It is read from seed/fixture-selection.json.

function Get-FixtureSelection {
    <#
    .SYNOPSIS
    Reads and validates the fixture selection file.
    .OUTPUTS
    An object with Urns (the selected establishments) and PartyRoleLinks (the
    BAU group links to migrate as establishment-party roles and responsibilities).
    #>
    param([string]$Path = (Get-SchemaPath 'seed/fixture-selection.json'))

    Assert-FileExists -Path $Path
    $selection = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json

    if ($selection.organisationType -ne 'establishment-fixture-set') {
        throw "The selection must have organisationType 'establishment-fixture-set': $Path"
    }

    $urns = @($selection.urns | ForEach-Object {
        try { [int]$_ } catch { throw "Every selected URN must be an integer. Received: $_" }
    })
    if ($urns.Count -eq 0) { throw 'The selection must contain at least one URN.' }
    if (@($urns | Select-Object -Unique).Count -ne $urns.Count) { throw 'The selection must not contain duplicate URNs.' }
    foreach ($urn in $urns) {
        if ($urn -lt 100000 -or $urn -gt 999999) { throw "The selected URN is outside the valid range: $urn" }
    }

    $links = foreach ($link in @($selection.establishmentPartyRoleResponsibilities)) {
        if ($null -eq $link) { continue }
        $linkUrn = [int]$link.urn
        $sourceGroupId = [int]$link.sourceGroupId
        if ($linkUrn -notin $urns) { throw "Establishment-party link URN must also be in urns: $linkUrn" }
        if ($sourceGroupId -lt 1) { throw "Establishment-party link source group ID must be positive: $sourceGroupId" }
        if ($null -ne $link.includeArchived -and $link.includeArchived -isnot [bool]) {
            throw "includeArchived must be true or false for source group $sourceGroupId"
        }
        [pscustomobject]@{
            Urn             = $linkUrn
            SourceGroupId   = $sourceGroupId
            Fixture         = [string]$link.fixture
            IncludeArchived = [bool]$link.includeArchived
        }
    }

    return [pscustomobject]@{
        PSTypeName     = 'Epr.FixtureSelection'
        Path           = $Path
        Urns           = $urns
        PartyRoleLinks = @($links)
    }
}
