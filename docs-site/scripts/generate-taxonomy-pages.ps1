param(
    [string]$TaxonomyPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "models" "education-provider-taxonomy.ttl")),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" "taxonomy"))
)

$ErrorActionPreference = "Stop"

$resolvedTaxonomyPath = Resolve-Path -LiteralPath $TaxonomyPath
$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot
$ttl = Get-Content -LiteralPath $resolvedTaxonomyPath -Raw

function Get-PredicateText {
    param(
        [string]$Block,
        [string]$Predicate
    )

    $escapedPredicate = [regex]::Escape($Predicate)
    $pattern = "(?ms)$escapedPredicate" + '\s+((?:"(?:[^"\\]|\\.)*"(?:@[a-zA-Z-]+|\^\^\S+)?|[^;".]+)+)\s*(?:;|\.\s*(?:\r?\n|$))'
    $match = [regex]::Match($Block, $pattern)
    if ($match.Success) {
        return $match.Groups[1].Value.Trim()
    }

    return ""
}

function Get-Literals {
    param(
        [string]$Block,
        [string]$Predicate
    )

    $predicateText = Get-PredicateText -Block $Block -Predicate $Predicate
    if ([string]::IsNullOrWhiteSpace($predicateText)) {
        return @()
    }

    return [regex]::Matches($predicateText, '"((?:[^"\\]|\\.)*)"(?:@en|\^\^xsd:[A-Za-z]+)?') |
        ForEach-Object {
            $_.Groups[1].Value.Replace('\"', '"')
        }
}

function Get-Refs {
    param(
        [string]$Block,
        [string]$Predicate
    )

    $predicateText = Get-PredicateText -Block $Block -Predicate $Predicate
    if ([string]::IsNullOrWhiteSpace($predicateText)) {
        return @()
    }

    return [regex]::Matches($predicateText, 'epr:([A-Za-z][A-Za-z0-9]*)') |
        ForEach-Object {
            $_.Groups[1].Value
        }
}

function Get-VocabularyRefs {
    param(
        [string]$Block,
        [string]$Predicate
    )

    $predicateText = Get-PredicateText -Block $Block -Predicate $Predicate
    if ([string]::IsNullOrWhiteSpace($predicateText)) {
        return @()
    }

    return [regex]::Matches($predicateText, 'eprv:([A-Za-z][A-Za-z0-9]*)') |
        ForEach-Object {
            $_.Groups[1].Value
        }
}

function Escape-MarkdownTableCell {
    param([AllowNull()][string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    return ($Value -replace '\|', '\|' -replace "`r?`n", "<br>")
}

function Html-Encode {
    param([AllowNull()][string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    return [System.Net.WebUtility]::HtmlEncode($Value)
}

$conceptMatches = [regex]::Matches(
    $ttl,
    "(?ms)^epr:([A-Za-z][A-Za-z0-9]*)\s*\r?\n\s+a\s+skos:Concept[^\n]*\r?\n(.*?)(?=^\S|\z)"
)

$concepts = foreach ($match in $conceptMatches) {
    $localName = $match.Groups[1].Value
    $block = $match.Groups[2].Value
    $preferredLabel = (Get-Literals -Block $block -Predicate "skos:prefLabel" | Select-Object -First 1)

    if ([string]::IsNullOrWhiteSpace($preferredLabel)) {
        $preferredLabel = $localName
    }

    [pscustomobject]@{
        LocalName = $localName
        PreferredLabel = $preferredLabel
        Definition = (Get-Literals -Block $block -Predicate "skos:definition" | Select-Object -First 1)
        Status = (Get-Literals -Block $block -Predicate "epr:status" | Select-Object -First 1)
        Broader = @(Get-Refs -Block $block -Predicate "skos:broader")
        VocabularyMatches = @(Get-VocabularyRefs -Block $block -Predicate "skos:relatedMatch")
        IsTopConcept = $block -match 'skos:topConceptOf\s+epr:establishmentDetailsTaxonomy'
    }
}

if ($concepts.Count -eq 0) {
    throw "No skos:Concept blocks were found in $resolvedTaxonomyPath"
}

$conceptLookup = @{}
foreach ($concept in $concepts) {
    $conceptLookup[$concept.LocalName] = $concept
}

$childrenByParent = @{}
foreach ($concept in $concepts) {
    foreach ($parent in $concept.Broader) {
        if (-not $childrenByParent.ContainsKey($parent)) {
            $childrenByParent[$parent] = New-Object System.Collections.Generic.List[string]
        }
        $childrenByParent[$parent].Add($concept.LocalName)
    }
}

function New-TaxonomyTreeHtml {
    param([string]$LocalName)

    $concept = $conceptLookup[$LocalName]
    $label = if ($concept.VocabularyMatches.Count -gt 0) {
        $vocabularyLocalName = Html-Encode ($concept.VocabularyMatches | Select-Object -First 1)
        $vocabularyHref = "../vocabulary/$vocabularyLocalName/"
        "<a href=""$vocabularyHref"">$((Html-Encode $concept.PreferredLabel))</a>"
    }
    else {
        Html-Encode $concept.PreferredLabel
    }
    $identifier = Html-Encode "epr:$($concept.LocalName)"
    $hasChildren = $childrenByParent.ContainsKey($LocalName) -and $childrenByParent[$LocalName].Count -gt 0

    if (-not $hasChildren) {
        return "<li><span class=""taxonomy-leaf"">$label <code>$identifier</code></span></li>"
    }

    $childHtml = $childrenByParent[$LocalName] |
        Sort-Object { $conceptLookup[$_].PreferredLabel } |
        ForEach-Object { New-TaxonomyTreeHtml -LocalName $_ }

    return @"
<li>
  <details>
    <summary>$label <code>$identifier</code></summary>
    <ul>
$($childHtml -join "`n")
    </ul>
  </details>
</li>
"@
}

function Format-VocabularyConceptLinks {
    param([string[]]$LocalNames)

    if ($null -eq $LocalNames -or $LocalNames.Count -eq 0) {
        return ""
    }

    return ($LocalNames | ForEach-Object {
        "[$_](../vocabulary/$_/)"
    }) -join "<br>"
}

$facets = $concepts | Where-Object { $_.IsTopConcept } | Sort-Object PreferredLabel
$taxons = $concepts | Where-Object { -not $_.IsTopConcept } | Sort-Object PreferredLabel
$treeHtml = $facets | ForEach-Object { New-TaxonomyTreeHtml -LocalName $_.LocalName }

$lines = @(
    "# Establishment Details Taxonomy",
    "",
    "This page is generated from `models/education-provider-taxonomy.ttl`.",
    "",
    "The taxonomy is a faceted SKOS taxonomy. Facets are represented as top concepts, and taxons sit beneath those facets using `skos:broader` relationships.",
    "",
    "## Taxonomy Tree",
    "",
    "The taxonomy tree starts with the facets. Expand a facet to inspect its taxons.",
    "",
    '<div class="taxonomy-tree" aria-label="Taxonomy tree">',
    '<ul>'
)

$lines += $treeHtml
$lines += @(
    '</ul>',
    '</div>',
    "",
    "## Facets",
    "",
    "| Facet | Compact identifier | Vocabulary concept | Definition |",
    "| --- | --- | --- | --- |"
)

foreach ($facet in $facets) {
    $lines += "| $($facet.PreferredLabel) | ``epr:$($facet.LocalName)`` | $(Escape-MarkdownTableCell (Format-VocabularyConceptLinks -LocalNames $facet.VocabularyMatches)) | $(Escape-MarkdownTableCell $facet.Definition) |"
}

$lines += @(
    "",
    "## Taxons",
    "",
    "| Taxon | Compact identifier | Vocabulary concept | Broader concept | Status |",
    "| --- | --- | --- | --- | --- |"
)

foreach ($taxon in $taxons) {
    $broaderLabels = @($taxon.Broader | ForEach-Object {
        if ($conceptLookup.ContainsKey($_)) {
            $conceptLookup[$_].PreferredLabel
        }
        else {
            "epr:$_"
        }
    }) -join "<br>"

    $lines += "| $($taxon.PreferredLabel) | ``epr:$($taxon.LocalName)`` | $(Escape-MarkdownTableCell (Format-VocabularyConceptLinks -LocalNames $taxon.VocabularyMatches)) | $(Escape-MarkdownTableCell $broaderLabels) | $(Escape-MarkdownTableCell $taxon.Status) |"
}

Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "index.md") -Value $lines -Encoding UTF8

Write-Host "Generated taxonomy page with $($concepts.Count) concepts in $resolvedOutputRoot"

