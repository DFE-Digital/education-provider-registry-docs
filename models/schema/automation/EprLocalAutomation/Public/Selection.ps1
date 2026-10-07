# The fixture selection: which establishments and establishment-party links
# the local build contains. It is read from seed/fixture-selection.json.

function Get-FixtureSelection {
    <#
    .SYNOPSIS
    Reads and validates a fixture selection file, or validates direct URNs.
    Selections without explicit groups request automatic group discovery.
    .OUTPUTS
    An object with Urns (the selected establishments) and PartyRoleLinks (the
    BAU group links to migrate as establishment-party roles and responsibilities).
    #>
    [CmdletBinding(DefaultParameterSetName = 'File')]
    param(
        [Parameter(ParameterSetName = 'File')][string]$Path = (Get-SchemaPath 'seed/fixture-selection.json'),
        [Parameter(Mandatory, ParameterSetName = 'Urns')]
        [ValidateNotNullOrEmpty()][ValidateRange(1, 999999)][int[]]$Urn
    )

    if ($PSCmdlet.ParameterSetName -eq 'Urns') {
        $Path = $null
        $selection = [pscustomobject]@{ organisationType = 'establishment-fixture-set'; urns = $Urn }
    }
    else {
        Assert-FileExists -Path $Path
        $selection = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    }

    if ($selection.organisationType -ne 'establishment-fixture-set') {
        throw "The selection must have organisationType 'establishment-fixture-set': $Path"
    }

    $urns = @($selection.urns | ForEach-Object {
        try { [int]$_ } catch { throw "Every selected URN must be an integer. Received: $_" }
    })
    if ($urns.Count -eq 0) { throw 'The selection must contain at least one URN.' }
    if (@($urns | Select-Object -Unique).Count -ne $urns.Count) { throw 'The selection must not contain duplicate URNs.' }
    foreach ($selectedUrn in $urns) {
        if ($selectedUrn -lt 1 -or $selectedUrn -gt 999999) { throw "The selected URN is outside the valid range: $selectedUrn" }
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
        DiscoverGroups = (@($links).Count -eq 0 -and @($groups).Count -eq 0)
    }
}

function ConvertTo-DiscoveredGroupSelection {
    # Pure mapping, shared with source-free regression tests. Discovery does not
    # allocate identities, invent proprietor mappings or expand the URN scope.
    param(
        [Parameter(Mandatory)]$Selection,
        [object[]]$GroupLinks = @(),
        [switch]$IncludeArchivedLinks
    )
    $links = @()
    $groups = @{}
    $seen = @{}
    foreach ($row in $GroupLinks) {
        $urn = [int]$row.establishment_urn
        $groupId = [int]$row.source_group_id
        $archived = [int]$row.source_archived
        $type = [string]$row.group_type_code
        if ($urn -notin $Selection.Urns -or $groupId -lt 1 -or $groupId -gt 999999999 -or $archived -notin @(0, 1)) {
            throw 'Discovered group link has an invalid key, archive flag or URN outside the supplied selection.'
        }
        if ($type -notin @('01', '02', '05', '06', '08', '10', '11')) {
            throw "Unsupported BAU group type '$type' for URN $urn, group $groupId; review required."
        }
        if ($archived -eq 1 -and (-not $IncludeArchivedLinks -or $type -in @('01', '08'))) { continue }
        $key = "$urn/$groupId"
        if ($seen.ContainsKey($key)) { throw "Multiple source links for URN $urn and group $groupId; review required." }
        $seen[$key] = $true
        if ($type -in @('01', '08')) {
            if ($row.source_group_closed_date -and $row.source_group_closed_date -ne 'NULL') {
                throw "Closed organisation group $groupId has a current link; review required."
            }
            if (-not $groups.ContainsKey($groupId)) {
                $groups[$groupId] = [pscustomobject]@{
                    SourceGroupId = $groupId; MemberUrns = @(); Fixture = 'discovered'
                    SelectedMembersOnly = $true
                }
            }
            $groups[$groupId].MemberUrns += $urn
        }
        else {
            $links += [pscustomobject]@{
                Urn = $urn; SourceGroupId = $groupId; Fixture = 'discovered'
                IncludeArchived = ($archived -eq 1)
            }
        }
    }
    return [pscustomobject]@{
        PSTypeName = 'Epr.FixtureSelection'; Path = $Selection.Path
        Urns = @($Selection.Urns)
        PartyRoleLinks = @($links | Sort-Object Urn, SourceGroupId)
        OrganisationGroups = @($groups.Values | Sort-Object SourceGroupId)
        ControlledProprietors = @($Selection.ControlledProprietors)
        DiscoverGroups = $false
    }
}

function Find-EstablishmentGroupsFromBau {
    <#
    .SYNOPSIS
    Discovers current group relationships for supplied URNs. Optionally includes
    archived party responsibilities, but not historical organisation memberships.
    Never adds establishments outside the selection.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)]$Selection,
        [Parameter(Mandatory)][string]$WorkingDirectory,
        [switch]$IncludeArchivedLinks
    )
    Write-Step 'Discovering BAU groups for the supplied establishment URNs'
    $csvPath = Join-Path $WorkingDirectory 'discovered-establishment-groups.csv'
    $urnValues = ($Selection.Urns | ForEach-Object { '(' + [string][int]$_ + ')' }) -join ','
    $null = Export-BauQueryToCsv -Source $Source -CsvPath $csvPath -RowCount Any `
        -SqlFile (Get-SchemaPath 'establishment/transforms/discover-establishment-groups-from-bau.sql') `
        -Variables @{ URN_VALUES = $urnValues; INCLUDE_ARCHIVED = [int][bool]$IncludeArchivedLinks } `
        -Description 'group discovery for supplied URNs'
    $rows = @(Import-Csv -LiteralPath $csvPath -Delimiter '|')
    $result = ConvertTo-DiscoveredGroupSelection -Selection $Selection -GroupLinks $rows -IncludeArchivedLinks:$IncludeArchivedLinks
    Write-Host "    $($result.PartyRoleLinks.Count) party links and $($result.OrganisationGroups.Count) organisation groups discovered; URN scope unchanged."
    return $result
}
