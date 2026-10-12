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
            AllTestCases.ps1      complete catalogue manifest and validation
            Reports.ps1           read-only summaries
```

The entry-point scripts contain no logic of their own. Each is a short list of
module steps, so reading one shows the whole flow.

## Running the whole flow

T1 group addresses are included in both default rebuilds. The BAU path runs
`migrate-t1-addresses-from-local-bau.ps1` after the base parties are loaded;
the checked-in path restores the address associations and six-block provenance.
The scoped runner can also run independently without rebuilding:

```powershell
.\models\schema\automation\migrate-t1-addresses-from-local-bau.ps1 -SqlServer SL646104
```

T1 imports only the two available primary blocks as administrative addresses,
not verified registered offices. Blank contact/sponsor blocks create no defaults.
Unresolved county labels remain null; raw county/country/property/site metadata
is retained in migration evidence. Changed existing addresses require a reviewed
decision, not silent replacement. Rollback/load, repeat-import, conflict rejection,
foreign-key, purpose, uniqueness and writer-permission checks cover this slice.

T1's associations have `is_current = true` and null `start_date`/`end_date`.
Source observation dates are not effective business dates. Reruns retain the
existing periods. History tests exercise atomic moves, adjacent periods and
overlap rejection using synthetic rows that are rolled back. Postal values
are append-only for ordinary writers, including values shared with school sites.

Both default rebuild commands restore all 22 active scenarios across 41 distinct
establishments. T20 reuses T2. `seed/all-test-cases.json` lists every case, its
establishments and any additional runner and validator. `fixture-selection.json`
remains the base 19-establishment slice, not the complete default build scope.

The default BAU rebuild loads the base slice, runs every additional case with the
same source and target connection settings, validates the complete catalogue and
refreshes all three checked-in SQL seeds. Reviewed controlled fixtures, identity
assumptions and migration evidence are included. A failure stops the build and
prevents automatic seed refresh. The rebuild is not one database-wide transaction;
an interrupted build can leave a partial target and must be rerun.

The checked-in SQL rebuild restores that complete saved dataset and migration
evidence, then runs the same catalogue validation without SQL Server, its password
or the public extract. `run-establishment-tests.ps1` also validates the full scope.
Explicit custom BAU selections still load only their requested scope.

The case runners below remain usable independently and do not themselves refresh
seeds. The default rebuild now invokes them automatically before its final export.

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

To add T18, the complete St Elphege's federation across Croydon and Sutton:

```powershell
.\models\schema\automation\migrate-t18-from-local-bau.ps1
```

The runner uses `reader` and `EPR_BAU_SQL_PASSWORD`, preflights all three schools
and federation 1761, and commits their loads together after a validated rollback
probe. Each school retains its own authority and joining date; the federation
has no authority owner. It checks complete membership evidence and stable repeat
import. Other establishments, default fixture selection and checked-in seeds
remain unchanged. Reference data and migration tables must already exist.

To add T19R, Hazelbury's complete seven-centre group in Enfield:

```powershell
.\models\schema\automation\migrate-t19r-from-local-bau.ps1
```

The runner uses `reader` and `EPR_BAU_SQL_PASSWORD`, preflights the complete
source group and seven centres, validates a rollback probe, then commits all
loads together. It preserves centre opening dates, later membership joining
dates, Enfield authority and explicit lead codes. Hazelbury's sole current
lead assertion has unknown business start/end dates. Repeat import checks
business identities, including the lead period. Other establishments, default
selection and checked-in seeds remain unchanged; reference and migration tables
must already exist.

To add T21, Summerhill School's controlled partnership proprietor:

```powershell
.\models\schema\automation\migrate-t21-from-local-bau.ps1
```

The runner checks the 16 June 2026 extract's exact proprietor assertion and
reader-authenticated local school/context fields before target writes. A rollback
probe precedes atomic school/partnership/responsibility commit. Traditional
partnership is an explicit bounded fixture assumption, not verified registered
identity. Responsibility dates and registered proprietor identifiers remain
unknown; the separately named charity is not merged. Repeat import preserves
business identities. Other establishments, default selection and checked-in SQL
seeds remain unchanged. Reference and migration tables must already exist.

To add or correct T22, Wootton Park School's historical SAT/MAT and separate current SAT:

```powershell
.\models\schema\automation\migrate-t22-from-local-bau.ps1
```

The reader-authenticated runner preflights all three trust records and the school
before target writes. It tests an atomic rollback, commits one school and two
separate parties/roles, then tests reverse-order reimport with stable business
identities. The historical SAT/MAT pair shares a provisional entity; only the
current SAT owns the company number and organisation UKPRN. Exact suffixed Group
IDs remain on the historical role. A guarded correction splits the earlier
one-entity mapping without deleting records or reassigning registered identifiers;
its evidence is retained as superseded. Relations evidence the historical
SAT-to-MAT transition, not shared identity with the current SAT. The case records
the user's assertion and actual migration review requirement. Responsibility ends and role boundaries remain unknown. Other
establishments, default selection and checked-in seeds remain unchanged.

To migrate T8, Teign School's change between separate MAT operators:

```powershell
.\models\schema\automation\migrate-t8-from-local-bau.ps1
```

The reader-authenticated runner preflights the school and both source operators
before writes, validates an atomic rollback, commits together and tests stable
reverse-order reimport. Templer's responsibility is historical, not ended by
the successor's start. Both source-open trusts retain current MAT classifications
and GIAS identifiers with unknown role/classification boundaries. Sponsor 3642
is outside this operating slice. Default selection, seeds and unrelated school
identities remain unchanged; reference and migration tables must already exist.

To migrate T10, Outwood's shared sponsor, trust and proprietor responsibilities:

```powershell
.\models\schema\automation\migrate-t10-from-local-bau.ps1 -SqlServer SL646104
```

Uses `reader` with `EPR_BAU_SQL_PASSWORD`. Requires the existing reference and
migration tables and the local June 2026 public extract. The reviewed decision
is retained in `seed/t10-controlled-decision.json`. Eston's core uses the approved
extract values, not the conflicting BAU rejected-opening record. BAU is unchanged;
both sources and the shared-party assumption are preserved in migration evidence.
Both import orders, rollback/load, reverse reimport and unreviewed-decision
rejection are tested. Default fixture selection and checked-in seeds are unchanged;
the default rebuild now recreates this case before its complete fixture export.

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
| | `Import-OrganisationGroupFromBau` | Loads a federation or children's-centre group and its complete selected membership. Children's-centre groups retain their recorded authority and current lead assertion as a separate lead period with unknown business boundaries. Existing lead periods are retained on changes; current lead status is derived from lead periods, not a stored membership flag. |
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
