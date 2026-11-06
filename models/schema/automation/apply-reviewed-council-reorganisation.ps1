<# Apply one explicitly reviewed council event to the guarded local target. #>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$DecisionFile,
      [string]$PostgresHost='127.0.0.1',[int]$PostgresPort=5432,
      [string]$PostgresDatabase='establishment_local',[string]$PostgresUser='postgres',
      [string]$PostgresPassword=$env:PGPASSWORD)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
$target=New-PostgresTarget -PostgresHost $PostgresHost -Port $PostgresPort -Database $PostgresDatabase -User $PostgresUser -Password $PostgresPassword
$json=[IO.File]::ReadAllText((Resolve-Path -LiteralPath $DecisionFile).Path)
$null=$json|ConvertFrom-Json
$sql="BEGIN; SELECT migration.apply_council_reorganisation('"+$json.Replace("'","''")+"'::jsonb) AS event_status; SET CONSTRAINTS ALL IMMEDIATE; COMMIT;"
& (Get-Module EprLocalAutomation) {param($t,$s)
    Invoke-Psql -Target $t -Command $s -FailureMessage 'Reviewed council event failed; transaction rolled back'
} $target $sql
