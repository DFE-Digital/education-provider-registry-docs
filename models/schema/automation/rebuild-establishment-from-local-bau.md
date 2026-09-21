# Rebuild Establishment From Local BAU

## Purpose

This is the BAU-source rebuild. It rebuilds the local PostgreSQL Establishment schema and
migrates the selected establishment-centric records from the approved local
BAU SQL Server copy. The selection is read from
models/schema/seed/one-organisation.json.

## Prerequisites

- Local SQL Server copy gias_bau_test_local, with a read-only reader login.
- The selected establishment-centric BAU tables, including
  dbo.Establishment and any required child tables, plus dbo.LSOA and dbo.MSOA
  for the geographic reference-data load.
- Local PostgreSQL database establishment_local.
- PostgreSQL credentials available through pgpass.conf.

The script never connects to BAU Test, shared, staging or production systems.

## How to run

From education-provider-registry-docs:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1"

The command prompts once for the local SQL Server reader password. Use
-KeepFixture to retain temporary extraction files for troubleshooting.

After validation succeeds, the command automatically exports the target into
`models/schema/seed/generated/` and refreshes the checked-in reference and
Establishment seed files. It does not commit those file changes; review them
before committing.

## Execution flow

1. Validate the local SQL Server and PostgreSQL targets.
2. Rebuild the disposable establishment schema.
3. Load the checked-in reference/static fixture seed.
4. Load geographic reference data from the local BAU copy: Local Authorities,
   Government Office Regions, Districts, Wards, Parliamentary Constituencies,
   LSOAs, MSOAs, Urban/Rural classifications, GSS local-authority codes, and Local Authority to GSS/GOR
   mappings.
5. Extract and load each selected URN using the Establishment migration runner.
6. Query the loaded rows and key pupil/FSM measures as a smoke validation.
7. Run the approval tests and row-count approval.
8. Export and refresh the checked-in seed files after all validation passes.
9. Delete credentials and temporary files unless -KeepFixture is supplied.

Reference dictionaries are runtime inputs only for this current implementation;
the target schema and checked-in seed remain the shared baseline for the
checked-in-fixture rebuild.

## Scope boundary

This command migrates Establishment-owned data for the selected URNs. It does
not rebuild the Governance schema or migrate StaffRecord. Use the combined
Registry/Governance wrapper when that separate orchestration is required.
