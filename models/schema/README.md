# Local schema automation

This directory contains the PostgreSQL model, seed data and PowerShell tooling for local development. The databases are disposable modelling targets.

The scripts in `automation/` use `establishment/transforms/` to extract BAU data and `establishment/load/` to load reference data and fixtures into PostgreSQL. Dedicated development loaders live in `migration/`; the checked-in rebuild primarily restores SQL from `seed/`.

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

## Local database passwords

The two database credentials are supplied locally and are not checked into this repository. Each developer needs credentials for their own local databases; the scripts do not create these logins or set their passwords.

| Database | Default connection | Local password configuration | Used by |
| --- | --- | --- | --- |
| BAU SQL Server source | `localhost`, database `gias_bau_test_local`, login `reader` | `EPR_BAU_SQL_PASSWORD` in the PowerShell environment. If absent, the BAU rebuild prompts for the reader password. There is no password file read by the SQL Server helper. | BAU rebuild only |
| PostgreSQL target | `127.0.0.1:5432`, database `establishment_local`, login `postgres` | `%APPDATA%\postgresql\pgpass.conf`, outside the repository. `PGPASSWORD` or the rebuild's `-PostgresPassword` parameter can override the password-file lookup. `PGPASSFILE` can select a different password file. | Both rebuilds; the .NET API demo also uses the local PostgreSQL password file |

The PostgreSQL password file uses one line per connection, in this format:

```text
hostname:port:database:username:password
127.0.0.1:5432:establishment_local:postgres:<your-local-postgres-password>
```

Replace the placeholder with the actual local password. The file contains plaintext credentials; keep it in your local profile and do not copy it into the repository. SQL Server's `EPR_BAU_SQL_PASSWORD` environment variable also contains a plaintext password. A variable set only in a PowerShell session must be supplied again in a new session unless your local environment setup restores it.

For Windows-authenticated SQL Server access, pass `-UseWindowsAuthentication` instead of supplying the reader password. The checked-in SQL rebuild does not need the BAU SQL Server password.

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

