# URN scope for the checked-in fixture or a selected development extract.

function Get-FixtureSelection {
    <#
    .SYNOPSIS
    Reads and validates a fixture selection file, or validates direct URNs.
    .OUTPUTS
    An object containing the validated URNs and optional manifest path.
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

    return [pscustomobject]@{
        PSTypeName = 'Epr.FixtureSelection'
        Path = $Path
        Urns = $urns
    }
}
