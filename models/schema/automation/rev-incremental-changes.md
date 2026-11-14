# Local automation review: incremental changes

Reviewed on 14 November 2026 against [rev.md](rev.md) and the scripts and SQL at review time. This records the findings and proposed increments.

Implementation update: increments 1–3 have now been implemented for the user's next migration run. Quiet failures retain diagnostics and SQLSTATE; a dedicated source-UID-based development party loader replaces the reviewed fixture loader in that path; group state resets per iteration; and normal empty-SEN placeholders are accepted. PowerShell syntax/module checks and read-only PostgreSQL diagnostic-classification checks passed. Full migration verification remains with the user. The remaining increments are proposed work.

The purpose remains a quick development dump with repeatable commands, bulk loading, tolerable data loss and useful failure logs. Both the BAU rebuild and checked-in SQL rebuild must continue to work. The checked-in path currently has fixture validations that the BAU path does not run; removing further checks would be a separate change, rather than a prerequisite for simplification.

## Findings to address first

### 1. Party loads can reject every slice because the shared run type is incompatible

**High priority.** [DevelopmentSeed.ps1](EprLocalAutomation/Public/DevelopmentSeed.ps1) creates a `development-establishment-seed` run. [DevelopmentRelationships.ps1](EprLocalAutomation/Public/DevelopmentRelationships.ps1) passes it to [load-academy-trust-responsibility-fixture.sql](../establishment/load/load-academy-trust-responsibility-fixture.sql), whose shared-run check permits only `establishment-rebuild`, `t13-additive` and `t10-additive`.

Reopening the development run as `running` does not fix the incompatible run type. This is an independent reason that every otherwise-valid party slice can fail. The loader also retains name-match/identity-review rules, so allowing the run type alone would not deliver the intended generic development load.

**Proposed change:** give the development party phase an explicit loader compatible with the development run and its agreed lossy policy. Use source group identifiers as the repeatable mapping key; do not merge parties by name or reintroduce reviewed fixture-case mappings. Preserve real identifiers where the model accepts them and log incompatible rows/slices. Keep the existing reviewed loader for any remaining fixture use until its references are checked.

The existing 250-row skip policy may omit valid rows alongside one failed row. Preserve that accepted trade-off initially, but report it as **rows skipped in a failed slice**, not as 250 individually proven bad rows. Do not add all affected URNs to the known-bad establishment list.

### 2. Maintenance lock removal currently does not match the generated SQL

**Medium priority.** In [Maintenance.ps1](EprLocalAutomation/Public/Maintenance.ps1), the `-SkipDerivation` branch substitutes `__SOURCE_DATABASE__` and `__EXTRACT_SHA256__` before trying to remove an advisory-lock statement containing those placeholders. The statement no longer matches, so the lock remains. The derivation-call removal does match.

**Proposed change:** create an explicit development maintenance loader that imports observations without calling reviewed derivation. The checked-in path retains its existing behaviour. Remove the runtime string surgery once that loader is in place. This avoids relying on SQL formatting or replacement order.

Importing observations does not create maintenance responsibility rows. The development summary and documentation should say **maintenance observations imported**, rather than imply that relationships were derived.

### 3. Failure reporting can hide defects as ordinary data loss

**High priority.** [Postgres.ps1](EprLocalAutomation/Private/Postgres.ps1) discards stderr under `-Quiet`, leaving the caller with a generic exit-code message. Party imports catch all exceptions and classify them as skipped data. The group SQL catches `OTHERS` and records a generic message; maintenance failures are only warnings and do not contribute to the shared run's error status.

**Proposed change:** capture PostgreSQL diagnostics while suppressing expected retry noise on the console. Persist the actual failure reason and distinguish source/model rejections from broken templates, missing tables, connection failures or client-launch failures. Unexpected execution failures should end the run with a useful error rather than silently produce an empty relationship dataset. Record maintenance phase failure in the run log and final status.

This is loader diagnostics, not a data-quality remediation feature. Retain the existing SQL-file execution for large inserts so Windows command-line limits and native argument quoting do not return.

## Assessment of the proposed simplifications

| Proposal in rev.md | Review outcome | Adjustment before implementation |
| --- | --- | --- |
| Delete functions with no callers | Agree within the two-entry-point execution graph. The listed functions have definitions/exports but no active calls in the inspected automation. | Remove exports and documentation references together. Publicly exported functions could have manual callers outside this graph; they are not part of the retained command contract. |
| Remove group discovery | Agree for the current rebuilds. The default manifest has three URNs, `discoverGroups: false`, and empty group/link selections. BAU now uses dedicated development transforms. | Remove the discovery-only regression test as well. Simplifying custom selection-file parsing changes the helper interface, so retain URN selection and the default manifest behaviour explicitly. |
| Delete the old party source transform | Agree after a final reference check: the development party phase uses `development-party-relationships-from-bau.sql`. | Do not confuse the unused source transform with the PostgreSQL party loader, which is still actively called. |
| Remove `-EstablishmentsOnly` | Agree if the normal council import/reset path is the intended behaviour for both commands. Neither entry point sets the switch. | Correct the README claim that the development path omits councils. Councils support the target model; removing their import is a separate functional choice. |
| Stop rewriting the core loader at runtime | Strongly agree. This is the most fragile implementation area. | Preserve per-establishment rollback, raw-text staging, bulk batches, failed-check optimisation and persistent rejection caching. These cannot be replaced by an unconditional whole-file load. |
| Standardise SQL template execution | Agree. Current implementations differ in quoting, run-context injection and error handling. | First standardise file rendering/execution. Do not require one placeholder syntax across SQL Server, psql commands and PL/pgSQL. Those layers have different substitution rules. |
| Move relationship filtering into PostgreSQL | Agree, one relationship phase at a time. | Filter staged rows before validation, error logging and grouping, not only before final inserts. Skipped core establishments must not make a whole relationship slice fail or produce irrelevant error rows. |
| Introduce a target-URN helper | Reasonable only while multiple PowerShell callers still need it. | If PostgreSQL owns relationship scope, avoid adding a new helper for code that will soon disappear. |
| Give the entry point ownership of the migration run | Agree. It should create the shared run once and complete it once. | Preserve per-batch commits and error records; do not wrap the entire dump in one transaction. Ensure the final summary includes core, relationship and maintenance outcomes. |
| Validate URNs only in the entry point | Adjust. Basic parameter checks are cheap and useful for callable helpers. | Keep validation at the reusable import boundary and for selection files. Preserve comma-separated `-Urn` input; changing to a bare `int[]` parameter would change the documented command syntax. |
| Remove unused writer disposal, duplicate checks and unused counters | Agree; mechanical cleanup. | Keep disposal of the actual reader, command, connection and buffered CSV writer. |
| Simplify the reflection-based URN test | Agree. | Do not introduce a replacement test suite merely to check an attribute. |
| Discover installed PostgreSQL versions | Reasonable, lower priority. | Prefer PATH first. If adding fallback discovery, compare versions numerically and resolve `psql`/`pg_dump` consistently rather than relying on directory-name sorting. |
| Merge very short files | Optional; low value. | Defer until the execution graph is simpler. A small file is not itself a functional or performance problem. |
| Move the known-bad list out of tracked seed data | Reject for this task. Persistent static exclusions were explicitly requested. | Keep [known-bad-establishments.json](../seed/known-bad-establishments.json), source-database scoping and atomic replacement. A run-workspace-only list would be deleted during cleanup and lose the requested cross-run benefit. |

The line-count estimates in rev.md are indicative rather than acceptance criteria. File deletions may leave SQL called by seeds, `\ir` includes, validation SQL, dynamic paths or exports; search those references before deleting their dependencies.

## SQL composition details

The core development loader executes the per-slice insert body dynamically inside a PostgreSQL exception block. A psql `\ir` command cannot execute inside that PL/pgSQL string; likewise psql `\if` is client-side and cannot make decisions separately for each server-side retry.

Use explicit SQL files or function definitions for staging, lookup preparation and the per-slice operation, with psql includes only at the top level. Keep the exception/rollback boundary inside PostgreSQL. Any extracted files must resolve relative to the checked-in source location or be copied with their dependencies into the working directory; moving a rendered wrapper into a temporary directory changes the base for relative includes.

Do not blindly replace `__FIXTURE_PATH__` with a psql variable: `\copy` has its own parsing/substitution rules. Central rendering of a properly quoted path into a generated SQL file is an acceptable simple solution. Fix apostrophe escaping in `Invoke-FixtureLoad` before routing additional phases through it. Keep large SQL and JSON payloads out of native command-line arguments.

## Additional small correctness items

| Location | Finding | Proposed change |
| --- | --- | --- |
| [load-development-organisation-groups.sql](../migration/load-development-organisation-groups.sql) | `authority_id` is assigned for children's-centre groups but is not reset at the start of each iteration. A later federation can inherit the previous group's authority value. | Reset per-group variables before loading each group; log the actual SQLSTATE/message when a group fails. |
| [load-development-establishment-sen.sql](../migration/load-development-establishment-sen.sql) | A null-link placeholder representing an establishment with no SEN associations is currently logged as malformed because `sen_code IS NULL`. | Treat a valid no-association placeholder as an empty association set, rather than a data error. Keep malformed non-empty links distinct. |
| [CheckedInFixture.ps1](EprLocalAutomation/Public/CheckedInFixture.ps1) | The migration export table list includes `establishment_load_error` but omits `relationship_load_error`. | Include relationship errors in optional development exports, or explicitly document their omission. |
| Development run summary | Known-bad exclusions are excluded before the attempted count; maintenance/group outcomes are not clearly broken out in the final console summary. | Report source candidates, cached exclusions, attempted/loaded/rejected core rows and phase outcomes separately. Do not describe known-bad exclusions as newly failed rows. |

## Implementation sequence

Each increment should be reviewable on its own. The user runs rebuilds and reports results; no automatic rebuild of `establishment_local` is required to prepare these changes.

| Order | Increment | Acceptance / verification |
| --- | --- | --- |
| 1 | Capture stderr and retain actual relationship failure reasons; record maintenance failures in the run outcome. | Module parses/imports. On the next user run, a rejected slice has a useful stored reason and execution failures do not masquerade as success. |
| 2 | Correct the party development-loader/run-type mismatch and remove reviewed identity rules from that path. | Next BAU run loads representative valid party links; failures remain logged with accepted slice-level loss. The checked-in rebuild still loads its captured relationships. |
| 3 | Fix per-group variable reset and normal empty-SEN handling. | Next user run confirms a valid federation after a children's-centre group has no inherited authority, and an establishment with no SEN is not logged as malformed. |
| 4 | Remove the confirmed dead functions, discovery-only tooling, exports and unused source transforms. | Both entry scripts and the module parse/import; no retained caller references a deleted function/file. Next normal rebuild uses the same scope and inputs. |
| 5 | Centralise fixture rendering/execution and quoting. | Paths containing spaces/apostrophes render correctly; SQL executes from files; the two rebuilt paths retain their current behaviour. |
| 6 | Replace maintenance string rewriting with an explicit observations-only loader. | BAU imports observations without reviewed derivation or accidental replay locking. Checked-in maintenance loading remains intact. |
| 7 | Replace core SQL surgery with explicit staging/lookups/per-slice SQL composition. | Preserve bulk performance and failure isolation; known bad URNs stay excluded, new bad establishments are cached/logged, and rejected core rows leave no partial child data. |
| 8 | Move SEN, group, maintenance and then party scoping into PostgreSQL, in separate changes. | Only loaded establishment owners participate in validation/loading/logging. Remove `Write-DevelopmentCsv` only when its final caller is gone. |
| 9 | Move shared run creation/completion to the entry point and improve final accounting/export coverage. | One shared run lifecycle covers all phases, including an empty selection and failures. Totals distinguish cached exclusions from new rejections. |
| 10 | Apply remaining mechanical cleanup and documentation corrections. | Remove unused locals, obsolete switches and stale documentation; retain existing command syntax and static bad-URN exclusions. |

Avoid combining SQL restructuring, transaction changes and filtering changes into one increment. That would make a failure difficult to attribute and make the next successful dev dump harder to compare.
