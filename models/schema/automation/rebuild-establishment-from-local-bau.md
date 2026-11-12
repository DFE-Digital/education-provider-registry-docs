# Rebuild Establishment From Local BAU

## Purpose

This is the BAU-source rebuild. It rebuilds the local PostgreSQL Establishment schema and
migrates the selected establishment-centric records from the approved local
BAU SQL Server copy. The selection defaults to
models/schema/seed/fixture-selection.json. `-SelectionFile` selects a separate
curated JSON file without changing the repository's fixture manifest. For a
URN-only selection, group links are discovered automatically. Alternatively
supply the URNs directly with `-Urn`.

## Prerequisites

- Local SQL Server BAU copy, with a read-only login. The default database is
  `gias_bau_test_local`; a custom name must end `_local` and use only letters,
  digits and underscores.
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

```powershell
$bauSqlServer = 'localhost' # Your local machine name or named instance.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer $bauSqlServer -UseWindowsAuthentication
```

The local-only source guard recognises the current developer's machine name,
loopback aliases and local named instances such as `localhost\SQLEXPRESS`.
Remote/shared servers remain blocked.

For the default selection with tests enabled, after validation succeeds the command exports the target into the run's
working folder and copies the reference, establishment and migration-evidence seed files into
`models/schema/seed/`. It does not commit those file changes; review them with
`git diff` before committing. To export somewhere else for review without
touching `seed/`, supply `-ExportDirectory`.

## Your own URNs without the checked-in tests

Use the [schema README's curation instructions](../README.md#using-a-different-bau-dataset-and-your-own-urns)
to choose establishments in your local BAU dataset. No manual group list is
needed for URN-only discovery. The checked-in tests include per-URN approval
snapshots, which exist only for the default selection.

```powershell
$bauSqlServer = 'localhost'
$bauDatabase = 'gias_bau_test_local' # Or another local BAU copy named *_local.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer $bauSqlServer -SourceDatabase $bauDatabase -Urn "109443,20338" -SkipTests
```

`-SkipTests` skips `Invoke-EstablishmentTests`, not the import's SQL checks,
selection validation or database constraints. Migration-run notes record that
tests were skipped. Existing local target data is still replaced.

Custom selections and skipped-test runs do not automatically export or refresh
`seed/`. For a separate export, add
`-ExportDirectory "$env:TEMP\epr-my-fixture-export"`. Approval snapshots are not
updated by this command. The default selection and normal tested rebuild are
unchanged.

The quoted comma-separated list works with `powershell.exe -File`. A JSON
file with only `organisationType` and `urns` works with `-SelectionFile` instead.
Only memberships for supplied URNs are imported; the other group members are
not added. Evidence notes mark these group extracts as partial. Current group
links are the default; `-IncludeArchivedLinks` additionally selects archived
party links, not historical federation/children's-centre memberships. Unsupported
or conflicting source evidence still requires review.

## Execution flow

1. Check that the SQL Server source and PostgreSQL target are local.
   For a URN-only selection, discover and validate supported group links before
   the target is recreated (`Find-EstablishmentGroupsFromBau`).
2. Recreate the establishment and migration schemas, and load the checked-in reference seeds (`Initialize-EstablishmentDatabase`).
3. Load geographic reference data from the local BAU copy (`Import-GeographicReferenceData`): local authorities, Government Office Regions, districts, wards, parliamentary constituencies, LSOAs, MSOAs, urban/rural classifications, GSS local-authority codes, and the local-authority to GSS and GOR mappings.
4. Load each selected URN (`Import-EstablishmentFromBau`), then each selected group link (`Import-EstablishmentPartyRoleFromBau`) and organisation group.
5. Print the loaded establishments with their pupil and free-school-meal measures (`Show-EstablishmentSummary`).
6. Run all establishment tests (`Invoke-EstablishmentTests`), unless `-SkipTests` is supplied: core validation, an approval snapshot per selected URN, and scope.
7. Export the database and refresh the checked-in seed files for the default tested selection (`Export-EstablishmentFixture`, `Update-CheckedInSeed`). Custom selections/skipped-test runs export only when `-ExportDirectory` is supplied and do not automatically refresh `seed/`.
8. With `-IncludeGovernance`, recreate the governance schema and load each URN's governance appointments.
9. Delete the run's working folder, unless `-KeepFixture` is supplied.

Each numbered step is a function in the `EprLocalAutomation` module, and can be run on its own. See the [automation README](README.md).

Each BAU establishment rebuild creates one `migration.migration_run` for its group evidence. Every selected party-link extract retains its own `source_snapshot` and `source_record` beneath that run, so source-level lineage is unchanged. The run is `running` during import and testing, `completed` after the Establishment import and any enabled tests succeed, or `failed` if that workflow fails. When `-SkipTests` is used, notes distinguish a completed untested import from an approval-validated fixture. The source database name is recorded from the connection settings. An independently invoked party-link loader, without a rebuild run ID, still creates a separate mini-migration run. A checked-in SQL rebuild restores the captured run rather than claiming that a fresh BAU extraction took place.

Reference dictionaries are runtime inputs only for this current implementation;
the target schema and checked-in seed remain the shared baseline for the
checked-in-fixture rebuild.

## Scope boundary

By default this command migrates Establishment-owned data for the selected
URNs. It rebuilds the Governance schema and migrates StaffRecord only when
`-IncludeGovernance` is supplied.
