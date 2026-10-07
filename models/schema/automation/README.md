# Local automation

PowerShell for rebuilding, loading, testing and exporting the local Education
Provider Registry databases. It runs only against the laptop-local BAU copy
(`gias_bau_test_local`) and local PostgreSQL (`establishment_local`,
`governance_local`). Guards refuse any other server or database.

## Layout

```text
automation/
    rebuild-establishment-from-local-bau.ps1        entry point: rebuild from the local BAU copy
    rebuild-establishment-from-checked-in-sql.ps1   entry point: rebuild from checked-in SQL only
    run-establishment-tests.ps1                     entry point: run all tests, change nothing
    export-establishment-fixture-from-local-target.ps1   entry point: export the database as SQL
    inspect-governance-fixture.ps1                  entry point: report BAU governance coverage

    EprLocalAutomation/                             the module that does the work
        EprLocalAutomation.psm1                     loads Private and Public, exports Public functions
        Private/                                    internal helpers, not exported
            Guards.ps1        local-only checks for every source and target
            Paths.ps1         paths under models/schema, progress messages
            Postgres.ps1      running psql and pg_dump
            BauExtract.ps1    reading BAU into CSV fixtures and loading them
            Approval.ps1      normalising approval snapshots
        Public/                                     one file per area, every function exported
            Connections.ps1       New-BauSource, New-PostgresTarget
            Selection.ps1         Get-FixtureSelection
            Workspace.ps1         New-RunWorkspace, Remove-RunWorkspace
            Database.ps1          schemas and reference seeds
            BauImport.ps1         loading from the local BAU copy
            CheckedInFixture.ps1  loading and exporting the checked-in SQL
            Tests.ps1             validation, approval and scope tests
            Reports.ps1           read-only summaries
```

The entry-point scripts contain no logic of their own. Each is a short list of
module steps, so reading one shows the whole flow.

## Running the whole flow

From `education-provider-registry-docs`:

```powershell
# Without a BAU copy: rebuild from checked-in SQL and test.
.\models\schema\automation\rebuild-establishment-from-checked-in-sql.ps1

# With the local BAU copy: rebuild, test and refresh the checked-in SQL in seed/.
# Review the refreshed files with git diff before committing.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -SqlServer SL646104 -UseWindowsAuthentication

# The same, also rebuilding governance_local and loading governance.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -IncludeGovernance

# Only the tests, against what is already loaded.
.\models\schema\automation\run-establishment-tests.ps1
```

Use `-KeepFixture` on the BAU rebuild to keep the run's working folder of CSV
fixtures for troubleshooting.

## Running one step on its own

Import the module, create the connection objects once, then call any step:

```powershell
Import-Module .\models\schema\automation\EprLocalAutomation\EprLocalAutomation.psm1
$target    = New-PostgresTarget                     # establishment_local
$source    = New-BauSource -SqlServer SL646104 -UseWindowsAuthentication
$selection = Get-FixtureSelection                   # seed/fixture-selection.json
$workspace = New-RunWorkspace

# One test
Test-EstablishmentApproval -Target $target -Urn 136102

# Reload one establishment after changing its transform or load SQL
Import-EstablishmentFromBau -Source $source -Target $target -Urn 136102 -WorkingDirectory $workspace

# Reload one group link
Import-EstablishmentPartyRoleFromBau -Source $source -Target $target -Urn 136102 -SourceGroupId 2777 -WorkingDirectory $workspace

Remove-RunWorkspace -Path $workspace
```

`Get-Help <function> -Full` shows each function's description and parameters.

## Functions

| Area | Function | What it does |
| --- | --- | --- |
| Connections | `New-BauSource` | Describes the local BAU copy. Prompts for the reader password unless Windows authentication or `EPR_BAU_SQL_PASSWORD` is used. |
| | `New-PostgresTarget` | Describes a local PostgreSQL database. |
| Settings | `Get-FixtureSelection` | Reads and validates `seed/fixture-selection.json`: the URNs and the group links to load. |
| | `New-RunWorkspace`, `Remove-RunWorkspace` | Create and delete a working folder for one run's files. |
| Database | `Reset-EstablishmentSchema` | Drops and recreates the establishment and migration schemas. |
| | `Import-ReferenceSeed` | Loads the checked-in reference seeds. |
| | `Initialize-EstablishmentDatabase` | Both of the above. |
| | `Initialize-GovernanceDatabase` | Drops and recreates the governance schema. |
| BAU import | `Import-GeographicReferenceData` | Loads all geographic reference data from BAU. |
| | `Import-EstablishmentFromBau` | Loads one establishment. |
| | `Import-ControlledProprietorFromBau` | Validates reviewed public-extract assertions against the selected schools, then loads a shared proprietor body and separate responsibilities. Retains obfuscated local context separately; requires the rebuild run ID. |
| | `Import-EstablishmentPartyRoleFromBau` | Loads one group link as a legal entity or an explicitly reviewed person sponsor, with its role, applicable classification, group identifiers and responsibility. |
| | `Import-OrganisationGroupFromBau` | Loads a federation or children's-centre group and its complete selected membership. Children's-centre groups retain their recorded authority and explicit lead flag. |
| | `Import-GovernanceFromBau` | Loads one establishment's governance appointments. |
| Checked-in SQL | `Import-CheckedInEstablishmentFixture` | Loads the checked-in establishment fixture and migration evidence. |
| | `Export-EstablishmentFixture` | Exports the database as SQL with pg_dump. |
| | `Update-CheckedInSeed` | Copies an export into `seed/`. |
| Tests | `Test-EstablishmentUrnValidation` | URN selection boundaries and parameter-validation ranges. Runs automatically with all establishment tests. |
| | `Test-EstablishmentCoreValidation` | Core population and keys; URN and organisation-identifier constraint tests roll back their test records. |
| | `Test-EstablishmentGroupsValidation` | Establishment-groups rules plus actual-loader tests for source-UID reuse, person-endpoint reuse and rejection of name-only merges, party-kind conflicts and unreviewed person mappings; test loads roll back. The full test runner also validates selected person sponsorship, foundation-trust support, federations and children's-centre groups and checks that all selected extracts sit beneath one rebuild migration run. |
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
