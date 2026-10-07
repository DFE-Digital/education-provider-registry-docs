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
        if ($urn -lt 1 -or $urn -gt 999999) { throw "The selected URN is outside the valid range: $urn" }
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

    $groups = foreach ($group in @($selection.organisationGroups)) {
        if ($null -eq $group) { continue }
        $groupId = [int]$group.sourceGroupId
        $members = @($group.memberUrns | ForEach-Object { [int]$_ })
        if ($groupId -lt 1) { throw 'Organisation-group source ID must be positive.' }
        if ($members.Count -lt 1 -or @($members | Select-Object -Unique).Count -ne $members.Count) {
            throw "Organisation group $groupId must select distinct members."
        }
        foreach ($member in $members) {
            if ($member -notin $urns) { throw "Organisation-group member URN must also be in urns: $member" }
        }
        [pscustomobject]@{ SourceGroupId = $groupId; MemberUrns = $members; Fixture = [string]$group.fixture }
    }
    if (@($groups).Count -gt 0 -and @($groups).Count -ne @($groups.SourceGroupId | Select-Object -Unique).Count) {
        throw 'Organisation groups must not contain duplicate source IDs.'
    }

    $proprietors = foreach ($proprietor in @($selection.controlledProprietors)) {
        if ($null -eq $proprietor) { continue }
        $partyId = [guid]$proprietor.legalEntityId
        if ($partyId -eq [guid]::Empty -or [string]::IsNullOrWhiteSpace($proprietor.name) -or
            [string]::IsNullOrWhiteSpace($proprietor.reviewEvidence)) {
            throw 'Controlled proprietors require an explicit party ID, name and reviewed identity decision.'
        }
        if ([string]$proprietor.snapshotDate -notmatch '^\d{4}-\d{2}-\d{2}$') { throw 'Controlled proprietor snapshot date must be ISO formatted.' }
        $null = [datetime]::ParseExact($proprietor.snapshotDate, 'yyyy-MM-dd', [cultureinfo]::InvariantCulture)
        if ([string]::IsNullOrWhiteSpace($proprietor.fixture) -or [string]::IsNullOrWhiteSpace($proprietor.extractPath)) {
            throw 'Controlled proprietor fixture and extract path are required.'
        }
        $schools = @($proprietor.schools)
        if ($schools.Count -lt 1 -or @($schools.urn | Select-Object -Unique).Count -ne $schools.Count) {
            throw 'Controlled proprietor schools must be non-empty and distinct.'
        }
        foreach ($school in $schools) {
            if ([int]$school.urn -notin $urns -or [string]::IsNullOrWhiteSpace($school.name) -or
                [string]::IsNullOrWhiteSpace($school.propsName)) { throw 'Controlled proprietor schools require selected URNs, names and exact extract assertions.' }
        }
        $proprietor
    }
    if (@($proprietors).Count -ne @($proprietors.legalEntityId | Select-Object -Unique).Count) {
        throw 'Controlled proprietor party IDs must be distinct.'
    }
    return [pscustomobject]@{
        PSTypeName     = 'Epr.FixtureSelection'
        Path           = $Path
        Urns           = $urns
        PartyRoleLinks = @($links)
        OrganisationGroups = @($groups)
        ControlledProprietors = @($proprietors)
    }
}
