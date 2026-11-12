# Reconcile published business codes directly with the local BAU dictionaries.
function Test-CodeListsAgainstBau {
    param([Parameter(Mandatory)]$Source, [Parameter(Mandatory)]$Target)

    $lists = @(
        @{ Target = 'establishment_type_category'; Source = 'EstablishmentTypeGroup'; CodeColumn = 'code' },
        @{ Target = 'establishment_status'; Source = 'EstablishmentStatus'; CodeColumn = 'code' },
        @{ Target = 'education_phase'; Source = 'EducationPhase'; CodeColumn = 'code' },
        @{ Target = 'reason_establishment_opened'; Source = 'ReasonEstablishmentOpened'; CodeColumn = 'code' },
        @{ Target = 'reason_establishment_closed'; Source = 'ReasonEstablishmentClosed'; CodeColumn = 'code' }
    )
    $connection = Open-BauConnection -Source $Source
    try {
        foreach ($list in $lists) {
            $command = $connection.CreateCommand()
            $command.CommandText = "SELECT code, name FROM dbo.$($list.Source)"
            $reader = $command.ExecuteReader()
            $sourceValues = [System.Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
            try {
                while ($reader.Read()) { $sourceValues.Add([string]$reader['code'], [string]$reader['name']) }
            } finally { $reader.Dispose(); $command.Dispose() }
            $targetRows = @(ConvertFrom-Csv (Invoke-Psql -Target $Target -Output Csv `
                -Command "SELECT $($list.CodeColumn)::text AS code,name FROM establishment.$($list.Target) ORDER BY $($list.CodeColumn);" `
                -FailureMessage 'Code-list target lookup failed'))
            if ($targetRows.Count -eq 0) { throw "Empty target code list: $($list.Target)" }
            foreach ($row in $targetRows) {
                if (-not $sourceValues.ContainsKey($row.code) -or $sourceValues[$row.code] -cne $row.name) {
                    throw "BAU/target code or label mismatch for $($list.Target), code '$($row.code)'."
                }
            }
            Write-Host "    $($list.Target): $($targetRows.Count) exact BAU code/name mappings."
        }
        $command = $connection.CreateCommand()
        $command.CommandText = 'SELECT code,group_code FROM dbo.EstablishmentType'
        $reader = $command.ExecuteReader()
        $sourceGroups = [System.Collections.Generic.Dictionary[string,string]]::new([StringComparer]::Ordinal)
        try { while ($reader.Read()) { $sourceGroups.Add([string]$reader['code'], [string]$reader['group_code']) } }
        finally { $reader.Dispose(); $command.Dispose() }
        $types = @(ConvertFrom-Csv (Invoke-Psql -Target $Target -Output Csv -Command @'
SELECT t.code,c.code::text AS group_code FROM establishment.establishment_type t
JOIN establishment.establishment_type_category c USING(establishment_type_category_id) ORDER BY t.code;
'@ -FailureMessage 'Type/group code lookup failed'))
        foreach ($type in $types) {
            if (-not $sourceGroups.ContainsKey($type.code) -or $sourceGroups[$type.code] -cne $type.group_code) {
                throw "BAU/target type-group mismatch for type '$($type.code)'."
            }
        }
        Write-Host "    $($types.Count) exact BAU detailed-type/group-code mappings."
    } finally { $connection.Dispose() }
}
