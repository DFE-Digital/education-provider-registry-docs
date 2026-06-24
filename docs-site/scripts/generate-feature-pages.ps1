$ErrorActionPreference = "Stop"

$docsSiteRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")
$repoRoot = Resolve-Path -LiteralPath (Join-Path $docsSiteRoot "..")
$featuresRoot = Join-Path $repoRoot "features"
$outputRoot = Join-Path $docsSiteRoot "content\features"

if (-not (Test-Path -LiteralPath $featuresRoot)) {
    throw "Feature folder not found: $featuresRoot"
}

New-Item -ItemType Directory -Force -Path $outputRoot | Out-Null

Get-ChildItem -LiteralPath $outputRoot -Filter "*.md" -File | Remove-Item -Force

function ConvertTo-MarkdownSafeText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    return ($Value -replace '\|', '\|')
}

function Get-FeatureTitle {
    param(
        [string[]]$Lines,
        [Parameter(Mandatory = $true)]
        [string]$Fallback
    )

    foreach ($line in $Lines) {
        if ($line -match '^\s*Feature:\s*(.+?)\s*$') {
            return $Matches[1]
        }
    }

    return $Fallback
}

function Get-FeatureTags {
    param(
        [string[]]$Lines
    )

    $tags = New-Object System.Collections.Generic.List[string]

    foreach ($line in $Lines) {
        if ($line -match '^\s*#') {
            continue
        }

        if ($line -match '^\s*@') {
            $lineTags = $line.Trim().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
            foreach ($tag in $lineTags) {
                $tags.Add($tag)
            }
            continue
        }

        if ($line -match '^\s*Feature:') {
            break
        }

        if (-not [string]::IsNullOrWhiteSpace($line)) {
            break
        }
    }

    return $tags.ToArray()
}

function Get-Scenarios {
    param(
        [string[]]$Lines
    )

    $scenarios = New-Object System.Collections.Generic.List[object]
    $pendingTags = New-Object System.Collections.Generic.List[string]

    foreach ($line in $Lines) {
        if ($line -match '^\s*@') {
            $pendingTags.Clear()
            $lineTags = $line.Trim().Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
            foreach ($tag in $lineTags) {
                $pendingTags.Add($tag)
            }
            continue
        }

        if ($line -match '^\s*Scenario(?: Outline)?:\s*(.+?)\s*$') {
            $scenarios.Add([pscustomobject]@{
                Title = $Matches[1]
                Tags = @($pendingTags.ToArray())
            })
            $pendingTags.Clear()
            continue
        }

        if (-not [string]::IsNullOrWhiteSpace($line) -and $line -notmatch '^\s*#') {
            $pendingTags.Clear()
        }
    }

    return $scenarios.ToArray()
}

$featureFiles = Get-ChildItem -LiteralPath $featuresRoot -Filter "*.feature" -File | Sort-Object Name
$featureRows = New-Object System.Collections.Generic.List[string]
$featureRows.Add("| Feature | Tags | Scenarios |")
$featureRows.Add("| --- | --- | ---: |")

foreach ($featureFile in $featureFiles) {
    $featureText = Get-Content -LiteralPath $featureFile.FullName -Raw
    $featureLines = $featureText -split "`r?`n"
    $title = Get-FeatureTitle -Lines $featureLines -Fallback $featureFile.BaseName
    $tags = Get-FeatureTags -Lines $featureLines
    $scenarios = Get-Scenarios -Lines $featureLines
    $outputName = "$($featureFile.BaseName).md"
    $outputPath = Join-Path $outputRoot $outputName

    $tagText = if ($tags.Count -gt 0) { ($tags -join ", ") } else { "None" }
    $scenarioRows = New-Object System.Collections.Generic.List[string]
    $scenarioRows.Add("| Scenario | Tags |")
    $scenarioRows.Add("| --- | --- |")
    foreach ($scenario in $scenarios) {
        $scenarioTagText = if ($scenario.Tags.Count -gt 0) { ($scenario.Tags -join ", ") } else { "None" }
        $scenarioRows.Add("| $(ConvertTo-MarkdownSafeText $scenario.Title) | $(ConvertTo-MarkdownSafeText $scenarioTagText) |")
    }

    $escapedFeatureText = [System.Net.WebUtility]::HtmlEncode($featureText)
    $contentLines = @(
        "# $title",
        "",
        "<p class=`"meta`">Source feature file: <code>features/$($featureFile.Name)</code></p>",
        "",
        "## Summary",
        "",
        "| Item | Value |",
        "| --- | --- |",
        "| File | ``features/$($featureFile.Name)`` |",
        "| Tags | ``$tagText`` |",
        "| Scenario count | $($scenarios.Count) |",
        "",
        "## Scenarios",
        "",
        ($scenarioRows -join "`n"),
        "",
        "## Feature Source",
        "",
        "<pre><code class=`"language-gherkin`">$escapedFeatureText</code></pre>"
    )
    $content = $contentLines -join "`n"

    Set-Content -LiteralPath $outputPath -Value $content -Encoding UTF8
    $featureRows.Add("| [$title](./$($featureFile.BaseName)/) | $(ConvertTo-MarkdownSafeText $tagText) | $($scenarios.Count) |")
}

$indexContent = @(
    "# Feature Files",
    "",
    "These pages are generated from the source-controlled Gherkin feature files in ``features/``.",
    "",
    "The ``.feature`` files remain the source of truth. These pages are a published reading view.",
    "",
    ($featureRows -join "`n")
) -join "`n"

Set-Content -LiteralPath (Join-Path $outputRoot "index.md") -Value $indexContent -Encoding UTF8
