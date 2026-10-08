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
$bauSqlServer = 'localhost' # Your local machine name or named instance.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -SqlServer $bauSqlServer -UseWindowsAuthentication

# Supply URNs: discover current groups, skip case-specific tests, leave seed/ unchanged.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -SqlServer $bauSqlServer -Urn '109443,20338' -SkipTests

# The same, also rebuilding governance_local and loading governance.
.\models\schema\automation\rebuild-establishment-from-local-bau.ps1 -IncludeGovernance

# Only the tests, against what is already loaded.
.\models\schema\automation\run-establishment-tests.ps1
```

Use `-KeepFixture` on the BAU rebuild to keep the run's working folder of CSV
fixtures for troubleshooting.

See the [schema README](../README.md#using-a-different-bau-dataset-and-your-own-urns)
for choosing URNs and constructing a custom selection. `-SkipTests` does not
bypass source/load checks or database constraints. Custom selections and
skipped-test runs export only with an explicit `-ExportDirectory` and do not
automatically replace checked-in seeds.

`-Urn` accepts a quoted comma-separated list (also usable with `powershell.exe -File`).
A URN-only `-SelectionFile` discovers groups too. Only supplied URNs
are loaded, including federation/children's-centre memberships. Discovery is
current-only unless `-IncludeArchivedLinks` opts into archived party links;
historical organisation memberships and unreviewed proprietor identities are
not inferred. The default explicit fixture manifest remains unchanged.

## Running one step on its own

To add the bounded T11R Oasis case to an existing local Establishment database:

```powershell
.\models\schema\automation\migrate-t11r-from-local-bau.ps1
```

This uses the SQL Server `reader` login and `EPR_BAU_SQL_PASSWORD`, adds URN
134311 and its two selected group links, and checks the accepted shared-entity
assumption and repeat imports. It preserves the existing database and leaves
the default fixture selection and checked-in seeds unchanged. The database
must already contain the Establishment reference data and migration schema.

To add T12, New Fosseway School and its selected foundation-trust support link:

```powershell
.\models\schema\automation\migrate-t12-from-local-bau.ps1
```

This also uses `reader` and `EPR_BAU_SQL_PASSWORD`. It validates provisional
identity, unknown dates and identifiers, stable reimport, and rejection of an
unreviewed same-name identity match. It preserves other establishments and
leaves the default fixture selection and checked-in seeds unchanged.

To add T13, the Gloucester proprietor and separate Grantham single-academy trust:

```powershell
.\models\schema\automation\migrate-t13-from-local-bau.ps1
```

This uses `reader` and `EPR_BAU_SQL_PASSWORD`, with the accepted separate-party
assumption in `seed/t13-controlled-proprietor.json`. It validates both import
orders in rollback transactions, identifier ownership, unknown proprietor
dates and registered identifiers, stable reimport, and rejection of unreviewed
name matches or changed fixture decisions. It preserves other establishments
and leaves the default selection and checked-in SQL seeds unchanged. As with
T11R and T12, the target must already contain reference data and the migration
schema. Repeated runs retain fresh source observations in migration evidence.

To add T14R, Bury CofE Primary School with its separate Diocese of Ely sponsor
and GRACE SCHOOLS operating trust:

```powershell
.\models\schema\automation\migrate-t14r-from-local-bau.ps1
```

This uses `reader` and `EPR_BAU_SQL_PASSWORD`. Both source links are checked
before loading. Both import orders are tested in rollback transactions; the
two party/responsibility loads are then committed together. Validation checks
separate identity, provisional sponsor fields, placeholder-date rejection,
identifier ownership, stable reverse-order reimport and unreviewed name-match
rejection. The school load commits separately. Other establishments, the
default fixture selection and checked-in SQL seeds are preserved. The target
must already contain reference data and the migration schema. Fresh source
observations may accumulate in migration evidence on repeat runs.

To add T15R, Black Country UTC and its historical single-academy trust:

```powershell
.\models\schema\automation\migrate-t15r-from-local-bau.ps1
```

The runner uses `reader` and `EPR_BAU_SQL_PASSWORD`, checks the selected source
assertions and commits the establishment and trust relationship atomically
after a rollback validation probe. It retains the non-archived source link
without making the closed responsibility current, records the inferred
responsibility end and preserves the unknown company dissolution date.
The company's legal form follows the explicit charitable-company migration
assumption; charity-register status remains unknown. The accepted closed-SAT
role/classification mapping is specific to this case. Repeat import preserves
business identities. Other establishments, default selection and checked-in
SQL seeds are unchanged; reference data and migration tables must already exist.

To refresh T16, Manchester Creative and Media Academy's historical MARCH 2016
LIMITED operating relationship, without rebuilding the database:

```powershell
.\models\schema\automation\migrate-t16-from-local-bau.ps1
```

T16 is already included in the default fixture. This standalone runner uses
`reader` and `EPR_BAU_SQL_PASSWORD`, preflights the selected source assertions,
validates an atomic rollback probe, then refreshes the establishment and its
closed MAT relationship together. It checks historical identifiers, the
distinct closure/inferred-end evidence and stable repeat import. The academy's
two other source sponsor links are not imported. Existing business identities,
other establishments, default selection and checked-in seeds are preserved.

To add T17, Langley School's historical federation membership and foundation-trust
support, without rebuilding the database:

```powershell
.\models\schema\automation\migrate-t17-from-local-bau.ps1
```

The runner uses `reader` and `EPR_BAU_SQL_PASSWORD`, checks the selected source
assertions, validates an atomic rollback probe, then commits the school and both
relationships together. A case-specific historical federation loader retains the
archived link and selected-only membership scope. Both relationship ends are
inferred from school closure; foundation support is not current despite its
non-archived source flag. The open foundation trust's role dates stay unknown
and its UID stays current. Registered trust identity remains provisional.
Repeat import preserves business identities. Beaufort and the trust's wider
portfolio are not imported; other establishments, default selection and checked-in
seeds are preserved. Reference data and migration tables must already exist.

For individual steps, import the module and create the connection objects:

```powershell
Import-Module .\models\schema\automation\EprLocalAutomation\EprLocalAutomation.psm1
$target    = New-PostgresTarget                     # establishment_local
$source    = New-BauSource -SqlServer localhost -UseWindowsAuthentication
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
| Settings | `Get-FixtureSelection` | Reads a manifest with `-Path`, or validates direct `-Urn` input. URN-only selections request discovery. |
| | `Find-EstablishmentGroupsFromBau` | Discovers supported source group links and selected-URN-only memberships before the target rebuild. |
| | `New-RunWorkspace`, `Remove-RunWorkspace` | Create and delete a working folder for one run's files. |
| Database | `Reset-EstablishmentSchema` | Drops and recreates the establishment and migration schemas. |
| | `Import-ReferenceSeed` | Loads the checked-in reference seeds. |
| | `Initialize-EstablishmentDatabase` | Both of the above. |
| | `Initialize-GovernanceDatabase` | Drops and recreates the governance schema. |
| BAU import | `Import-GeographicReferenceData` | Loads all geographic reference data from BAU. |
| | `Import-EstablishmentFromBau` | Loads one establishment. |
| | `Import-ControlledProprietorFromBau` | Validates reviewed public-extract assertions against the selected schools, then loads a shared proprietor body and separate responsibilities. Retains obfuscated local context separately; requires the rebuild run ID. |
| | `Import-EstablishmentPartyRoleFromBau` | Loads one group link as a legal entity or an explicitly reviewed person sponsor, with its role, applicable classification, group identifiers and responsibility. |
| | `Import-OrganisationGroupFromBau` | Loads a federation or children's-centre group and its complete selected membership. Children's-centre groups retain their recorded authority and current lead assertion as a separate lead period with unknown business boundaries. Existing lead periods are retained on changes; the membership flag remains a current-state summary. |
| | `Import-GovernanceFromBau` | Loads one establishment's governance appointments. |
| Checked-in SQL | `Import-CheckedInEstablishmentFixture` | Loads the checked-in establishment fixture and migration evidence. |
| | `Export-EstablishmentFixture` | Exports the database as SQL with pg_dump. |
| | `Update-CheckedInSeed` | Copies an export into `seed/`. |
| Tests | `Test-EstablishmentUrnValidation` | URN selection boundaries and parameter-validation ranges. Runs automatically with all establishment tests. |
| | `Test-EstablishmentGroupDiscovery` | Source-free checks of discovery routing, unchanged URN scope, archive opt-in and invalid/duplicate-link rejection. |
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
