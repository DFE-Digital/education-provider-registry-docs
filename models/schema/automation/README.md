# Local automation

PowerShell for rebuilding, loading, testing and exporting the local Education
Provider Registry databases. It runs only against the laptop-local BAU copy
(`gias_bau_test_local` by default, or another BAU copy named `*_local`) and local
PostgreSQL (`establishment_local`, `governance_local`). Source guards recognise
the current machine and local instances; remote/shared servers are refused.
PostgreSQL target restrictions are unchanged.

## Layout

```text
automation/
    rebuild-establishment-from-local-bau.ps1        entry point: rebuild from the local BAU copy
    rebuild-establishment-from-checked-in-sql.ps1   entry point: rebuild from checked-in SQL only
    run-establishment-tests.ps1                     entry point: run all tests, change nothing
    export-establishment-fixture-from-local-target.ps1   entry point: export the database as SQL
    inspect-governance-fixture.ps1                  entry point: report BAU governance coverage
    update-local-authority-council-seed.ps1         entry point: regenerate the council seed from its JSON
    apply-reviewed-council-reorganisation.ps1       entry point: apply one reviewed council event

    EprLocalAutomation/                             the module that does the work
        EprLocalAutomation.psm1                     loads Private and Public, exports Public functions
        Private/                                    internal helpers, not exported
            Guards.ps1        local-only checks for every source and target
            Paths.ps1         paths under models/schema, progress messages
            Postgres.ps1      running psql and pg_dump
            BauExtract.ps1    reading BAU into CSV fixtures and loading them
            Approval.ps1      normalising approval snapshots
        Public/                                     one file per area
            Connections.ps1       New-BauSource, New-PostgresTarget
            Selection.ps1         Get-FixtureSelection and group discovery
            Workspace.ps1         New-RunWorkspace, Remove-RunWorkspace
            Database.ps1          schemas and reference seeds
            CodeLists.ps1         checking code lists against BAU
            BauImport.ps1         loading from the local BAU copy
            Councils.ps1          council identities and area periods
            Maintenance.ps1       maintenance observations and derivation
            Proprietors.ps1       the proprietor review queue
            CheckedInFixture.ps1  loading and exporting the checked-in SQL
            Tests.ps1             validation, approval and scope tests
            Reports.ps1           read-only summaries
```

The entry-point scripts hold no logic of their own. Each is a short list of
module steps, so reading one shows the whole flow.

## What the default build contains

The BAU path imports source-owned dictionaries directly from MSSQL, including the full eligible admissions, boarding, diocese, further-education, nursery, sixth-form, section 41 and specialist-provision lists. It does not initialise those values from the exported SQL snapshot. See [Source-owned reference data](source-reference-data.md) for the complete flow and exclusions.

Both rebuild paths build the three sanity establishments in
`seed/fixture-selection.json`: URNs 100018, 109613 and 137603. The selection has
no group links or organisation groups.

## Running the whole flow

To add SEN to an existing populated target without rebuilding other model slices, use [migrate-sen-from-local-bau.ps1](migrate-sen-from-local-bau.ps1). It backs up the local database and applies the lookup and selected associations in one transaction. See the [SEN migration runbook](migrate-sen-from-local-bau.md).

From `education-provider-registry-docs`:

```powershell
# Without a BAU copy: rebuild from checked-in SQL and test.
.\models\schema\automation\rebuild-establishment-from-checked-in-sql.ps1

# With the local BAU copy: rebuild, test and refresh the checked-in SQL in seed/.
# Review the refreshed files with git diff before committing.
$bauSqlServer = 'localhost' # Your local machine name or named instance.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -SqlServer $bauSqlServer -UseWindowsAuthentication

# Supply URNs: discover current groups, skip the checked-in tests, leave seed/ unchanged.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -SqlServer $bauSqlServer -Urn '109443,20338' -SkipTests

# The same, also rebuilding governance_local and loading governance.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -IncludeGovernance

# Only the tests, against what is already loaded.
.\models\schema\automation\run-establishment-tests.ps1
```

A failed BAU rebuild stops and does not refresh `seed/`. The rebuild is not one
database-wide transaction, so an interrupted run can leave a partial target.
Run it again.

Use `-KeepFixture` on the BAU rebuild to keep the run's working folder of CSV
fixtures for troubleshooting.

See the [schema README](../README.md#using-a-different-bau-dataset-and-your-own-urns)
for choosing your own URNs. `-SkipTests` does not bypass source checks, load
checks or database constraints. Custom selections and skipped-test runs export
only with an explicit `-ExportDirectory`, and never replace the checked-in seeds.

`-Urn` accepts a quoted comma-separated list. A selection file with only URNs
discovers groups too. Only the supplied URNs are loaded, including for
federation and children's-centre memberships. Discovery covers current links
unless `-IncludeArchivedLinks` is supplied.

## Running one step on its own

For individual steps, import the module and create the connection objects:

```powershell
Import-Module .\models\schema\automation\EprLocalAutomation\EprLocalAutomation.psm1
$target    = New-PostgresTarget                     # establishment_local
$source    = New-BauSource -SqlServer localhost -UseWindowsAuthentication
$selection = Get-FixtureSelection                   # seed/fixture-selection.json
$workspace = New-RunWorkspace

# One test
Test-EstablishmentApproval -Target $target -Urn 137603

# Reload one establishment after changing its transform or load SQL
Import-EstablishmentFromBau -Source $source -Target $target -Urn 137603 -WorkingDirectory $workspace

# Reload one group link
Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 137603 -SourceGroupId 20364 -WorkingDirectory $workspace

Remove-RunWorkspace -Path $workspace
```

`Get-Help <function> -Full` shows each function's description and parameters.

## Functions

| Area | Function | What it does |
| --- | --- | --- |
| Connections | `New-BauSource` | Describes the local BAU copy. Prompts for the reader password unless Windows authentication or `EPR_BAU_SQL_PASSWORD` is used. |
| | `New-PostgresTarget` | Describes a local PostgreSQL database. |
| Settings | `Get-FixtureSelection` | Reads a manifest with `-Path`, or validates direct `-Urn` input. URN-only selections request discovery. |
| | `Find-EstablishmentGroupsFromBau` | Discovers supported source group links and selected-URN-only memberships before the target rebuild. |
| | `New-RunWorkspace`, `Remove-RunWorkspace` | Create and delete a working folder for one run's files. |
| | `Test-CodeListsAgainstBau` | Compares the modelled code lists with the BAU dictionaries. |
| Database | `Reset-EstablishmentSchema` | Drops and recreates the establishment and migration schemas. |
| | `Import-ReferenceSeed` | Loads the checked-in reference seeds. |
| | `Initialize-EstablishmentDatabase` | Both of the above. |
| | `Initialize-GovernanceDatabase` | Drops and recreates the governance schema. |
| BAU import | `Import-GeographicReferenceData` | Loads all geographic reference data from BAU. |
| | `Export-BauReferenceData` | Extracts all 19 source dictionaries before the target reset. |
| | `Import-BauReferenceData` | Loads full eligible dictionaries, reconciles exact source labels and records provenance. |
| | `Import-SenReferenceData` | Reconciles the 13 current SEN meanings with the local source, excluding archived values. |
| | `Import-EstablishmentSenFromBau` | Reconciles one establishment's full SEN association set and records source provenance. |
| | `Update-EstablishmentSenFromBau` | Adds SEN to every existing target establishment in one transaction, after extracting and taking a database backup. |
| | `Import-EstablishmentFromBau` | Loads one establishment. |
| | `Import-EstablishmentPartyRoleFromBau` | Loads one group link as a legal entity or an explicitly reviewed person sponsor, with its role, applicable classification, group identifiers and responsibility. |
| | `Import-OrganisationGroupFromBau` | Loads a federation or children's-centre group and its complete selected membership. Children's-centre groups retain their recorded authority and current lead assertion as a separate lead period with unknown business boundaries. Existing lead periods are retained on changes; current lead status is derived from lead periods, not a stored membership flag. |
| | `Import-GovernanceFromBau` | Loads one establishment's governance appointments. |
| Checked-in SQL | `Import-CheckedInEstablishmentFixture` | Loads the checked-in establishment fixture and migration evidence. |
| | `Export-EstablishmentFixture` | Exports the database as SQL with pg_dump. |
| | `Update-CheckedInSeed` | Copies an export into `seed/`. |
| Tests | `Test-EstablishmentUrnValidation` | URN selection boundaries and parameter-validation ranges. |
| | `Test-SenMigration` | Current lookup, key constraints and 12 actual-loader scenarios, with test changes rolled back. |
| | `Test-BauReferenceData` | Nine source-reference importer scenarios, with all changes rolled back. |
| | `Test-EstablishmentGroupDiscovery` | Source-free checks of discovery routing, unchanged URN scope, archive opt-in and invalid/duplicate-link rejection. |
| | `Test-EstablishmentCoreValidation` | Core population and keys, the null-reference policy and group-address constraints. Test records roll back. |
| | `Test-EstablishmentMigrationEvidence` | For a selection with group links or organisation groups: the rebuild's migration run retains every selected extract and source record. |
| | `Test-EstablishmentApproval` | One URN against its approved snapshot; `-UpdateApproval` refreshes it. |
| | `Test-EstablishmentScope` | Exactly the selected establishments are loaded. |
| | `Invoke-EstablishmentTests` | All of the above for the selection. |
| Reports | `Show-EstablishmentSummary`, `Show-GovernanceSummary` | Print loaded counts. |
| | `Get-GovernanceSourceCoverage` | Counts BAU governance appointments, with no personal data. |

## How a BAU import works

Every BAU import has the same two steps:

1. **Extract:** a transform SQL file in `*/transforms/` runs against the local
   BAU copy. Its first result set is written to a CSV fixture in the run's
   working folder. The fixture is pipe-delimited with a header line, uses
   `NULL` for missing values and ISO dates, and has no pipe characters inside
   values.
2. **Load:** a load SQL file in `*/load/` reads the fixture with `\copy` (the
   file refers to it as `__FIXTURE_PATH__`) and upserts it into PostgreSQL.

To add a geographic dataset, add a transform and a load file, then one line to
`$script:GeographicDatasets` in `Public/BauImport.ps1`.

## Conventions

- Every function fails on the first error; there are no exit codes to check.
- Every psql call stops on the first SQL error (`ON_ERROR_STOP`) and ignores
  `~/.psqlrc` (`-X`).
- Passwords are never written to disk. A BAU password is held as a
  `SecureString` in the source object; a PostgreSQL password is set in
  `PGPASSWORD` only for the duration of each call.
- The scripts run in Windows PowerShell 5.1 and PowerShell 7.
