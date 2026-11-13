# Starts the Published Establishment API demo on http://localhost:5080.
# Pass -Port to use a different port.
param(
    [int] $Port = 5080
)

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    throw 'The .NET 10 SDK is not installed. Install it from https://dotnet.microsoft.com/download/dotnet/10.0'
}

$env:Urls = "http://localhost:$Port"
dotnet run --configuration Release
