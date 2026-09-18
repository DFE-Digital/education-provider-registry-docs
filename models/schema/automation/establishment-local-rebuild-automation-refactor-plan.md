# Establishment Local Rebuild Automation Refactor Plan

## Status

The two explicit Establishment rebuild paths and their runbooks are
implemented. Complete checked-in fixture capture remains dependent on a
successful local BAU extraction.

## Rebuild paths

### BAU-source rebuild

rebuild-establishment-from-local-bau.ps1 rebuilds the local PostgreSQL
Establishment schema, loads reference data, extracts the selected
establishment-centric BAU records, and validates the result. It can export
the populated local target for review using -ExportDirectory.

Runbook: rebuild-establishment-from-local-bau.md.

### Checked-in-fixture rebuild

rebuild-establishment-from-checked-in-sql.ps1 rebuilds the same schema using
only checked-in SQL. It has no SQL Server or BAU credential dependency.

Runbook: rebuild-establishment-from-checked-in-sql.md.

## Shared contract

Both paths must:

- create the same physical schema;
- load the same complete checked-in reference seed;
- load Establishment-owned rows and child data;
- validate that every physical table contains data;
- validate foreign keys and selected Establishment identifiers;
- remain restricted to local databases.

The checked-in fixture is generated from an approved BAU-source extraction,
then reviewed, minimised and sanitised. It is a repository artefact and is
replayed independently by the checked-in-fixture rebuild.

## Fixture refresh

After a successful BAU-source rebuild:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -ExportDirectory ".\models\schema\seed\generated"

Review the generated reference and Establishment SQL before replacing the
checked-in fixtures. Export is not an automatic Git commit.

## Remaining work

- Capture all reference tables in the checked-in reference seed.
- Capture contact, geography and lifecycle rows in the checked-in
  Establishment fixtures.
- Replace duplicated reference inserts in individual sample files.
- Keep the shared validation enabled in both paths.
- Run a full round trip: BAU-source rebuild, export, checked-in-fixture
  rebuild, and target comparison.
