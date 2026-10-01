# Rebuild Establishment From Local BAU

## Purpose

This is the BAU-source rebuild. It rebuilds the local PostgreSQL Establishment schema and
migrates the selected establishment-centric records from the approved local
BAU SQL Server copy. The selection is read from
models/schema/seed/fixture-selection.json.

## Prerequisites

- Local SQL Server copy gias_bau_test_local, with a read-only reader login.
- The selected establishment-centric BAU tables, including
  dbo.Establishment and any required child tables, plus dbo.LSOA and dbo.MSOA
  for the geographic reference-data load.
- Local PostgreSQL database establishment_local.
- PostgreSQL credentials available through pgpass.conf.

The script never connects to BAU Test, shared, staging or production systems.

## How to run

From education-provider-registry-docs, using the local SQL reader login:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1"

The command prompts once for the local SQL Server reader password, unless
EPR_BAU_SQL_PASSWORD is set. Use -KeepFixture to retain the run's working folder of
extracted CSV fixtures for troubleshooting.

When the local BAU copy is configured for Windows authentication:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer SL646104 -UseWindowsAuthentication

After validation succeeds, the command exports the target into the run's
working folder and copies the reference and establishment seed files into
`models/schema/seed/`. It does not commit those file changes; review them with
`git diff` before committing. To export somewhere else for review without
touching `seed/`, supply `-ExportDirectory`.

## Execution flow

1. Check that the SQL Server source and PostgreSQL target are local.
2. Recreate the establishment and migration schemas, and load the checked-in reference seeds (`Initialize-EstablishmentDatabase`).
3. Load geographic reference data from the local BAU copy (`Import-GeographicReferenceData`): local authorities, Government Office Regions, districts, wards, parliamentary constituencies, LSOAs, MSOAs, urban/rural classifications, GSS local-authority codes, and the local-authority to GSS and GOR mappings.
4. Load each selected URN (`Import-EstablishmentFromBau`), then each selected group link (`Import-EstablishmentPartyRoleFromBau`).
5. Print the loaded establishments with their pupil and free-school-meal measures (`Show-EstablishmentSummary`).
6. Run all establishment tests (`Invoke-EstablishmentTests`): core validation, groups validation, an approval snapshot per selected URN, and scope.
7. Export the database and refresh the checked-in seed files (`Export-EstablishmentFixture`, `Update-CheckedInSeed`).
8. With `-IncludeGovernance`, recreate the governance schema and load each URN's governance appointments.
9. Delete the run's working folder, unless `-KeepFixture` is supplied.

After the run, add or update one establishment case file under `models/schema/establishment/cases/` for every T represented by the extract. Include its URN, name, establishment type and relevant group links.

Each numbered step is a function in the `EprLocalAutomation` module, and can be run on its own. See the [automation README](README.md).

Reference dictionaries are runtime inputs only for this current implementation;
the target schema and checked-in seed remain the shared baseline for the
checked-in-fixture rebuild.

## Scope boundary

By default this command migrates Establishment-owned data for the selected
URNs. It rebuilds the Governance schema and migrates StaffRecord only when
`-IncludeGovernance` is supplied.
