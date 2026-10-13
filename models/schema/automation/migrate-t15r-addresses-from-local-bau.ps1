<#
.SYNOPSIS
Migrates reviewed T15R closed-SAT address observations through the shared loader.
.DESCRIPTION
Case-specific scope and decisions are held in the reviewed JSON fixture.
Requires the corresponding case's parties to have been loaded first.
#>
[CmdletBinding()]
param([string]$SqlServer='SL646104',$BauSource,$PostgresTarget)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1')
if(-not $env:EPR_BAU_SQL_PASSWORD){$env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')}
if(-not $BauSource -and -not $env:EPR_BAU_SQL_PASSWORD){throw 'EPR_BAU_SQL_PASSWORD is required.'}
$source=if($BauSource){$BauSource}else{New-BauSource -SqlServer $SqlServer -SqlUser reader}
$target=if($PostgresTarget){$PostgresTarget}else{New-PostgresTarget -PostgresHost localhost}
$workspace=New-RunWorkspace
try { & (Get-Module EprLocalAutomation) { param($source,$target,$workspace) Invoke-ReviewedGroupAddressMigration -Source $source -Target $target -Workspace $workspace -FixtureFile 'seed/fixtures/t15r-group-addresses.json' } $source $target $workspace }
finally { $resolved=[System.IO.Path]::GetFullPath($workspace); $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath()); if(-not $resolved.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or (Split-Path -Leaf $resolved) -notlike 'epr-local-run-*'){throw 'Refusing cleanup outside the migration temporary directory.'}; Remove-RunWorkspace -Path $resolved }
