# Local schema automation

This directory contains the PostgreSQL model, seed data and PowerShell tooling for local development. The databases are disposable modelling targets.

## Choose a dataset

| Path | Behaviour |
| --- | --- |
| [Local BAU development seed](automation/rebuild-establishment-from-local-bau.md) | Bulk loads establishments and lossy current relationships. Skips and logs rows that fail to load. |
| [Checked-in SQL fixture](automation/rebuild-establishment-from-checked-in-sql.md) | Restores the reviewed fixture and checks its database constraints and approval snapshots. |

From the `education-provider-registry-docs` repository root:

```powershell
# Core establishment data from your local BAU copy.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer "localhost"

# Reviewed fixture without SQL Server.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-checked-in-sql.ps1"
```

Both recreate the local `establishment` and `migration` schemas. The connection guards permit local sources and targets only. PowerShell coordinates execution; SQL Server extracts source rows and PostgreSQL loads target rows using `psql`.

## BAU development data

The source defaults to `gias_bau_test_local`. Its reader password is taken from `EPR_BAU_SQL_PASSWORD` or prompted for; `-UseWindowsAuthentication` uses Windows authentication instead. PostgreSQL defaults to `establishment_local`, using `pgpass.conf` or `PGPASSWORD`.

The seed includes source statuses Open (`1`), Closed (`2`) and Open, but proposed to close (`3`). It imports the establishment's own geography, contact, lifecycle, main site, capacity/pupil measures, admissions and provision data, followed by a lossy development load of current party, group, maintenance and SEN relationships. Governance is not imported.

Reference dictionaries and geography load first. Establishment data is extracted once and staged. Batches of 1,000 are attempted; failed batches roll back and split until individual failed establishments can be skipped. Failed rows leave no partial establishments or child records. Relationship rows are scoped to successfully loaded establishments; rejected relationship slices are logged in `migration.relationship_load_error` and skipped. Values and model constraints are not adjusted to resolve data-quality problems.

```sql
SELECT urn, sqlstate, error_message, error_detail, source_row
FROM migration.establishment_load_error
ORDER BY urn;

SELECT status, notes
FROM migration.migration_run
WHERE run_type='development-establishment-seed'
ORDER BY started_at DESC;
```

