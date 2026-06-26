param(
    [string]$CoveragePath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "models" "provider-field-coverage.ttl")),
    [string]$OutputRoot   = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" "ui-coverage"))
)

$ErrorActionPreference = "Stop"

$resolvedCoveragePath = Resolve-Path -LiteralPath $CoveragePath
$resolvedOutputRoot   = New-Item -ItemType Directory -Force -Path $OutputRoot
$ttl = Get-Content -LiteralPath $resolvedCoveragePath -Raw

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

function Get-PredicateText {
    param([string]$Block, [string]$Predicate)
    $escapedPredicate = [regex]::Escape($Predicate)
    $pattern = "(?ms)$escapedPredicate\s+((?:""(?:[^""\\]|\\.)*""(?:@[a-zA-Z-]+|\^\^\S+)?|[^;"".\r\n]+)+)\s*(?:;|\.)"
    $match = [regex]::Match($Block, $pattern)
    if ($match.Success) { return $match.Groups[1].Value.Trim() }
    return ""
}

function Get-FirstLiteral {
    param([string]$Block, [string]$Predicate)
    $text = Get-PredicateText -Block $Block -Predicate $Predicate
    if ([string]::IsNullOrWhiteSpace($text)) { return "" }
    $m = [regex]::Match($text, '"((?:[^"\\]|\\.)*)"(?:@[a-zA-Z-]+|\^\^\S+)?')
    if ($m.Success) { return $m.Groups[1].Value }
    return ""
}

function Get-AllLiterals {
    param([string]$Block, [string]$Predicate)
    $text = Get-PredicateText -Block $Block -Predicate $Predicate
    if ([string]::IsNullOrWhiteSpace($text)) { return @() }
    return [regex]::Matches($text, '"((?:[^"\\]|\\.)*)"(?:@[a-zA-Z-]+|\^\^\S+)?') |
        ForEach-Object { $_.Groups[1].Value }
}

function Get-TabRef {
    param([string]$Block)
    $text = Get-PredicateText -Block $Block -Predicate "epr:shownOnTab"
    $m = [regex]::Match($text, 'epr:(\w+Tab)')
    if ($m.Success) { return $m.Groups[1].Value }
    return ""
}

function Escape-Md {
    param([string]$v)
    return $v -replace '\|', '\|'
}

# ---------------------------------------------------------------------------
# Parse all coverage blocks from the TTL
# Each block: epr:LocalName\n    epr:shownOnTab ...\n    epr:uiLabel ...\n    epr:applicableToEstablishmentType ...
# ---------------------------------------------------------------------------

$blockPattern = "(?ms)^epr:([A-Za-z][A-Za-z0-9]*)\s*\r?\n\s+epr:shownOnTab\s+epr:\w+Tab\s*[;.](.*?)(?=^epr:|\z)"
$blockMatches = [regex]::Matches($ttl, $blockPattern)

$allFields = foreach ($m in $blockMatches) {
    $localName = $m.Groups[1].Value
    # Reconstruct the full block text including the first predicate line
    $block = "epr:shownOnTab epr:" + [regex]::Match($ttl.Substring($m.Index), 'epr:(\w+Tab)').Groups[1].Value + " ;" + $m.Groups[2].Value

    $tab   = Get-TabRef -Block $block
    $label = Get-FirstLiteral -Block $block -Predicate "epr:uiLabel"
    $types = @(Get-AllLiterals -Block $block -Predicate "epr:applicableToEstablishmentType")

    if ($tab -and $label) {
        [pscustomobject]@{
            LocalName = $localName
            Tab       = $tab
            Label     = $label
            Types     = $types
        }
    }
}

if ($allFields.Count -eq 0) {
    throw "No coverage blocks found in $resolvedCoveragePath"
}

# ---------------------------------------------------------------------------
# Canonical type list — ordered by code
# ---------------------------------------------------------------------------

$typeMeta = [ordered]@{
    "01" = "Community school"
    "02" = "Voluntary aided school"
    "03" = "Voluntary controlled school"
    "05" = "Foundation school"
    "06" = "City technology college"
    "07" = "Community special school"
    "08" = "Non-maintained special school"
    "10" = "Other independent special school"
    "11" = "Other independent school"
    "12" = "Foundation special school"
    "14" = "Pupil referral unit"
    "15" = "Local authority nursery school"
    "18" = "Further education"
    "24" = "Secure units"
    "25" = "Offshore schools"
    "26" = "Service children's education"
    "27" = "Miscellaneous"
    "28" = "Academy sponsor led"
    "29" = "Higher education institutions"
    "30" = "Welsh establishment"
    "31" = "Sixth form centres"
    "32" = "Special post 16 institution"
    "33" = "Academy special sponsor led"
    "34" = "Academy converter"
    "35" = "Free schools"
    "36" = "Free schools special"
    "37" = "British schools overseas"
    "38" = "Free schools alternative provision"
    "39" = "Free schools 16 to 19"
    "40" = "University technical college"
    "41" = "Studio schools"
    "42" = "Academy AP converter"
    "43" = "Academy AP sponsor led"
    "44" = "Academy special converter"
    "45" = "Academy 16-19 converter"
    "46" = "Academy 16 to 19 sponsor led"
    "47" = "Children's centre"
    "48" = "Children's centre linked site"
    "49" = "Online provider"
    "56" = "Institution funded by OGD"
    "57" = "Academy secure 16 to 19"
}

$allCodes = @($typeMeta.Keys)

# ---------------------------------------------------------------------------
# Tab metadata
# ---------------------------------------------------------------------------

$tabs = [ordered]@{
    "detailsTab"    = @{ Title = "Details tab"; Slug = "details";    Heading = "Establishments — Details tab field coverage" }
    "locationTab"   = @{ Title = "Location tab"; Slug = "location";  Heading = "Location tab field coverage" }
    "governanceTab" = @{ Title = "Governance tab"; Slug = "governance"; Heading = "Governance tab field coverage" }

}

$sourceTtl = "https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/provider-field-coverage.ttl"

# ---------------------------------------------------------------------------
# Generate one page per tab
# ---------------------------------------------------------------------------

foreach ($tabKey in $tabs.Keys) {
    $tabInfo  = $tabs[$tabKey]
    $fields   = @($allFields | Where-Object { $_.Tab -eq $tabKey } | Sort-Object Label)

    if ($fields.Count -eq 0) {
        Write-Warning "No fields found for tab '$tabKey'"
        continue
    }

    # Build type set for this tab (union of all types across all fields on this tab)
    $tabTypeCodes = @($allCodes | Where-Object { $code = $_; $fields | Where-Object { $_.Types -contains $code } })

    $lines = @(
        "# $($tabInfo.Heading)",
        "",
        "This page is generated from ``models/provider-field-coverage.ttl`` — do not edit directly.",
        "",
        "Source: <$sourceTtl>",
        "",
        "Each section lists the fields visible on this tab for that establishment type.",
        "",
        "---",
        ""
    )

    foreach ($code in $tabTypeCodes) {
        $typeLabel  = $typeMeta[$code]
        $applicable = @($fields | Where-Object { $_.Types -contains $code })

        $lines += "## $typeLabel (type $code)"
        $lines += ""
        if ($applicable.Count -gt 0) {
            $lines += "| Field | ``epr:`` concept |"
            $lines += "| --- | --- |"
            foreach ($field in $applicable) {
                $lines += "| $(Escape-Md $field.Label) | ``epr:$($field.LocalName)`` |"
            }
        }
        else {
            $lines += "_No fields on this tab for this establishment type._"
        }
        $lines += ""
    }

    $lines += @(
        "---",
        "",
        "## Notes",
        "",
        "- Evidence source: observed GIAS public page rendering, June 2026.",
        "  One representative establishment per type. Closed establishments may",
        "  render fewer fields than open establishments of the same type.",
        "- Types 09, 17, 22, 23 and 98 are not included: no sample establishments",
        "  were available in the June 2026 extracts.",
        "- The model source file is ``models/provider-field-coverage.ttl``.",
        "  Update that file and re-run this script to regenerate this page.",
        "",
        "[Back to UI coverage index](../)"
    )

    $outPath = Join-Path $resolvedOutputRoot "$($tabInfo.Slug).md"
    Set-Content -LiteralPath $outPath -Value $lines -Encoding UTF8
    Write-Host "Generated $outPath ($($fields.Count) fields, $($tabTypeCodes.Count) types)"
}

# ---------------------------------------------------------------------------
# Generate index page
# ---------------------------------------------------------------------------

$indexLines = @(
    "# UI field coverage",
    "",
    "These pages show which GIAS UI fields are visible for each establishment type on each tab.",
    "They are generated from ``models/provider-field-coverage.ttl``, which is the single source of truth.",
    "",
    "| Tab | Fields modelled |",
    "| --- | ---: |"
)

foreach ($tabKey in $tabs.Keys) {
    $tabInfo = $tabs[$tabKey]
    $count   = ($allFields | Where-Object { $_.Tab -eq $tabKey }).Count
    $indexLines += "| [$($tabInfo.Title)](./$($tabInfo.Slug)/) | $count |"
}

$indexLines += @(
    "",
    "Source TTL: <$sourceTtl>"
)

Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "index.md") -Value $indexLines -Encoding UTF8
Write-Host "Generated index page"
Write-Host "Done. $($allFields.Count) field entries across $($tabs.Count) tabs."
