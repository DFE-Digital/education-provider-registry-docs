# Rebuild Establishment From Checked-in SQL

## Purpose

This is the checked-in-fixture rebuild. It rebuilds the local PostgreSQL Establishment schema and
loads the reviewed, checked-in sample Establishment SQL fixtures. It requires
no SQL Server database, BAU credentials or source extract.

## Prerequisites

- Local PostgreSQL database establishment_local.
- PostgreSQL credentials available through pgpass.conf.
- The checked-in files under models/schema/seed/.

## How to run

From education-provider-registry-docs:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-checked-in-sql.ps1"

The default set loads the four reviewed sample fixtures. Select a different
set with repeated -SeedFile arguments, using filenames from models/schema/seed.
After refreshing fixtures from the BAU-source rebuild, include the generated
seed-establishment-fixture.sql in the checked-in seed set and update the
default list if the fixture selection changes.

## Execution flow

1. Validate the local PostgreSQL target.
2. Rebuild the disposable establishment schema.
3. Load the shared checked-in reference/static fixture seed.
4. Load the selected Establishment-owned sample SQL files.
5. Fail fast on SQL errors.

The command also runs the shared validation SQL. It fails if any physical
Establishment table is empty, if the checked-in reference seed is incomplete,
or if an Establishment child slice has not been captured.

The fixture files are repository data, not a live BAU source. Their provenance,
selected URNs and any sanitisation or synthetic values must be recorded when
they are regenerated from the BAU-source rebuild.
