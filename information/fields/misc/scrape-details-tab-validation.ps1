param(
    [string]$OutputPath = "docs\data\extract-data\establishment-fields\analysis\details-tab-fields-csharp-resolution-public-sample-validation.md",
    [int]$SampleSize = 5
)

$ErrorActionPreference = "Stop"

$root = (Resolve-Path ".").Path
$resolutionPath = Join-Path $root "docs\data\extract-data\establishment-fields\analysis\details-tab-fields-csharp-resolution.md"
$allDataPath = Join-Path $root "docs\data\extract-data\establishment-fields\edubasealldata20260616.csv"
$childrenCentrePath = Join-Path $root "docs\data\extract-data\establishment-fields\edubaseallchildrencentre20260616.csv"
$outPath = Join-Path $root $OutputPath

function Get-TypeRowsFromResolution {
    Get-Content -LiteralPath $resolutionPath |
        Where-Object { $_ -match '^\| `\d+' } |
        ForEach-Object {
            $parts = $_ -split '\|'
            [pscustomobject]@{
                Code = ($parts[1] -replace '[` ]', '').Trim()
                Name = $parts[2].Trim()
                ResolvedCount = [int]($parts[3].Trim())
                ResolvedFields = $parts[4].Trim()
            }
        }
}

function Get-ExtractRows {
    $rows = @()
    $rows += Import-Csv -LiteralPath $allDataPath | Select-Object URN, EstablishmentName, 'TypeOfEstablishment (code)', 'TypeOfEstablishment (name)'

    if (Test-Path -LiteralPath $childrenCentrePath) {
        $ccRows = Import-Csv -LiteralPath $childrenCentrePath
        foreach ($row in $ccRows) {
            $urn = $row.URN
            if (-not $urn) { $urn = $row.'URN' }

            $typeCode = $row.'TypeOfEstablishment (code)'
            if (-not $typeCode) { $typeCode = $row.'TypeOfEstablishmentCode' }
            if (-not $typeCode) { $typeCode = $row.'Type of establishment (code)' }

            $typeName = $row.'TypeOfEstablishment (name)'
            if (-not $typeName) { $typeName = $row.'TypeOfEstablishmentName' }
            if (-not $typeName) { $typeName = $row.'Type of establishment (name)' }

            if ($urn -and $typeCode) {
                $rows += [pscustomobject]@{
                    URN = $urn
                    EstablishmentName = $row.EstablishmentName
                    'TypeOfEstablishment (code)' = $typeCode
                    'TypeOfEstablishment (name)' = $typeName
                }
            }
        }
    }

    $rows
}

function Convert-HtmlToText {
    param([string]$Html)

    $text = $Html -replace '<script[\s\S]*?</script>', ' '
    $text = $text -replace '<style[\s\S]*?</style>', ' '
    $text = $text -replace '<a[^>]*class="[^"]*help-icon[^"]*"[\s\S]*?</a>', ' '
    $text = $text -replace '<span[^>]*class="[^"]*govuk-visually-hidden[^"]*"[\s\S]*?</span>', ' '
    $text = $text -replace '<[^>]+>', ' '
    $text = [System.Net.WebUtility]::HtmlDecode($text)
    $text = $text -replace '\s+', ' '
    $text.Trim()
}

function Get-DetailsTabLabels {
    param([string]$Urn)

    $url = "https://www.get-information-schools.service.gov.uk/Establishments/Establishment/Details/$Urn#school-dashboard"
    $response = Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 30
    $html = $response.Content

    $dashboardStart = $html.IndexOf('id="school-dashboard"', [System.StringComparison]::OrdinalIgnoreCase)
    if ($dashboardStart -ge 0) {
        $html = $html.Substring($dashboardStart)
        $nextTabMatch = [regex]::Match($html, 'id="school-(governance|links|location|change-history|iebt)"', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        if ($nextTabMatch.Success -and $nextTabMatch.Index -gt 0) {
            $html = $html.Substring(0, $nextTabMatch.Index)
        }
    }

    $matches = [regex]::Matches($html, '<dt[^>]*class="[^"]*govuk-summary-list__key[^"]*"[^>]*>([\s\S]*?)</dt>', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    $labels = New-Object System.Collections.Generic.List[string]
    foreach ($match in $matches) {
        $label = Convert-HtmlToText $match.Groups[1].Value
        if ($label -and -not $labels.Contains($label)) {
            $labels.Add($label)
        }
    }

    $labels
}

$types = Get-TypeRowsFromResolution
$extractRows = Get-ExtractRows
$random = [System.Random]::new(20260714)
$results = New-Object System.Collections.Generic.List[object]

foreach ($type in $types) {
    $availableRows = @($extractRows | Where-Object { $_.'TypeOfEstablishment (code)' -eq $type.Code -and $_.URN })
    $sampleRows = @($availableRows | Sort-Object { $random.Next() } | Select-Object -First $SampleSize)

    $labels = New-Object System.Collections.Generic.HashSet[string]
    $fetched = New-Object System.Collections.Generic.List[string]
    $errors = New-Object System.Collections.Generic.List[string]

    foreach ($sample in $sampleRows) {
        try {
            $urn = [string]$sample.URN
            $pageLabels = Get-DetailsTabLabels -Urn $urn
            $fetched.Add($urn)
            foreach ($label in $pageLabels) {
                [void]$labels.Add($label)
            }
            Start-Sleep -Milliseconds 150
        }
        catch {
            $errors.Add("$($sample.URN): $($_.Exception.Message)")
        }
    }

    $results.Add([pscustomobject]@{
        TypeCode = $type.Code
        EstablishmentType = $type.Name
        ResolvedFieldCount = $type.ResolvedCount
        SampleUrnsFetched = ($fetched -join ', ')
        ScrapedFieldCount = $labels.Count
        ScrapedDetailsTabFields = (($labels | Sort-Object) -join '; ')
        FetchErrors = ($errors -join ' | ')
    })
}

$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# Details Tab Fields Public Sample Validation")
$lines.Add("")
$lines.Add("## Purpose")
$lines.Add("")
$lines.Add("This document validates `details-tab-fields-csharp-resolution.md` by fetching a sample of public GIAS Details pages for each establishment type and scraping the rendered Details-tab field labels.")
$lines.Add("")
$lines.Add("## Methodology")
$lines.Add("")
$lines.Add("- Sampled up to $SampleSize random establishments per establishment type from the local extract data.")
$lines.Add("- Used a deterministic random seed so the sample can be reproduced.")
$lines.Add("- Fetched `https://www.get-information-schools.service.gov.uk/Establishments/Establishment/Details/{urn}#school-dashboard` for each sampled URN.")
$lines.Add("- Scraped `dt.govuk-summary-list__key` labels from the Details tab HTML.")
$lines.Add("- Unioned the scraped labels across the sampled URNs for each establishment type.")
$lines.Add("")
$lines.Add("## Important Limitations")
$lines.Add("")
$lines.Add("- This is still sampled evidence, not a complete crawl of every establishment.")
$lines.Add("- The public page may suppress fields that are present in extract data or legacy field/type metadata.")
$lines.Add("- Some fields are relationship, service-link or feature-flag dependent and may not appear in a small sample.")
$lines.Add("- Rows with fewer than $SampleSize fetched URNs either had fewer available extract rows or fetch errors.")
$lines.Add("")
$lines.Add("## Public Sample Validation")
$lines.Add("")
$lines.Add("| Type code | Establishment type | Resolved field count | Sample URNs fetched | Scraped field count | Scraped Details-tab fields | Fetch errors |")
$lines.Add("| --- | --- | ---: | --- | ---: | --- | --- |")

foreach ($result in $results) {
    $lines.Add(('| `{0}` | {1} | {2} | {3} | {4} | {5} | {6} |' -f $result.TypeCode, $result.EstablishmentType, $result.ResolvedFieldCount, $result.SampleUrnsFetched, $result.ScrapedFieldCount, $result.ScrapedDetailsTabFields, $result.FetchErrors))
}

Set-Content -LiteralPath $outPath -Value $lines -Encoding UTF8
Write-Output "Wrote $outPath"
