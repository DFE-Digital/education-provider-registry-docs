param(
    [switch]$SkipBundleInstall
)

$ErrorActionPreference = "Stop"

$docsSiteRoot = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")
$isWindowsRuntime = $env:OS -eq "Windows_NT"
$bundleUserHome = Join-Path $docsSiteRoot ".bundle-user"

$env:BUNDLE_USER_HOME = $bundleUserHome
$env:BUNDLE_USER_CACHE = Join-Path $bundleUserHome "cache"
$env:BUNDLE_USER_CONFIG = Join-Path $bundleUserHome "config"
$env:BUNDLE_USER_PLUGIN = Join-Path $bundleUserHome "plugin"

function Invoke-Native {
    param(
        [Parameter(Mandatory = $true)]
        [scriptblock]$Command,
        [Parameter(Mandatory = $true)]
        [string]$Description
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "$Description failed with exit code $LASTEXITCODE."
    }
}

function Update-FileIfChanged {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [string]$Content
    )

    $currentContent = Get-Content -LiteralPath $Path -Raw
    if ($currentContent -ne $Content) {
        Set-Content -LiteralPath $Path -Value $Content -Encoding UTF8
    }
}

function Set-NanocWindowsCompatibility {
    $coreFile = Get-ChildItem -LiteralPath "vendor/bundle/ruby" -Recurse -Filter "core.rb" |
        Where-Object { $_.FullName -match "\\gems\\nanoc-core-[^\\]+\\lib\\nanoc\\core\.rb$" } |
        Select-Object -First 1

    $cliFile = Get-ChildItem -LiteralPath "vendor/bundle/ruby" -Recurse -Filter "cli.rb" |
        Where-Object { $_.FullName -match "\\gems\\nanoc-cli-[^\\]+\\lib\\nanoc\\cli\.rb$" } |
        Select-Object -First 1

    $deployingFile = Get-ChildItem -LiteralPath "vendor/bundle/ruby" -Recurse -Filter "deploying.rb" |
        Where-Object { $_.FullName -match "\\gems\\nanoc-deploying-[^\\]+\\lib\\nanoc\\deploying\.rb$" } |
        Select-Object -First 1

    if ($null -eq $coreFile -or $null -eq $cliFile -or $null -eq $deployingFile) {
        throw "Could not find the installed Nanoc gem files under docs-site/vendor/bundle."
    }

    $coreContent = Get-Content -LiteralPath $coreFile.FullName -Raw
    if ($coreContent -notmatch "when 'nanoc-core'") {
        $coreContent = $coreContent -replace "when 'version'\r?\n\s+'VERSION'", "when 'version'`r`n      'VERSION'`r`n    when 'nanoc-core'`r`n      'Nanoc'"
    }
    if ($coreContent -notmatch "nanoc_core_entrypoint =") {
        $coreContent = $coreContent -replace 'loader\.ignore\("#\{__dir__\}/\.\./nanoc-core\.rb"\)', "nanoc_core_entrypoint = File.expand_path('../nanoc-core.rb', __dir__)`r`nloader.ignore(nanoc_core_entrypoint)`r`nloader.ignore(nanoc_core_entrypoint.tr('\\', '/'))"
    }
    if ($coreContent -notmatch "core_ext_dir =") {
        $coreContent = $coreContent -replace 'loader\.ignore\("#\{__dir__\}/core/core_ext"\)', "core_ext_dir = File.expand_path('core/core_ext', __dir__)`r`nloader.ignore(core_ext_dir)`r`nloader.ignore(core_ext_dir.tr('\\', '/'))`r`nDir[File.join(core_ext_dir, '*.rb')].each do |core_ext_file|`r`n  loader.ignore(core_ext_file)`r`n  loader.ignore(core_ext_file.tr('\\', '/'))`r`nend"
    }
    $coreContent = $coreContent -replace "\r?\nloader\.eager_load", "`r`n# Disabled locally for Windows/Ruby 3.4: eager_load expects core_ext files to define constants."
    Update-FileIfChanged -Path $coreFile.FullName -Content $coreContent

    $cliContent = Get-Content -LiteralPath $cliFile.FullName -Raw
    if ($cliContent -notmatch "when 'nanoc-cli'") {
        $cliContent = $cliContent -replace "when 'version', 'cli', 'utf8'\r?\n\s+basename\.upcase", "when 'version', 'cli', 'utf8'`r`n      basename.upcase`r`n    when 'nanoc-cli'`r`n      'Nanoc'"
    }
    if ($cliContent -notmatch "basename\.split\('-'\)") {
        $cliContent = $cliContent -replace "\r?\n\s+super\r?\n\s+end\r?\n\s+end\r?\nend", "`r`n      return basename.split('-').map(&:capitalize).join if basename.include?('-')`r`n`r`n      super`r`n    end`r`n  end`r`nend"
    }
    if ($cliContent -notmatch "nanoc_cli_entrypoint =") {
        $cliContent = $cliContent -replace 'loader\.ignore\("#\{__dir__\}/\.\./nanoc-cli\.rb"\)', "nanoc_cli_entrypoint = File.expand_path('../nanoc-cli.rb', __dir__)`r`nloader.ignore(nanoc_cli_entrypoint)`r`nloader.ignore(nanoc_cli_entrypoint.tr('\\', '/'))"
    }
    if ($cliContent -notmatch "commands_dir =") {
        $cliContent = $cliContent -replace 'loader\.ignore\("#\{__dir__\}/cli/commands"\)', "commands_dir = File.expand_path('cli/commands', __dir__)`r`nloader.ignore(commands_dir)`r`nloader.ignore(commands_dir.tr('\\', '/'))`r`nloader.ignore(`"#{__dir__}/cli/commands/*.rb`")`r`nDir[File.join(commands_dir, '*.rb')].each do |command_file|`r`n  loader.ignore(command_file)`r`n  loader.ignore(command_file.tr('\\', '/'))`r`nend"
    }
    $cliContent = $cliContent -replace "\r?\nloader\.eager_load", "`r`n# Disabled locally for Windows/Ruby 3.4: command files are loaded explicitly."
    Update-FileIfChanged -Path $cliFile.FullName -Content $cliContent

    $deployingContent = Get-Content -LiteralPath $deployingFile.FullName -Raw
    $deployingContent = $deployingContent -replace "  Nanoc::CLI::Commands::ShowPlugins\.add_plugin_class\(Nanoc::Deploying::Deployer, 'Deployers'\)", "  # Disabled locally for Windows/Ruby 3.4: this can autoload show-plugins outside Cri's command DSL."
    Update-FileIfChanged -Path $deployingFile.FullName -Content $deployingContent
}

& (Join-Path $PSScriptRoot "generate-feature-pages.ps1")
& (Join-Path $PSScriptRoot "copy-business-domain-pages.ps1")
& (Join-Path $PSScriptRoot "copy-information-pages.ps1")
& (Join-Path $PSScriptRoot "generate-vocabulary-pages.ps1")
& (Join-Path $PSScriptRoot "generate-taxonomy-pages.ps1")
& (Join-Path $PSScriptRoot "generate-shacl-rules-page.ps1")
& (Join-Path $PSScriptRoot "generate-data-quality-rules-page.ps1")
& (Join-Path $PSScriptRoot "generate-establishment-type-rules-page.ps1")
& (Join-Path $PSScriptRoot "copy-model-pages.ps1")

Push-Location $docsSiteRoot
try {
    Invoke-Native -Description "Bundler configuration" -Command { bundle config set path vendor/bundle }
    Invoke-Native -Description "Bundler jobs configuration" -Command { bundle config set jobs 1 }

    if (-not $SkipBundleInstall) {
        Invoke-Native -Description "Bundler install" -Command { bundle install --full-index }
    }

    if ($isWindowsRuntime) {
        Set-NanocWindowsCompatibility

        $nanocCommand = Join-Path $docsSiteRoot "vendor/bundle/ruby/3.4.0/bin/nanoc"
        if (-not (Test-Path -LiteralPath $nanocCommand)) {
            throw "Nanoc binstub was not found at $nanocCommand. Run without -SkipBundleInstall first."
        }

        Invoke-Native -Description "Nanoc compile" -Command { ruby $nanocCommand compile }
    }
    else {
        Invoke-Native -Description "Nanoc compile" -Command { bundle exec nanoc compile }
    }

    & (Join-Path $PSScriptRoot "copy-information-assets.ps1")
}
finally {
    Pop-Location
}
