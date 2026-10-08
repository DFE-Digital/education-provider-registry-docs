<#
.SYNOPSIS
Adds the bounded T14R external-sponsor case to the existing local database.
.DESCRIPTION
Uses reader and EPR_BAU_SQL_PASSWORD. Preflights both source links, tests both
import orders in rollback transactions, then loads the sponsor/trust slice
atomically and validates reverse-order reimport. Does not rebuild schemas,
change the default fixture selection or refresh checked-in SQL seeds.
#>
[CmdletBinding()]
param([string]$SqlServer='SL646104')
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'EprLocalAutomation/EprLocalAutomation.psm1') -Force
if (-not $env:EPR_BAU_SQL_PASSWORD) {
    $env:EPR_BAU_SQL_PASSWORD=[Environment]::GetEnvironmentVariable('EPR_BAU_SQL_PASSWORD','User')
}
if (-not $env:EPR_BAU_SQL_PASSWORD) { throw 'EPR_BAU_SQL_PASSWORD is required.' }
$source=New-BauSource -SqlServer $SqlServer -SqlUser reader
$target=New-PostgresTarget -PostgresHost localhost
$workspace=New-RunWorkspace
try {
    & (Get-Module EprLocalAutomation) {
        param($source,$target,$workspace)
        $loader=Get-Content -LiteralPath (Get-SchemaPath 'establishment/load/load-academy-trust-responsibility-fixture.sql') -Raw
        $projections=@{}
        foreach ($group in @(2904,2905)) {
            $csv=Join-Path $workspace "t14r-$group.csv"
            $null=Export-BauQueryToCsv -Source $source `
                -SqlFile (Get-SchemaPath 'establishment/transforms/academy-trust-responsibility-from-bau.sql') `
                -Variables @{URN=139844;GROUP_ID=$group;INCLUDE_ARCHIVED=0} `
                -CsvPath $csv -RowCount ExactlyOne -Description "T14R source group $group preflight"
            $sql=$loader.Replace('__FIXTURE_PATH__',($csv -replace '\\','/'))
            $sql=[regex]::Replace($sql,'(?m)^(BEGIN|COMMIT);\r?$','')
            # Both source rows use the actual loader in the same transaction.
            # Drop only its temporary input/context tables between invocations.
            $projections[$group]=$sql + "`nDROP TABLE pg_temp.establishment_party_role_fixture,pg_temp.migration_context;`n"
        }
        $preservedSql="SELECT coalesce(string_agg(urn::text,',' ORDER BY urn),'') FROM establishment.establishment WHERE urn<>139844;"
        $before=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Existing scope check failed'
        Import-EstablishmentFromBau -Source $source -Target $target -Urn 139844 -WorkingDirectory $workspace
        $validation=Get-SchemaPath 'establishment/validate-t14r-external-sponsor.sql'
        $validationSql=Get-Content -LiteralPath $validation -Raw
        foreach ($order in @('sponsor-first','trust-first')) {
            $groups=@(2904,2905)
            if ($order -eq 'trust-first') { $groups=@(2905,2904) }
            $probe="BEGIN;`n" + $projections[$groups[0]] + $projections[$groups[1]] + $validationSql + "`nROLLBACK;"
            $path=Join-Path $workspace "t14r-$order.sql"
            [System.IO.File]::WriteAllText($path,$probe,[System.Text.UTF8Encoding]::new($false))
            Invoke-Psql -Target $target -File $path -FailureMessage "T14R $order probe failed"
        }
        $loadPath=Join-Path $workspace 't14r-load.sql'
        $loadSql="BEGIN;`n" + $projections[2904] + $projections[2905] + $validationSql + "`nCOMMIT;"
        [System.IO.File]::WriteAllText($loadPath,$loadSql,[System.Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $target -File $loadPath -FailureMessage 'T14R atomic responsibility load failed'
        $stateSql=@'
SELECT json_build_object(
 'parties',(SELECT string_agg(legal_entity_id::text,',' ORDER BY legal_entity_id) FROM establishment.legal_entity),
 'roles',(SELECT string_agg(establishment_party_role_id::text,',' ORDER BY establishment_party_role_id) FROM establishment.establishment_party_role),
 'responsibilities',(SELECT string_agg(establishment_responsibility_id::text,',' ORDER BY establishment_responsibility_id) FROM establishment.establishment_responsibility),
 'identifiers',(SELECT count(*) FROM establishment.organisation_identifier)+(SELECT count(*) FROM establishment.group_identifier),
 'classifications',(SELECT count(*) FROM establishment.academy_trust_classification))::text;
'@
        $first=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T14R state check failed'
        Import-EstablishmentFromBau -Source $source -Target $target -Urn 139844 -WorkingDirectory $workspace
        $repeatSql="BEGIN;`n" + $projections[2905] + $projections[2904] + $validationSql + "`nCOMMIT;"
        [System.IO.File]::WriteAllText($loadPath,$repeatSql,[System.Text.UTF8Encoding]::new($false))
        Invoke-Psql -Target $target -File $loadPath -FailureMessage 'T14R reverse-order reimport failed'
        $second=Invoke-Psql -Target $target -Command $stateSql -Output Scalar -FailureMessage 'T14R repeated state check failed'
        if ($first -cne $second) { throw 'T14R reimport changed business identities or counts.' }
        # An unknown source UID with the same sponsor name still requires review.
        $collisionInsert=@'
INSERT INTO establishment_party_role_fixture (
 legal_entity_name,group_uid,establishment_party_role_type,responsibility_type,
 is_current,establishment_urn,responsibility_start_date,responsibility_is_current
) VALUES ('Diocese of Ely','T14R_UNREVIEWED','School sponsor','Sponsored by',
          true,139844,DATE '2013-07-01',true);
'@
        $collision=[regex]::Replace($loader,'(?m)^\\copy[^\r\n]*',
            [System.Text.RegularExpressions.MatchEvaluator]{param($match) $collisionInsert})
        $collision=[regex]::Replace($collision,'(?m)^COMMIT;','ROLLBACK;')
        $path=Join-Path $workspace 't14r-unreviewed-name.sql'
        [System.IO.File]::WriteAllText($path,$collision,[System.Text.UTF8Encoding]::new($false))
        $psql=Get-PostgresClientPath -Tool psql
        $arguments=Get-PsqlArgumentList -Target $target -File $path -Output Scalar
        $result=Invoke-WithPostgresPassword -Target $target -ScriptBlock {
            $previousPreference=$ErrorActionPreference
            try {
                $ErrorActionPreference='Continue'
                $messages=(& $psql @arguments 2>&1 | ForEach-Object { $_.ToString() } | Out-String)
                [pscustomobject]@{ExitCode=$LASTEXITCODE;Messages=$messages}
            }
            finally { $ErrorActionPreference=$previousPreference }
        }
        if ($result.ExitCode -eq 0 -or $result.Messages -notlike '*only a name match; identity review required*') {
            throw "T14R unreviewed name match was not rejected: $($result.Messages)"
        }
        $after=Invoke-Psql -Target $target -Command $preservedSql -Output Scalar -FailureMessage 'Preserved scope check failed'
        if ($before -cne $after) { throw 'T14R changed unrelated establishment scope.' }
        Invoke-Psql -Target $target -File $validation -FailureMessage 'Final T14R validation failed'
        Write-Host 'T14R migrated and validated; both orders retain separate parties, reimport is stable and name-only matches require review.'
    } $source $target $workspace
}
finally {
    $resolvedWorkspace=[System.IO.Path]::GetFullPath($workspace)
    $tempRoot=[System.IO.Path]::GetFullPath([System.IO.Path]::GetTempPath())
    if (-not $resolvedWorkspace.StartsWith($tempRoot,[StringComparison]::OrdinalIgnoreCase) -or
        (Split-Path -Leaf $resolvedWorkspace) -notlike 'epr-local-run-*') {
        throw 'Refusing cleanup outside the migration temporary directory.'
    }
    Remove-RunWorkspace -Path $resolvedWorkspace
}
