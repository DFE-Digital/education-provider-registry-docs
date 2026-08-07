param(
    [string]$OutputRoot = (Join-Path (Join-Path $PSScriptRoot "..") (Join-Path "output" (Join-Path "assets" "vendor")))
)

$ErrorActionPreference = "Stop"

$resolvedOutputRoot = New-Item -ItemType Directory -Force -Path $OutputRoot

# Self-hosted copies of third-party JS/CSS used by docs-site/layouts/default.html.
#
# These used to be loaded directly from cdn.jsdelivr.net. Chromium (and so Edge)
# blocks parser-blocking, cross-site scripts that are injected via
# document.write() - which is exactly how staticrypt reveals a page after a
# correct password. That silently broke mermaid diagrams and code
# highlighting on every password-protected page in a browser (Edge in
# particular applies this more readily than Chrome). Self-hosting removes the
# "cross site" classification entirely, regardless of browser or connection
# heuristics.
#
# mermaid.min.js is the standalone UMD browser build (not the ESM "+esm"
# CDN transform previously used) - the ESM transform's own imports resolve
# further dependencies as absolute /npm/... paths against jsdelivr's own
# origin, so it cannot be self-hosted by simply downloading one file. The
# UMD build is fully self-contained.
$assets = @(
    @{
        Name = "mermaid.min.js"
        Url  = "https://cdn.jsdelivr.net/npm/mermaid@11.14.0/dist/mermaid.min.js"
    },
    @{
        Name = "highlight.min.js"
        Url  = "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/highlight.min.js"
    },
    @{
        Name = "highlight-default.min.css"
        Url  = "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/styles/default.min.css"
    },
    @{
        Name = "highlight-gherkin.min.js"
        Url  = "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release@11/build/languages/gherkin.min.js"
    }
    # No Turtle language file: highlight.js's core distribution does not ship
    # a "turtle" grammar (the previous CDN reference to
    # languages/turtle.min.js was a dead link - 404 - so Turtle code blocks
    # have never actually been syntax-highlighted on this site).
)

foreach ($asset in $assets) {
    $destination = Join-Path $resolvedOutputRoot $asset.Name
    if (Test-Path -LiteralPath $destination) {
        Write-Host "Already present: $($asset.Name)"
        continue
    }

    Write-Host "Downloading $($asset.Name) from $($asset.Url)"

    # Bounded and retried so a slow/unreachable CDN fails fast and visibly
    # instead of the job hanging - Invoke-WebRequest has no default retry and
    # its default timeout behaviour is not a reliable wall-clock bound.
    $maxAttempts = 3
    $attempt = 0
    $succeeded = $false
    while (-not $succeeded -and $attempt -lt $maxAttempts) {
        $attempt++
        try {
            Invoke-WebRequest -Uri $asset.Url -OutFile $destination -TimeoutSec 30
            $succeeded = $true
        }
        catch {
            if ($attempt -ge $maxAttempts) {
                throw "Failed to download $($asset.Name) from $($asset.Url) after $maxAttempts attempts: $_"
            }
            Write-Warning "Attempt $attempt of $maxAttempts failed for $($asset.Name): $_. Retrying in 5s..."
            Start-Sleep -Seconds 5
        }
    }
}
