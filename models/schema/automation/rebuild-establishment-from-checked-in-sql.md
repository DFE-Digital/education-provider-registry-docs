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

The default exported fixture loads T1 Co-op Academy Stoke-On-Trent, URN
136102, and T2 St Mary Magdalene Academy, URN 134314. The exporter currently
retains the legacy filename `seed-t1-establishment-136102.sql`, but the file is
the dependency-ordered export of the complete selected establishment set.
Select a different set with repeated -SeedFile arguments only when deliberately
extending the migration scope.

## Execution flow

1. Validate the local PostgreSQL target.
2. Rebuild the disposable establishment schema.
3. Load the shared checked-in reference/static fixture seed.
4. Load the combined Establishment-owned sample SQL file for T1 and T2.
5. Fail fast on SQL errors.

The command also runs the shared validation SQL. It fails if any physical
Establishment table is empty, if the checked-in reference seed is incomplete,
or if an Establishment child slice has not been captured.

The fixture files are repository data, not a live BAU source. Their provenance,
selected URNs and any sanitisation or synthetic values must be recorded when
they are regenerated from the BAU-source rebuild.
