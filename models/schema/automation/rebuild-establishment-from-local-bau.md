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

### Selecting establishments and their links

A selected rebuild resolves the complete connected set of non-archived BAU
establishment links before resetting the target. It follows links in either
direction and deduplicates reciprocal links, shared neighbours and cycles.
Selecting **113557** therefore also loads **136494**; selecting **136494** also
loads **113557**. The same expansion applies to a list or selection file.

From the workspace root:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\education-provider-registry-docs\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -Urn 113557 -PostgresPort 5433 -PostgresDatabase establishment
```

For a list, use `-Urn "113557,136494"`. Omit the selection to migrate all eligible
establishments. Both selected and full runs reset the schemas. The target above
is the documented instance on port 5433; for the older local target use
`-PostgresPort 5432 -PostgresDatabase establishment_local`.

The load order is reference data, all resolved establishment core rows, ordinary
relationships, then reorganisations. A full migration likewise runs the
reorganisation phase at the end, after all establishment batches have finished.
Related establishments remain subject to the existing source status filters and
rejection rules; a missing or rejected endpoint is recorded as a
`reorganisation-dependency` rather than creating a partial event.

The reorganisation phase implements R01-R07 from
`establishment/cases/reorganisation-migration-cases.json`. The generic loader reads
patterns, causes, participants, outcomes and directed succession pairs from that
file. It validates each pair's two non-archived BAU assertions and checks source
lifecycle dates against the target before writing the event in one transaction.

| Case | Pattern | Participants | Succession pairs |
| --- | --- | --- | --- |
| R01 | Replacement | 2 | 1 |
| R02 | Absorption | 2 | 1 |
| R03 | Amalgamation | 4 | 3 |
| R04 | Split | 3 | 2 |
| Total | 4 events | 11 | 7 |

Leeds City College is Continued in R02 and Opened in R03, in separate events.
The four mappings are enabled for local migration testing; their event dates
remain unasserted. Source labels do not automatically classify other events.
Reprocessing assertions preserves existing establishment, event, participant and
pair UUIDs. Conflicting existing events, lifecycle data or dated standalone pairs
stop the case rather than silently replacing those facts. A rebuild still resets
the schemas and recreates the dataset.

Per-case results and source evidence are retained in
`migration.migration_run.notes` under `reorganisations`. Missing endpoints are
recorded in `migration.relationship_load_error`, with no partial event created.
Selection expansion follows all active establishment link types; it does not
classify them as reorganisations. R05-R07 use the accepted local test assumptions described below.

Focused loader tests use isolated schemas and controlled source links:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\education-provider-registry-docs\models\schema\establishment\cases\test-reorganisation-migration.ps1"
```
### Rebuilding the dataset

The command recreates the disposable target schemas, loads reference dictionaries
and geography, then extracts establishment rows once. PostgreSQL stages the raw
values and attempts batches of 1,000 establishments by default.

The entry point creates one shared migration run for core and relationship
phases and completes it once at the end. The final summary separates eligible
source candidates, cached exclusions, attempted core rows, loaded rows and new
rejections, with per-phase relationship and maintenance outcomes in run notes.
Core batch commits and rejection-cache updates are retained if a later phase fails.

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
its own writes. Relationship extracts are staged once per phase and scoped to
loaded establishment owners in PostgreSQL before validation and logging. If a
phase's staging COPY rejects its input, the phase failure is logged without
per-row retries. The summary reports loaded/rejected party links and phase failures
separately. The same staging approach covers group, SEN and maintenance observations.

Quiet loads retain database diagnostics for error logs. Execution failures such
as broken SQL, missing tables or connection failures stop the command instead of
being counted as ordinary source-data exclusions. A maintenance observation phase
failure is recorded as `maintenance-phase` against the first scoped URN, with a
source-row note identifying the whole phase's scope; it is not a rejection of
that establishment. The run completes with errors for tolerated data failures.

The maintenance development phase imports source observations only; it does not
derive maintenance responsibilities. It uses the explicit
`migration/load-development-maintenance-observations.sql` loader rather than
rewriting the checked-in maintenance loader. An establishment with no SEN associations
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

The case JSON contains R01-R07 and a shared `urns` list per case. All seven mappings are enabled; R05-R07 are accepted local test assumptions.
To rebuild just the enabled case selections from the workspace root:

```powershell
$cases = Get-Content ".\education-provider-registry-docs\models\schema\establishment\cases\reorganisation-migration-cases.json" -Raw | ConvertFrom-Json
$urns = (($cases.cases | Where-Object migration_enabled).urns | Sort-Object -Unique) -join ','
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\education-provider-registry-docs\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -Urn $urns -PostgresPort 5433 -PostgresDatabase establishment
```

## Accepted R05-R07 assumptions and local migration result

27 November 2026: the user accepted the unresolved assumptions for local test migration. These assumptions do not establish the corresponding business events as independently verified facts.

| Case | Accepted local test assumption |
| --- | --- |
| R05 | Provision transfers from Rosedale College (137077) to Rosedale Primary (141561). |
| R06 | A separate provision transfer goes from Sedbergh School (112451) to Casterton (112445). |
| R07 | Sedbergh Junior (121739) succeeds into both survivors, with a provision transfer from Casterton (112445) to Sedbergh School (112451). Casterton has an age-range effect and Sedbergh School a capacity effect. |

R06 and R07 are assumed to be distinct events. Their opposite transfer directions are allocated separately; the same directed transfer is not counted in both events. Event dates remain unset. Source link dates validate lifecycle context but are not asserted as event dates. Assumption status, acceptance date, rationale and source observations are retained under `reorganisations` in `migration.migration_run.notes`.

The local migration into `127.0.0.1:5433/establishment` completed successfully: **7 events, 18 participants, 9 succession pairs, 3 provision transfers and 2 effects**. All seven patterns are represented, with no core or relationship rejections. Isolated repeat-import tests also pass for all seven cases.
