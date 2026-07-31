param(
    [string]$VocabularyPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "models" (Join-Path "establishment" "establishment-vocabulary.ttl"))),
    [string]$ReferencesDocPath = (Join-Path (Join-Path $PSScriptRoot "..\..") (Join-Path "models" (Join-Path "establishment" "establishment-real-world-references.md"))),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" (Join-Path "models" (Join-Path "establishment" "vocabulary")))),
    [string]$VocabularyPrefix = "est",
    [string]$CanonicalUriBase = "https://dfe-digital.github.io/education-provider-registry-docs/models/establishment/vocabulary/",
    [string]$VocabularyTitle = "Vocabulary",
    [string]$SourceTtlLabel = "models/establishment/establishment-vocabulary.ttl",
    [string]$SourceTtlUrl = "https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/establishment/establishment-vocabulary.ttl",
    [switch]$SkipReferences
)

$ErrorActionPreference = "Stop"

$resolvedVocabularyPath = Resolve-Path -LiteralPath $VocabularyPath
$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot
$ttl = Get-Content -LiteralPath $resolvedVocabularyPath -Raw
$escapedVocabularyPrefix = [regex]::Escape($VocabularyPrefix)

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

    return [regex]::Matches($predicateText, "${escapedVocabularyPrefix}:([A-Za-z][A-Za-z0-9]*)") |
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

$conceptMatches = [regex]::Matches(
    $ttl,
    "(?ms)^${escapedVocabularyPrefix}:([A-Za-z][A-Za-z0-9]*)\s+a\s+skos:Concept\s*;\s*(.*?)(?=^\S|\z)"
)

$concepts = foreach ($match in $conceptMatches) {
    $localName = $match.Groups[1].Value
    $block = $match.Groups[2].Value
    $preferredLabel = (Get-Literals -Block $block -Predicate "skos:prefLabel" | Select-Object -First 1)

    if ([string]::IsNullOrWhiteSpace($preferredLabel)) {
        $preferredLabel = $localName
    }

    [pscustomobject]@{
        LocalName         = $localName
        PreferredLabel    = $preferredLabel
        AlternativeLabels   = @(Get-Literals -Block $block -Predicate "skos:altLabel")
        LegacyGiasLabels    = @(Get-Literals -Block $block -Predicate "${VocabularyPrefix}:legacyGiasLabel")
        Definition        = (Get-Literals -Block $block -Predicate "skos:definition" | Select-Object -First 1)
        ScopeNotes        = @(Get-Literals -Block $block -Predicate "skos:scopeNote")
        Status            = (Get-Literals -Block $block -Predicate "${VocabularyPrefix}:status" | Select-Object -First 1)
        Broader           = @(Get-Refs -Block $block -Predicate "skos:broader")
        Related           = @(Get-Refs -Block $block -Predicate "skos:related")
        Sources           = @(Get-Literals -Block $block -Predicate "dcterms:source")
        IsDefinedBy       = @(Get-UriValues -Block $block -Predicate "rdfs:isDefinedBy")
        Legislation       = @(Get-UriValues -Block $block -Predicate "${VocabularyPrefix}:legislation")
        References        = @(Get-UriValues -Block $block -Predicate "dcterms:references")
        SeeAlso           = @(Get-UriValues -Block $block -Predicate "rdfs:seeAlso")
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
            "``${VocabularyPrefix}:$($_)``"
        }
    }) -join "<br>"
}

foreach ($concept in $concepts | Sort-Object PreferredLabel, LocalName) {
    $canonicalUri = "$CanonicalUriBase$($concept.LocalName)/"
    $sourceTtl = $SourceTtlUrl

    $rawRefsLinks = Format-UriLinks $concept.References
    $evidenceLinks = ($concept.SeeAlso |
        Where-Object { $_ -match '/vocabulary/references/' } |
        ForEach-Object { "[See evidence for $($concept.PreferredLabel)]($_)" }) -join "<br>"
    $refsPartsList = @()
    if (![string]::IsNullOrWhiteSpace($rawRefsLinks)) { $refsPartsList += $rawRefsLinks }
    if (![string]::IsNullOrWhiteSpace($evidenceLinks)) { $refsPartsList += $evidenceLinks }
    $refsCell = $refsPartsList -join "<br>"

    $lines = @(
        "# $($concept.PreferredLabel)",
        "",
        "[Back to vocabulary index](../)",
        "",
        "| Property | Value |",
        "| --- | --- |",
        "| Canonical URI | <$canonicalUri> |",
        "| Compact identifier | ``${VocabularyPrefix}:$($concept.LocalName)`` |",
        "| Preferred label | $(Escape-MarkdownTableCell $concept.PreferredLabel) |",
        "| Alternative labels | $(Escape-MarkdownTableCell (Join-Values $concept.AlternativeLabels)) |",
        "| Legacy GIAS label | $(Escape-MarkdownTableCell (Join-Values $concept.LegacyGiasLabels)) |",
        "| Status | $(Escape-MarkdownTableCell $concept.Status) |",
        "| Broader concepts | $(Escape-MarkdownTableCell (Format-ConceptLinks -LocalNames $concept.Broader -ConceptLookup $conceptLookup)) |",
        "| Related concepts | $(Escape-MarkdownTableCell (Format-ConceptLinks -LocalNames $concept.Related -ConceptLookup $conceptLookup)) |",
        "| Defined by | $(Escape-MarkdownTableCell (Format-UriLinks $concept.IsDefinedBy)) |",
        "| Legislation | $(Escape-MarkdownTableCell (Format-UriLinks $concept.Legislation)) |",
        "| References | $(Escape-MarkdownTableCell $refsCell) |",
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
        "Source TTL: [$SourceTtlLabel]($sourceTtl)"
    )

    Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "$($concept.LocalName).md") -Value $lines -Encoding UTF8
}

$indexLines = @(
    "# $VocabularyTitle",
    "",
    "This index is generated from ``$SourceTtlLabel``.",
    "",
    $(if ($SkipReferences) { "" } else { "See also: [Real-world references for all vocabulary concepts](references/)" }),
    "",
    "| Concept | Compact identifier | Status | Definition |",
    "| --- | --- | --- | --- |"
)

foreach ($concept in $concepts | Sort-Object PreferredLabel, LocalName) {
    $definition = Escape-MarkdownTableCell $concept.Definition
    $indexLines += "| [$($concept.PreferredLabel)](./$($concept.LocalName)/) | ``${VocabularyPrefix}:$($concept.LocalName)`` | $(Escape-MarkdownTableCell $concept.Status) | $definition |"
}

Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "index.md") -Value $indexLines -Encoding UTF8

# Copy the real-world references doc into the vocabulary content section,
# then hyperlink each concept term in the first column to its vocabulary page.
if (-not $SkipReferences -and (Test-Path -LiteralPath $ReferencesDocPath)) {
    $referencesContent = Get-Content -LiteralPath $ReferencesDocPath -Raw

    # Build anchor → concept local-name map from rdfs:seeAlso on each concept,
    # and count how many distinct concepts share each anchor. A term's own label
    # may legitimately contain a "/" (e.g. "Appointed by GB/board", "LAESTAB / DfE
    # number") without being a compound row - the only reliable signal for "this
    # anchor covers more than one concept and has no single link target" is that
    # more than one concept's rdfs:seeAlso resolves to it.
    $anchorToConceptName = @{}
    $anchorConceptCount = @{}
    foreach ($concept in $concepts | Sort-Object PreferredLabel, LocalName) {
        foreach ($uri in $concept.SeeAlso) {
            if ($uri -match '#([^/]+)$') {
                $anchor = $Matches[1]
                if (-not $anchorToConceptName.ContainsKey($anchor)) {
                    $anchorToConceptName[$anchor] = $concept.LocalName
                }
                if ($anchorConceptCount.ContainsKey($anchor)) {
                    $anchorConceptCount[$anchor] = $anchorConceptCount[$anchor] + 1
                } else {
                    $anchorConceptCount[$anchor] = 1
                }
            }
        }
    }

    # Replace  <a id="ANCHOR"></a>TERM  with  <a id="ANCHOR"></a>[TERM](../ConceptName/)
    # in the markdown table rows. Skip only anchors shared by more than one concept
    # (genuine compound rows, e.g. "GroupRelationship / GroupRelationshipType") -
    # a "/" in the term text alone is not a reason to skip.
    $referencesContent = [regex]::Replace(
        $referencesContent,
        '(<a id="([^"]+)"></a>)([^|\r\n]+?)(\s*)(?=\|)',
        {
            param($m)
            $tag    = $m.Groups[1].Value
            $anchor = $m.Groups[2].Value
            $term   = $m.Groups[3].Value
            $pad    = $m.Groups[4].Value
            if ($anchorToConceptName.ContainsKey($anchor) -and $anchorConceptCount[$anchor] -eq 1 -and $term -notmatch '\]\(') {
                $cn = $anchorToConceptName[$anchor]
                "${tag}[$term](../$cn/)$pad"
            } else {
                $m.Value
            }
        }
    )

    Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "references.md") -Value $referencesContent -Encoding UTF8
    Write-Host "Copied and hyperlinked real-world references doc ($($anchorToConceptName.Count) anchors mapped)"
}
else {
    Write-Warning "References doc not found at $ReferencesDocPath - references page will not be generated"
}

Write-Host "Generated $($concepts.Count) vocabulary concept pages in $resolvedOutputRoot"
