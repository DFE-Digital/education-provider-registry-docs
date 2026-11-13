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
    $urnSet = [System.Collections.Generic.HashSet[int]]::new()
    foreach ($selectedUrn in $urns) {
        if (-not $urnSet.Add($selectedUrn)) { throw 'The selection must not contain duplicate URNs.' }
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

    if ($null -ne $selection.discoverGroups -and $selection.discoverGroups -isnot [bool]) {
        throw 'discoverGroups must be true or false.'
    }
    $discoverGroups = if ($null -ne $selection.discoverGroups) {
        [bool]$selection.discoverGroups
    }
    else {
        @($links).Count -eq 0 -and @($groups).Count -eq 0
    }
    return [pscustomobject]@{
        PSTypeName     = 'Epr.FixtureSelection'
        Path           = $Path
        Urns           = $urns
        PartyRoleLinks = @($links)
        OrganisationGroups = @($groups)
        DiscoverGroups = $discoverGroups
    }
}

function Get-EstablishmentSelectionFromBau {
    <# .SYNOPSIS
    Selects every establishment in the guarded local BAU source.
    #>
    param([Parameter(Mandatory)]$Source)
    Write-Step 'Reading all establishment URNs from the local BAU source'
    $connection = $null; $command = $null; $reader = $null
    $urns = [System.Collections.Generic.List[int]]::new()
    try {
        $connection = Open-BauConnection -Source $Source
        $command = $connection.CreateCommand()
        $command.CommandText = Get-SqlWithVariables -SqlFile (Get-SchemaPath 'establishment/transforms/establishment-urns-from-bau.sql')
        $reader = $command.ExecuteReader()
        while ($reader.Read()) {
            $urn = [int]$reader.GetValue(0)
            if ($urn -lt 1 -or $urn -gt 999999) { throw "Source URN is outside the valid range: $urn" }
            $urns.Add($urn)
            if ($urns.Count % 10000 -eq 0) { Write-Host "    Read $($urns.Count) source URNs." }
        }
    } finally {
        if ($reader) { $reader.Dispose() }
        if ($command) { $command.Dispose() }
        if ($connection) { $connection.Dispose() }
    }
    if ($urns.Count -eq 0) { throw 'The local BAU source contains no establishments.' }
    return [pscustomobject]@{
        PSTypeName = 'Epr.FixtureSelection'; Path = $null
        Urns = $urns.ToArray(); PartyRoleLinks = @(); OrganisationGroups = @()
        DiscoverGroups = $true
    }
}

function ConvertTo-DiscoveredGroupSelection {
    # Pure mapping, shared with source-free regression tests. Discovery does not
    # allocate identities or expand the URN scope.
    param(
        [Parameter(Mandatory)]$Selection,
        [object[]]$GroupLinks = @(),
        [switch]$IncludeArchivedLinks,
        [switch]$AllowUnmodelledGroups,
        [switch]$SkipClosedGroups
    )
    $links = [System.Collections.Generic.List[object]]::new()
    $groups = @{}
    $seen = @{}
    $unmodelled = @{}
    $closedGroupLinks = 0
    $urnSet = [System.Collections.Generic.HashSet[int]]::new([int[]]$Selection.Urns)
    foreach ($row in $GroupLinks) {
        $urn = [int]$row.establishment_urn
        $groupId = [int]$row.source_group_id
        $archived = [int]$row.source_archived
        $type = [string]$row.group_type_code
        if (-not $urnSet.Contains($urn) -or $groupId -lt 1 -or $groupId -gt 999999999 -or $archived -notin @(0, 1)) {
            throw 'Discovered group link has an invalid key, archive flag or URN outside the supplied selection.'
        }
        if ($type -notin @('01', '02', '05', '06', '08', '10', '11')) {
            if ($AllowUnmodelledGroups) {
                $unmodelled[$type]=1+[int]$unmodelled[$type]
                continue
            }
            throw "Unsupported BAU group type '$type' for URN $urn, group $groupId; review required."
        }
        if ($archived -eq 1 -and (-not $IncludeArchivedLinks -or $type -in @('01', '08'))) { continue }
        if ($SkipClosedGroups -and $type -in @('01','08') -and
            $row.source_group_closed_date -and $row.source_group_closed_date -ne 'NULL') {
            $closedGroupLinks++
            continue
        }
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
            $links.Add([pscustomobject]@{
                Urn = $urn; SourceGroupId = $groupId; Fixture = 'discovered'
                IncludeArchived = ($archived -eq 1)
            })
        }
    }
    return [pscustomobject]@{
        PSTypeName = 'Epr.FixtureSelection'; Path = $Selection.Path
        Urns = @($Selection.Urns)
        PartyRoleLinks = @($links | Sort-Object Urn, SourceGroupId)
        OrganisationGroups = @($groups.Values | Sort-Object SourceGroupId)
        DiscoverGroups = $false
        UnmodelledGroupCounts = $unmodelled
        ClosedGroupLinkCount = $closedGroupLinks
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
        [switch]$IncludeArchivedLinks,
        [switch]$AllSource
    )
    Write-Step 'Discovering BAU groups for the supplied establishment URNs'
    $csvPath = Join-Path $WorkingDirectory 'discovered-establishment-groups.csv'
    $transform=if ($AllSource) { 'establishment/transforms/discover-all-establishment-groups-from-bau.sql' }
        else { 'establishment/transforms/discover-establishment-groups-from-bau.sql' }
    $urnValues = if ($AllSource) { '(0)' } else { ($Selection.Urns | ForEach-Object { '(' + [string][int]$_ + ')' }) -join ',' }
    $null = Export-BauQueryToCsv -Source $Source -CsvPath $csvPath -RowCount Any `
        -SqlFile (Get-SchemaPath $transform) `
        -Variables @{ URN_VALUES = $urnValues; ALL_SOURCE = [int][bool]$AllSource; INCLUDE_ARCHIVED = [int][bool]$IncludeArchivedLinks } `
        -Description 'group discovery for supplied URNs'
    $rows = @(Import-Csv -LiteralPath $csvPath -Delimiter '|')
    # The bulk transform deliberately discovers every eligible source link.
    # Validate that result against its own source scope; callers can then
    # restrict the returned memberships to establishments that loaded.
    if ($AllSource) {
        $Selection=[pscustomobject]@{
            Urns=@($rows | ForEach-Object {[int]$_.establishment_urn} | Sort-Object -Unique)
            Path=$Selection.Path
        }
    }
    $result = ConvertTo-DiscoveredGroupSelection -Selection $Selection -GroupLinks $rows -IncludeArchivedLinks:$IncludeArchivedLinks -AllowUnmodelledGroups:$AllSource -SkipClosedGroups:$AllSource
    if ($result.ClosedGroupLinkCount) {
        Write-Warning "Omitting $($result.ClosedGroupLinkCount) current links to closed organisation groups. Their establishments remain selected."
    }
    if ($result.UnmodelledGroupCounts.Count) {
        $summary=($result.UnmodelledGroupCounts.Keys | Sort-Object | ForEach-Object { "type $_`: $($result.UnmodelledGroupCounts[$_]) links" }) -join '; '
        Write-Warning "Omitting relationships with no target mapping ($summary). Their establishments remain selected."
    }
    Write-Host "    $($result.PartyRoleLinks.Count) party links and $($result.OrganisationGroups.Count) organisation groups discovered; URN scope unchanged."
    return $result
}
