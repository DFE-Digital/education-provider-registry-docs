# Local automation

The two entry points serve different purposes:

| Command | Purpose |
| --- | --- |
| [rebuild-establishment-from-local-bau.ps1](rebuild-establishment-from-local-bau.ps1) | Seed establishments and lossy current relationships for development; skip and log rows that do not fit the model. |
| [rebuild-establishment-from-checked-in-sql.ps1](rebuild-establishment-from-checked-in-sql.ps1) | Restore the reviewed checked-in fixture and run its database validation and approval tests. |

Both use the `EprLocalAutomation` PowerShell module and local-only connection guards.

## BAU development seed

From `education-provider-registry-docs`:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer $bauSqlServer
```

The source selection includes status codes `1`, `2` and `3`. Reference and
geographic data load first. Core establishments are extracted once and loaded
in batches. A failed batch rolls back and splits until individual failed
establishments can be skipped and logged. Current party, group, maintenance and
SEN relationships then load only for successful establishments; invalid
relationship rows are logged and skipped. Governance does not run. Model
constraints remain intact.

```sql
SELECT urn, sqlstate, error_message
FROM migration.establishment_load_error
ORDER BY urn;
```

See the [development seed runbook](rebuild-establishment-from-local-bau.md)
for selection options, error details, run totals and exports.

## Checked-in fixture

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-checked-in-sql.ps1"
```

This path restores the existing fixture, including its captured relationships
and evidence, without reading BAU. See the [checked-in SQL runbook](rebuild-establishment-from-checked-in-sql.md).

## Implementation

- `Public/DevelopmentSeed.ps1` prepares the development extract and composes the
  explicit workspace and batch SQL files in `migration/`.
- `migration/load-development-establishment-seed.sql` splits failed batches and
  records isolated errors in `migration.establishment_load_error`.
- `migration/prepare-development-establishments.sql` creates reusable staging
  workspaces; `migration/apply-development-establishment-batch.sql` contains the
  explicit core inserts and casts. Batch retries reuse those workspaces.
- `Public/DevelopmentRun.ps1` creates and completes the shared run on behalf of
  the BAU entry point; phase loaders do not reopen or complete it.
- Relationship CSVs are copied directly into PostgreSQL and filtered to loaded
  establishment owners there, before validation or rejection logging. PowerShell
  does not materialise and rewrite those extracts.
- `Public/ReferenceData.ps1` and `Public/BauImport.ps1` supply dictionaries and
  geography. Both rebuild paths retain the council fixture import. The BAU
  development path loads its party relationships through the dedicated development loader.
- `Invoke-FixtureLoad` renders fixture SQL, escapes literal values and paths,
  supplies migration-run context and executes the generated file. SEN, group,
  party and maintenance fixture loads use this helper.
- `migration/load-development-maintenance-observations.sql` imports development
  observations without maintenance derivation or replay locking. Checked-in
  fixtures use `establishment/load/load-maintenance-responsibility-fixture.sql`.
- `Private/BauExtract.ps1` streams CSV in PowerShell. `Private/Postgres.ps1`
  launches `psql` and `pg_dump`.
- `seed/known-bad-establishments.json` retains URNs rejected by development
  seeding, scoped to their BAU database, so subsequent runs skip them before
  extraction. Delete an entry to retry it.
- `Public/CheckedInFixture.ps1` and `Public/Tests.ps1` support fixture replay
  and its validation. Those expectations do not apply to the development seed.

To run database-free tooling checks:

```powershell
Import-Module .\models\schema\automation\EprLocalAutomation\EprLocalAutomation.psm1
Invoke-EstablishmentToolingTests
```
