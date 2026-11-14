function Read-KnownBadEstablishments {
    param([Parameter(Mandatory)][string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $parsed=Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    foreach ($entry in $parsed) {if ($null -ne $entry) {$entry}}
}

function Save-KnownBadEstablishments {
    param([Parameter(Mandatory)][string]$Path,[object[]]$Entries=@())
    $byKey=@{}
    foreach ($entry in $Entries) {
        $urn=[int]$entry.urn
        if ($urn -lt 1 -or $urn -gt 999999) {throw "Invalid URN in known-bad list: $urn"}
        $byKey["$($entry.source_database)/$urn"]=$entry
    }
    $json=ConvertTo-Json -InputObject @($byKey.Values | Sort-Object source_database,{[int]$_.urn}) -Depth 5
    $temporary=$Path+'.'+[guid]::NewGuid().ToString('N')+'.tmp'
    try {
        [IO.File]::WriteAllText($temporary,$json+[Environment]::NewLine,[Text.UTF8Encoding]::new($false))
        Move-Item -LiteralPath $temporary -Destination $Path -Force
    } finally {
        if (Test-Path -LiteralPath $temporary) {Remove-Item -LiteralPath $temporary -Force}
    }
}
