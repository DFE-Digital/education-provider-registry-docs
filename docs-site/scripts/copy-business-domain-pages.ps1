param(
    [string]$BusinessDomainPath = (Join-Path (Join-Path $PSScriptRoot "..\..") "business-domain"),
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "content" "business-domain"))
)

$ErrorActionPreference = "Stop"

$resolvedBusinessDomainPath = Resolve-Path -LiteralPath $BusinessDomainPath
$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot

Get-ChildItem -LiteralPath $resolvedOutputRoot -Filter "*.md" -File | Remove-Item -Force

$markdownFiles = Get-ChildItem -LiteralPath $resolvedBusinessDomainPath -Filter "*.md" -File |
    Sort-Object Name

if ($markdownFiles.Count -eq 0) {
    Write-Warning "No markdown files found to copy in $resolvedBusinessDomainPath"
    return
}

$indexLines = [System.Collections.Generic.List[string]]::new()
$indexLines.Add("# Business Domain")
$indexLines.Add("")
$indexLines.Add("These pages document the business meaning of education providers, provider organisations, relationships and governance.")
$indexLines.Add("")
$indexLines.Add("The source Markdown files are in `business-domain/` in this repository.")
$indexLines.Add("")

$copiedCount = 0
foreach ($file in $markdownFiles) {
    $destination = Join-Path $resolvedOutputRoot $file.Name
    Copy-Item -LiteralPath $file.FullName -Destination $destination -Force

    $title = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $content = Get-Content -LiteralPath $file.FullName -Raw
    $headingMatch = [regex]::Match($content, '(?m)^#\s+(.+?)\s*$')
    if ($headingMatch.Success) {
        $title = $headingMatch.Groups[1].Value.Trim()
    }

    $slug = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $indexLines.Add("- [$title](./$slug/)")
    $copiedCount++
}

Set-Content -LiteralPath (Join-Path $resolvedOutputRoot "index.md") -Value ($indexLines -join [Environment]::NewLine) -Encoding UTF8

Write-Host "Copied $copiedCount business-domain markdown file(s) from business-domain/ to $resolvedOutputRoot"
