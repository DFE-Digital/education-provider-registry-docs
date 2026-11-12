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

The default fixture, `seed/seed-establishment-fixture.sql`, loads the three
sanity establishments: URNs 100018, 109613 and 137603. Select a different set
with repeated -SeedFile arguments only when deliberately extending the scope.

## Execution flow

1. Validate the local PostgreSQL target.
2. Rebuild the disposable establishment schema.
3. Load the shared checked-in reference/static fixture seed.
4. Load the checked-in Establishment fixture and its migration evidence.
5. Fail fast on SQL errors.

The command then runs all establishment tests (`Invoke-EstablishmentTests`):
core validation, an approval snapshot per selected URN, and scope. It fails if any physical Establishment table is empty, if the checked-in
reference seed is incomplete, or if an Establishment child slice has not been
captured. Each step is a function in the `EprLocalAutomation` module and can be
run on its own; see the [automation README](README.md).

The fixture files are repository data, not a live BAU source. Their provenance,
selected URNs and any sanitisation or synthetic values must be recorded when
they are regenerated from the BAU-source rebuild.

The fixture includes 13 current SEN lookup values and the selected establishments' SEN associations, with no target archive column. SEN loader regression checks run as part of core validation. The shared maintenance observation file is scoped to the establishments actually restored, with exactly one observation required per selected URN; a larger stored observation set does not expand the fixture selection.
