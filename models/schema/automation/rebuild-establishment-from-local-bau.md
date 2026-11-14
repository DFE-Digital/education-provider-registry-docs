# Seed establishments from local BAU

This command creates a development dataset in the disposable local PostgreSQL
target. It loads core establishment records and their geography, contact,
lifecycle, main site, measures and provision tables, then a lossy development
set of party, group, maintenance and SEN relationships. Governance is not
imported. This is not a reviewed full migration.

Source establishments with status Open (`1`), Closed (`2`) or Open, but proposed
to close (`3`) are included. Other statuses are excluded.

From `education-provider-registry-docs`:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer $bauSqlServer
```

The source must be a local SQL Server copy, normally `gias_bau_test_local`.
The command prompts for its reader password unless `EPR_BAU_SQL_PASSWORD` is
set. Use `-UseWindowsAuthentication` for a local Windows-authenticated source.
The target defaults to `establishment_local`, with PostgreSQL credentials in
`pgpass.conf` or `PGPASSWORD`.

## Loading and failures

The command recreates the disposable target schemas, loads reference dictionaries
and geography, then extracts establishment rows once. PostgreSQL stages the raw
values and attempts batches of 1,000 establishments by default.

When a batch fails on source data or a model constraint, its writes roll back
and it is split into smaller batches. An individual establishment that still
fails is skipped. All of its partial child rows roll back. Other establishments
continue to load. Source values and model constraints are not changed to make
bad data fit.

The error is recorded in `migration.establishment_load_error` with the URN,
PostgreSQL SQLSTATE, message, detail and raw source row. The migration run records
attempted, loaded and skipped counts and ends as `completed` or
`completed_with_errors`. Missing establishments are expected in this development
dataset. Setup, connection, schema and resource failures still stop the command.

Rejected URNs are also added to the checked-in
`models/schema/seed/known-bad-establishments.json` list, scoped to the BAU source
database. A later run excludes those URNs before extracting rows, so it does not
rediscover the same bad data. Remove an entry from that file to retry it after its
source data or the model has changed. The per-run migration error table remains
the audit record for rows rejected during that run.

Relationship rows are handled independently after core establishments have
loaded. Only relationships owned by a loaded establishment are considered.
The development projection does not apply reviewed identity mappings; rows that
the target rejects are omitted and recorded in `migration.relationship_load_error`.
This keeps a relationship data set useful for development without treating it as
a source-data or identity-resolution exercise.

Development party links use `migration/load-development-party-relationships.sql`.
The source Group UID identifies a party across its establishment links; matching
names do not merge parties. Conflicting identifiers and model-rejected links are
logged with the PostgreSQL SQLSTATE and error text. Each rejected link rolls back
its own writes. If the staging COPY rejects a whole slice, the slice is logged
and skipped without individual retries. The summary reports actual party links
loaded and skipped.

Quiet loads retain database diagnostics for error logs. Execution failures such
as broken SQL, missing tables or connection failures stop the command instead of
being counted as ordinary source-data exclusions. A maintenance observation phase
failure is recorded as `maintenance-phase` against the first scoped URN, with a
source-row note identifying the whole phase's scope; it is not a rejection of
that establishment. The run completes with errors for tolerated data failures.

The maintenance development phase imports source observations only; it does not
derive maintenance responsibilities. An establishment with no SEN associations
is an ordinary empty association set and is not logged as malformed.

```sql
SELECT urn, sqlstate, error_message, error_detail
FROM migration.establishment_load_error
ORDER BY urn;

SELECT urn, relationship_kind, error_message, source_row
FROM migration.relationship_load_error
ORDER BY recorded_at;

SELECT status, notes
FROM migration.migration_run
WHERE run_type = 'development-establishment-seed'
ORDER BY started_at DESC;
```

## Optional choices

- `-Urn "109443,20338"` or `-SelectionFile <json>` restricts the core establishment
  selection. Group declarations in a selection file do not trigger entity imports.
- `-BatchSize 1000` controls the initial batch size. Splitting happens automatically.
- `-KeepFixture` retains extracts and generated SQL in the reported workspace.
- `-ExportDirectory <path>` exports the resulting PostgreSQL data as SQL for review.

The command does not run fixture approval tests, update approval snapshots or
automatically replace checked-in seeds. The checked-in SQL rebuild remains the
separate reviewed-fixture workflow. Its approvals describe its own curated data.
