param(
    [string]$VocabularyPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "models" "education-provider-vocabulary.ttl")),
    [string]$TaxonomyPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "models" "education-provider-taxonomy.ttl")),
    [string]$ReferencesDocPath = (Join-Path (Join-Path (Join-Path $PSScriptRoot "..\..\..") (Join-Path "docs" (Join-Path "transformation" (Join-Path "data" "modelling")))) "vocabulary-real-world-references.md"),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" "vocabulary"))
)

$ErrorActionPreference = "Stop"

$resolvedVocabularyPath = Resolve-Path -LiteralPath $VocabularyPath
$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot
$ttl = Get-Content -LiteralPath $resolvedVocabularyPath -Raw

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

function Get-UriValues {
    param(
        [string]$Block,
        [string]$Predicate
    )

    # Does not use Get-PredicateText because URIs contain dots, which break the
    # character class [^;".] used there. Match the predicate then capture all
    # angle-bracket URIs directly.
    $escapedPredicate = [regex]::Escape($Predicate)
    $pattern = "(?ms)${escapedPredicate}\s+((?:<https?://[^>]+>\s*,\s*)*<https?://[^>]+>)\s*(?:;|\.\s*(?:\r?\n|$))"
    $match = [regex]::Match($Block, $pattern)
    if (-not $match.Success) {
        return @()
    }

    return [regex]::Matches($match.Groups[1].Value, '<(https?://[^>]+)>') |
        ForEach-Object { $_.Groups[1].Value }
}

function Escape-MarkdownTableCell {
    param([AllowNull()][string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return ""
    }

    return ($Value -replace '\|', '\|' -replace "`r?`n", "<br>")
}

function Join-Values {
    param([string[]]$Values)

    if ($null -eq $Values -or $Values.Count -eq 0) {
        return ""
    }

    return ($Values | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) -join "<br>"
}

function Format-UriLinks {
    param([string[]]$Uris)

    if ($null -eq $Uris -or $Uris.Count -eq 0) {
        return ""
    }

    return ($Uris | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | ForEach-Object {
        "[$_]($_)"
    }) -join "<br>"
}

# Build citation lookup from the taxonomy TTL (rdfs:isDefinedBy, epr:legislation, dcterms:references)
$citationLookup = @{}
if (Test-Path -LiteralPath $TaxonomyPath) {
    $resolvedTaxonomyPath = Resolve-Path -LiteralPath $TaxonomyPath
    $taxonomyTtl = Get-Content -LiteralPath $resolvedTaxonomyPath -Raw

    $taxonMatches = [regex]::Matches(
        $taxonomyTtl,
        "(?ms)^epr:([A-Za-z][A-Za-z0-9]*)\s*\r?\n\s+a\s+skos:Concept\s*;\s*(.*?)(?=^\S|\z)"
    )

    foreach ($match in $taxonMatches) {
        $localName = $match.Groups[1].Value
        $block = $match.Groups[2].Value
        $isDefinedBy = @(Get-UriValues -Block $block -Predicate "rdfs:isDefinedBy")
        $legislation  = @(Get-UriValues -Block $block -Predicate "epr:legislation")
        $references   = @(Get-UriValues -Block $block -Predicate "dcterms:references")

        if ($isDefinedBy.Count -gt 0 -or $legislation.Count -gt 0 -or $references.Count -gt 0) {
            $citationLookup[$localName] = @{
                IsDefinedBy = $isDefinedBy
                Legislation = $legislation
                References  = $references
            }
        }
    }

    Write-Host "Built citation lookup from taxonomy: $($citationLookup.Count) concepts with citations"
}
else {
    Write-Warning "Taxonomy file not found at $TaxonomyPath — citation attributes will not be shown on vocab pages"
}

$conceptMatches = [regex]::Matches(
    $ttl,
    "(?ms)^epr:([A-Za-z][A-Za-z0-9]*)\s*\r?\n\s+a\s+skos:Concept\s*;\s*(.*?)(?=^\S|\z)"
)

$concepts = foreach ($match in $conceptMatches) {
    $localName = $match.Groups[1].Value
    $block = $match.Groups[2].Value
    $preferredLabel = (Get-Literals -Block $block -Predicate "skos:prefLabel" | Select-Object -First 1)

    if ([string]::IsNullOrWhiteSpace($preferredLabel)) {
        $preferredLabel = $localName
    }

    $citations = if ($citationLookup.ContainsKey($localName)) { $citationLookup[$localName] } else { $null }

    [pscustomobject]@{
        LocalName         = $localName
        PreferredLabel    = $preferredLabel
        AlternativeLabels   = @(Get-Literals -Block $block -Predicate "skos:altLabel")
        LegacyGiasLabels    = @(Get-Literals -Block $block -Predicate "epr:legacyGiasLabel")
        Definition        = (Get-Literals -Block $block -Predicate "skos:definition" | Select-Object -First 1)
        ScopeNotes        = @(Get-Literals -Block $block -Predicate "skos:scopeNote")
        Status            = (Get-Literals -Block $block -Predicate "epr:status" | Select-Object -First 1)
        Broader           = @(Get-Refs -Block $block -Predicate "skos:broader")
        Related           = @(Get-Refs -Block $block -Predicate "skos:related")
        Sources           = @(Get-Literals -Block $block -Predicate "dcterms:source")
        IsDefinedBy       = if ($null -ne $citations) { $citations.IsDefinedBy } else { @() }
        Legislation       = if ($null -ne $citations) { $citations.Legislation } else { @() }
        References        = if ($null -ne $citations) { $citations.References } else { @() }
    }
}

if ($concepts.Count -eq 0) {
    throw "No skos:Concept blocks were found in $resolvedVocabularyPath"
}

$conceptLookup = @{}
foreach ($concept in $concepts) {
    $conceptLookup[$concept.LocalName] = $concept
}

function Format-ConceptLinks {
    param(
        [string[]]$LocalNames,
        [hashtable]$ConceptLookup
    )

    if ($null -eq $LocalNames -or $LocalNames.Count -eq 0) {
        return ""
    }

    return ($LocalNames | ForEach-Object {
        if ($ConceptLookup.ContainsKey($_)) {
            $label = $ConceptLookup[$_].PreferredLabel
            "[$label](../$_/)"
        }
        else {
            "``epr:$($_)``"
        }
    }) -join "<br>"
}

foreach ($concept in $concepts | Sort-Object PreferredLabel, LocalName) {
    $canonicalUri = "https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/$($concept.LocalName)/"
    $sourceTtl = "https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl"

    $lines = @(
        "# $($concept.PreferredLabel)",
        "",
        "[Back to vocabulary index](../)",
        "",
        "| Property | Value |",
        "| --- | --- |",
        "| Canonical URI | <$canonicalUri> |",
        "| Compact identifier | ``epr:$($concept.LocalName)`` |",
        "| Preferred label | $(Escape-MarkdownTableCell $concept.PreferredLabel) |",
        "| Alternative labels | $(Escape-MarkdownTableCell (Join-Values $concept.AlternativeLabels)) |",
        "| Legacy GIAS label | $(Escape-MarkdownTableCell (Join-Values $concept.LegacyGiasLabels)) |",
        "| Status | $(Escape-MarkdownTableCell $concept.Status) |",
        "| Broader concepts | $(Escape-MarkdownTableCell (Format-ConceptLinks -LocalNames $concept.Broader -ConceptLookup $conceptLookup)) |",
        "| Related concepts | $(Escape-MarkdownTableCell (Format-ConceptLinks -LocalNames $concept.Related -ConceptLookup $conceptLookup)) |",
        "| Defined by | $(Escape-MarkdownTableCell (Format-UriLinks $concept.IsDefinedBy)) |",
        "| Legislation | $(Escape-MarkdownTableCell (Format-UriLinks $concept.Legislation)) |",
        "| References | $(Escape-MarkdownTableCell (Format-UriLinks $concept.References)) |",
        "",
        "## Definition",
        "",
        $(if ([string]::IsNullOrWhiteSpace($concept.Definition)) { "No definition recorded." } else { $concept.Definition }),
        "",
        "## Scope Notes",
        ""
    )

    if ($concept.ScopeNotes.Count -eq 0) {
        $lines += "No scope notes recorded."
    }
    else {
        foreach ($note in $concept.ScopeNotes) {
            $lines += "- $note"
        }
    }

    $lines += @(
        "",
        "## Source",
        "",
        "Source TTL: <$sourceTtl>"
    )

    Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "$($concept.LocalName).md") -Value $lines -Encoding UTF8
}

$indexLines = @(
    "# Vocabulary",
    "",
    "This index is generated from `models/education-provider-vocabulary.ttl`.",
    "",
    "See also: [Real-world references for all vocabulary concepts](references/)",
    "",
    "| Concept | Compact identifier | Status | Definition |",
    "| --- | --- | --- | --- |"
)

foreach ($concept in $concepts | Sort-Object PreferredLabel, LocalName) {
    $definition = Escape-MarkdownTableCell $concept.Definition
    $indexLines += "| [$($concept.PreferredLabel)](./$($concept.LocalName)/) | ``epr:$($concept.LocalName)`` | $(Escape-MarkdownTableCell $concept.Status) | $definition |"
}

Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "index.md") -Value $indexLines -Encoding UTF8

# Copy the real-world references doc into the vocabulary content section
if (Test-Path -LiteralPath $ReferencesDocPath) {
    $referencesContent = Get-Content -LiteralPath $ReferencesDocPath -Raw
    Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "references.md") -Value $referencesContent -Encoding UTF8
    Write-Host "Copied real-world references doc to content/vocabulary/references.md"
}
else {
    Write-Warning "References doc not found at $ReferencesDocPath — references page will not be generated"
}

Write-Host "Generated $($concepts.Count) vocabulary concept pages in $resolvedOutputRoot"
