# Simplification opportunities in the local automation

This is a review of the PowerShell automation in this folder. It lists code we can delete or simplify. The folder is about 2,300 lines. Much of the growth came with the BAU development seed, and some older code no longer has a caller.

Sections 1 and 5 are safe, mechanical changes. Sections 2 to 4 change how loads run, so each one needs a BAU development seed run to prove it.

## 1. Delete dead code (about 450 lines)

### Functions with no callers

| Function | File |
| --- | --- |
| `Find-EstablishmentGroupsFromBau`, `Get-EstablishmentSelectionFromBau` | [Selection.ps1](EprLocalAutomation/Public/Selection.ps1) |
| `Import-OrganisationGroupFromBau` | [BauImport.ps1](EprLocalAutomation/Public/BauImport.ps1) |
| `Import-EstablishmentSenFromBau`, `Test-SenMigration` (85 lines, not part of any test run) | [Sen.ps1](EprLocalAutomation/Public/Sen.ps1) |
| `Import-MaintenanceFromBau` | [Maintenance.ps1](EprLocalAutomation/Public/Maintenance.ps1) |
| `Initialize-GovernanceDatabase` | [Database.ps1](EprLocalAutomation/Public/Database.ps1) |
| `Test-EstablishmentCount` | [Tests.ps1](EprLocalAutomation/Public/Tests.ps1) |
| `Update-CheckedInSeed` | [CheckedInFixture.ps1](EprLocalAutomation/Public/CheckedInFixture.ps1) |
| `Write-DevelopmentRelationshipError` (the singular version) | [DevelopmentRelationships.ps1](EprLocalAutomation/Public/DevelopmentRelationships.ps1) |
| `ConvertTo-FixtureValue` | [BauExtract.ps1](EprLocalAutomation/Private/BauExtract.ps1) |

### The group-discovery feature

The BAU path now uses the development seed. The checked-in [fixture-selection.json](../seed/fixture-selection.json) sets `discoverGroups` to `false` and has no groups or links. So nothing uses:

- `ConvertTo-DiscoveredGroupSelection` and its test, `Test-EstablishmentGroupDiscovery` (65 lines)
- the group and link parsing in `Get-FixtureSelection`
- `Test-EstablishmentMigrationEvidence`, which only runs when the selection has links
- the transforms `discover-establishment-groups-from-bau.sql` and `discover-all-establishment-groups-from-bau.sql`

### An unused transform

No script references [academy-trust-responsibility-from-bau.sql](../establishment/transforms/academy-trust-responsibility-from-bau.sql) (462 lines).

### A switch nobody sets

No caller passes `-EstablishmentsOnly`, but four functions pass it along. This hides a mismatch with the [README](README.md). The README says development seeding skips the council import. But the switch is never set, so the development path does run `Import-LocalAuthorityCouncilFixture`, through `Import-GeographicReferenceData`.

## 2. Stop rewriting SQL at run time

This is the most valuable change.

`Import-DevelopmentEstablishmentSeed` in [DevelopmentSeed.ps1](EprLocalAutomation/Public/DevelopmentSeed.ps1) takes [load-establishment-fixture.sql](../establishment/load/load-establishment-fixture.sql) apart while it runs. It:

- finds sections by searching for strings such as `CREATE TEMP TABLE source_establishment_fixture (` and `\echo Resolving...`
- reads column types with a regular expression
- removes `BEGIN`, `COMMIT` and `\echo` lines
- turns `CREATE ... AS` into `INSERT INTO`
- deletes the advisory lock and the replay check

So a harmless edit to the loader can break the development seed. We'd only find out when the seed fails.

The same thing happens on a smaller scale in three more places:

- The development branch of `Import-MaintenanceObservationFixture` removes the advisory lock and the `derive_maintenance` call.
- `Import-DevelopmentEstablishmentSeed` edits the T-SQL `WHERE` clause with `.Replace()` to add URN lists and exclusions.
- `Test-SenMigration` removes `BEGIN` and `COMMIT` from the SEN loader.

A simpler approach:

- Split `load-establishment-fixture.sql` into named pieces: staging tables, lookups and inserts. Both paths include the pieces with psql's `\ir`.
- Control the optional parts with psql variables and `\if`. `Invoke-Psql` already supports `-Variables`.
- Give the T-SQL transform proper variables for the URN list and the exclusions.

This removes about 40 lines of the most fragile code in the folder.

## 3. Use one way to fill in templates

We fill in SQL templates in four ways:

- `$(NAME)` placeholders in T-SQL
- `__NAME__` placeholders
- psql `-v` variables
- a hand-written `set_config('epr.migration_run_id', ...)` line at the top of the file

Four places also copy what `Invoke-FixtureLoad` does. They read the SQL file, replace `__FIXTURE_PATH__`, write a working copy and run it. They are:

- the SEN load in `Import-DevelopmentSenRelationships`
- the group load in `Import-DevelopmentOrganisationGroups`
- the development branch of `Import-MaintenanceObservationFixture`
- the test cases in `Test-SenMigration`

The copies have drifted apart:

- Some escape `'` in the file path, but `Invoke-FixtureLoad` doesn't. A folder name with an apostrophe would break only some of the loads.
- Some add the migration run ID by hand, although `Invoke-FixtureLoad -MigrationRunId` already does this.

If they all go through `Invoke-FixtureLoad`, both problems go away. We could also standardise on psql variables for everything that runs in PostgreSQL.

## 4. Filter by URN in PostgreSQL, not in PowerShell

The party, SEN, organisation-group and maintenance loads all make the same round trip. They export every row from BAU, read the whole CSV with `Import-Csv`, filter it by a set of URNs, and then write a new CSV with `Write-DevelopmentCsv`.

If the load SQL joins the staged rows to `establishment.establishment`, we can drop all four filters. We can also drop `Write-DevelopmentCsv`, which is a second CSV writer next to `Write-BauReaderToCsv`. And we'd stop holding full BAU extracts in memory as PowerShell objects, which is the slow part of these loads.

## 5. Smaller tidy-ups

- **Reading the target's URNs.** Four places do this in four different ways. One `Get-TargetUrns` helper would cover them all.
- **The migration run lifecycle.** The development seed creates the run and completes it in SQL. `Import-DevelopmentRelationships` then reopens it, completes it again and has its own failure handling. Instead, the entry script could create the run once and complete it once at the end. That removes the reopening and two failure handlers.
- **URN validation.** The BAU path checks URNs three times: in the entry script, in `Get-FixtureSelection` and in `Import-DevelopmentEstablishmentSeed`. The entry script could take `[ValidateRange(1,999999)][int[]]$Urn` and leave it there.
- **`Export-BauQueryToCsv`.** Its `finally` block disposes `$writer`, but nothing ever assigns it. It also repeats a zero-row check that `Write-BauReaderToCsv` has already made.
- **Party slices.** In `Import-DevelopmentPartyRelationships`, the locals `$failed` and `$loaded` are never used. The nested function keeps `$script:` counters where a plain loop with local counters would do.
- **`Test-EstablishmentUrnValidation`.** Part of it uses reflection to read another function's `ValidateRange` attribute. That tests the test setup rather than the automation, and it can go.
- **`Get-PostgresClientPath`.** It hard-codes `C:\Program Files\PostgreSQL\18\bin`. It would survive the next upgrade if it searched `C:\Program Files\PostgreSQL\*\bin` and took the newest version.
- **Very small files.** `Proprietors.ps1` holds one call. `ReferenceData.ps1` and `Approval.ps1` are also very short. All three could merge into neighbouring files.

## A design question

The development seed writes to the checked-in [known-bad-establishments.json](../seed/known-bad-establishments.json) on every run, through `Save-KnownBadEstablishments`. So a BAU run changes a tracked file.

If that's deliberate, we keep it. If not, we could keep the list in the run workspace or outside `seed/`. That would also remove the code that writes a temporary file and moves it into place, and stop the file appearing in git diffs.
