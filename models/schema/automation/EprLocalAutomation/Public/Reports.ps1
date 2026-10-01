# Read-only reports for checking a run by eye. They print results and change
# nothing.

function Show-EstablishmentSummary {
    <#
    .SYNOPSIS
    Prints each loaded establishment with its pupil count and free-school-meal
    measure.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][int[]]$Urn
    )

    Write-Step 'Establishment summary'
    $urnList = ($Urn | ForEach-Object { [string][int]$_ }) -join ', '
    Invoke-Psql -Target $Target -FailureMessage 'Establishment summary query failed' -Command @"
SELECT e.urn, e.name, m.pupil_count, m.free_school_meal_measure
FROM establishment.establishment AS e
LEFT JOIN establishment.capacity_and_pupil_measures AS m ON m.establishment_id = e.establishment_id
WHERE e.urn IN ($urnList)
ORDER BY e.urn;
"@
}

function Show-GovernanceSummary {
    <#
    .SYNOPSIS
    Prints governance appointment, term and office-holder counts per establishment.
    #>
    param(
        [Parameter(Mandatory)]$Target,
        [Parameter(Mandatory)][int[]]$Urn
    )

    Write-Step 'Governance summary'
    $urnList = ($Urn | ForEach-Object { [string][int]$_ }) -join ', '
    Invoke-Psql -Target $Target -FailureMessage 'Governance summary query failed' -Command @"
SELECT appointment.establishment_urn,
       COUNT(*) AS governance_appointment_count,
       COUNT(appointment.governance_role_type_id) AS mapped_role_type_count,
       COUNT(term.term_of_office_id) AS term_of_office_count,
       COUNT(term.start_date) AS term_start_date_count,
       COUNT(term.end_date) AS term_end_date_count,
       COUNT(office.office_holder_assignment_id) AS office_holder_assignment_count
FROM governance.governance_appointment AS appointment
LEFT JOIN governance.term_of_office AS term ON term.governance_appointment_id = appointment.governance_appointment_id
LEFT JOIN governance.office_holder_assignment AS office ON office.governance_appointment_id = appointment.governance_appointment_id
WHERE appointment.establishment_urn IN ($urnList)
GROUP BY appointment.establishment_urn
ORDER BY appointment.establishment_urn;
"@
}

function Get-GovernanceSourceCoverage {
    <#
    .SYNOPSIS
    Reports how many governance appointments the local BAU copy holds for the
    given establishments, and their role codes. Returns counts and role labels
    only, never names or other personal data.
    #>
    param(
        [Parameter(Mandatory)]$Source,
        [Parameter(Mandatory)][int[]]$Urn
    )

    $urnList = ($Urn | ForEach-Object {
        if ($_ -le 0) { throw "URN must be positive: $_" }
        [string][int]$_
    }) -join ', '

    $currentAppointment = @'
sr.status = 1
         AND ISNULL(sr.deleted, 0) = 0
         AND ISNULL(sr.forcedArchived, 0) = 0
         AND (sr.stepdownDate IS NULL OR CAST(sr.stepdownDate AS date) >= @today)
'@
    $query = @"
DECLARE @today date = CAST(GETDATE() AS date);

SELECT sr.establishment_URN AS urn,
       COUNT(*) AS source_appointment_count,
       SUM(CASE WHEN $currentAppointment THEN 1 ELSE 0 END) AS current_appointment_count,
       COUNT(DISTINCT CASE WHEN $currentAppointment THEN sr.staffRole_code END) AS current_role_type_count
FROM dbo.StaffRecord sr
WHERE sr.establishment_URN IN ($urnList)
GROUP BY sr.establishment_URN
ORDER BY sr.establishment_URN;

SELECT sr.establishment_URN AS urn,
       sr.staffRole_code AS source_role_code,
       role.name AS source_role_name,
       COUNT(*) AS current_appointment_count
FROM dbo.StaffRecord sr
LEFT JOIN dbo.StaffRole role ON role.code = sr.staffRole_code
WHERE sr.establishment_URN IN ($urnList)
  AND $currentAppointment
GROUP BY sr.establishment_URN, sr.staffRole_code, role.name
ORDER BY sr.establishment_URN, sr.staffRole_code;
"@

    $connection = $null; $command = $null; $reader = $null
    try {
        $connection = Open-BauConnection -Source $Source

        $missing = @(foreach ($table in @('dbo.StaffRecord', 'dbo.StaffRole')) {
            $check = $connection.CreateCommand()
            $check.CommandText = "SELECT OBJECT_ID(N'$table', N'U')"
            $exists = $check.ExecuteScalar()
            $check.Dispose()
            if ($exists -is [System.DBNull] -or $null -eq $exists) { $table }
        })
        if ($missing.Count -gt 0) {
            throw "The local source copy is missing: $($missing -join ', '). Copy the selected StaffRecord rows and the StaffRole lookup from BAU Test into gias_bau_test_local, then rerun this read-only check. Automation must not connect directly to BAU Test."
        }

        $command = $connection.CreateCommand()
        $command.CommandText = $query
        $reader = $command.ExecuteReader()
        $summary = [System.Data.DataTable]::new()
        $summary.Load($reader)
        $roles = [System.Data.DataTable]::new()
        $roles.Load($reader)

        Write-Output 'Governance appointment coverage'
        $summary | Format-Table -AutoSize | Out-String | Write-Output
        Write-Output 'Current appointment role distribution'
        $roles | Format-Table -AutoSize | Out-String | Write-Output
    }
    finally {
        if ($reader) { $reader.Dispose() }
        if ($command) { $command.Dispose() }
        if ($connection) { $connection.Dispose() }
    }
}
