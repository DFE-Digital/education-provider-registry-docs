# Rebuild Establishment From Local BAU

## Purpose

This is the BAU-source rebuild. It rebuilds the local PostgreSQL Establishment schema and
migrates the selected establishment-centric records from the approved local
BAU SQL Server copy. The selection is read from
models/schema/seed/fixture-selection.json.

## Prerequisites

- Local SQL Server copy gias_bau_test_local, with a read-only reader login.
- The selected establishment-centric BAU tables, including
  dbo.Establishment and any required child tables, plus dbo.LSOA and dbo.MSOA
  for the geographic reference-data load.
- Local PostgreSQL database establishment_local.
- PostgreSQL credentials available through pgpass.conf.

The script never connects to BAU Test, shared, staging or production systems.

## How to run

From education-provider-registry-docs, using the local SQL reader login:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1"

The command prompts once for the local SQL Server reader password, unless
EPR_BAU_SQL_PASSWORD is set. Use -KeepFixture to retain the run's working folder of
extracted CSV fixtures for troubleshooting.

When the local BAU copy is configured for Windows authentication:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\models\schema\automation\rebuild-establishment-from-local-bau.ps1" -SqlServer SL646104 -UseWindowsAuthentication

After validation succeeds, the command exports the target into the run's
working folder and copies the reference, establishment and migration-evidence seed files into
`models/schema/seed/`. It does not commit those file changes; review them with
`git diff` before committing. To export somewhere else for review without
touching `seed/`, supply `-ExportDirectory`.

## Execution flow

1. Check that the SQL Server source and PostgreSQL target are local.
2. Recreate the establishment and migration schemas, and load the checked-in reference seeds (`Initialize-EstablishmentDatabase`).
3. Load geographic reference data from the local BAU copy (`Import-GeographicReferenceData`): local authorities, Government Office Regions, districts, wards, parliamentary constituencies, LSOAs, MSOAs, urban/rural classifications, GSS local-authority codes, and the local-authority to GSS and GOR mappings.
4. Load each selected URN (`Import-EstablishmentFromBau`), then each selected group link (`Import-EstablishmentPartyRoleFromBau`), organisation group and reviewed controlled proprietor fixture (`Import-ControlledProprietorFromBau`).
5. Print the loaded establishments with their pupil and free-school-meal measures (`Show-EstablishmentSummary`).
6. Run all establishment tests (`Invoke-EstablishmentTests`): core validation, groups validation, an approval snapshot per selected URN, and scope.
7. Export the database and refresh the checked-in seed files (`Export-EstablishmentFixture`, `Update-CheckedInSeed`).
8. With `-IncludeGovernance`, recreate the governance schema and load each URN's governance appointments.
9. Delete the run's working folder, unless `-KeepFixture` is supplied.

After the run, add or update one establishment case file under `models/schema/establishment/cases/` for every T represented by the extract. Include its URN, name, establishment type and relevant group links.

Each numbered step is a function in the `EprLocalAutomation` module, and can be run on its own. See the [automation README](README.md).

T4 selects federation UID 1809 through `organisationGroups` in the fixture selection. The existing rebuild imports both member establishments, URNs 109443 and 109613, then the federation and memberships. The source member set must match the selection exactly. The federation creates an organisation group, not a legal entity or establishment responsibility. T4a's separate foundation-trust link 1094 is not selected. Federation validation and both establishment approval snapshots run through the existing test command.

T5 selects children's-centre group UID 86052, Southend Children's Centres, through the same `organisationGroups` selection. It imports all nine centres and memberships, the recorded group authority Southend-on-Sea (882), and the explicit `ccLinkType` values: Cambridge Road (URN 20549) is the lead member; the other eight are standard members. The shared organisation-group transform and loader handle T4 and T5 without another PowerShell entry point. Missing school-capacity measures and statutory school-age ranges do not create empty optional rows. T5 membership/evidence validation and nine establishment approval snapshots run through the existing test command.

T6 selects Hadrian Park Primary School, URN 132141, and source trust UID 1337 through `establishmentPartyRoleResponsibilities`. The existing party loader creates one separate provisional legal entity, one Foundation trust role and one current Supported by foundation trust responsibility from 1 September 2011. GIAS UID 1337 belongs to the role. No company number, trust UKPRN, legal type, incorporation date or role start date is invented. The source group open date and GroupLink 1029 are retained in migration evidence; the role's first observation comes from the import snapshot date, not the source group open date. Same-name UID 1596 and the trust's other links are not selected. The existing test command runs foundation-support validation and the establishment approval snapshot.

T7 selects Fulwood Academy, URN 135936, sponsor UID 2613 and operating trust UID 3147 through the same party-link selection. An explicit reviewed mapping creates a person endpoint for Charles Dunstone, not a legal entity. The academy's sponsor page supports that interpretation. UID 2613 and SP00099 identify the person's school-sponsor role; UID 3147 and TR00830 identify Dunstone Education Trust's academy-trust role. Both responsibilities begin on 1 September 2009, while role and MAT-classification starts remain unknown. The sponsor's placeholder source open date stays in migration evidence, not target business dates. Tests validate the separation, repeated person-UID reuse, rejection of party-kind conflicts and the required review evidence. No additional PowerShell entry point or live-schema change is needed.

T3 (Ridgewood School, URN 137603) is included in the selection. Its SAT 2055 and
MAT 20364 are resolved to one legal entity using the reviewed identifiers and
explicit predecessor/successor relationships. Each source link supplies its own
responsibility: historical SAT from 1 November 2011 and current MAT from 30 March
2021, both with unknown end dates. SAT/MAT classifications meet on 30 March
2021; their dates are not copied into responsibility boundaries. The transform
rejects missing or changed transition evidence. Migration
evidence and identity decisions are exported alongside the target fixture.

Each BAU establishment rebuild creates one `migration.migration_run` for its group evidence. Every selected party-link extract retains its own `source_snapshot` and `source_record` beneath that run, so source-level lineage is unchanged. The run is `running` during import and validation, `completed` after successful validation, or `failed` if the rebuild fails. The source database name is recorded from the connection settings. An independently invoked party-link loader, without a rebuild run ID, still creates a separate mini-migration run. A checked-in SQL rebuild restores the captured run rather than claiming that a fresh BAU extraction took place.

Reference dictionaries are runtime inputs only for this current implementation;
the target schema and checked-in seed remain the shared baseline for the
checked-in-fixture rebuild.

T9 selects Underley Garden School (112461) and Heath Farm School (119009) through `controlledProprietors`. The shared core loader maps their Other independent special school type. The controlled proprietor importer checks both exact `PropsName` assertions against the checked-in 16 June 2026 extract before resolving them to one explicitly allocated Acorn Care and Education Ltd legal entity. It creates two current Proprietor responsibilities with unknown dates, no proprietor party role and no group identifiers. Legal form, registered company identity and ownership remain unverified. The local Individual Proprietor classifications and numbered-proprietor counts are retained as separate context, not silently converted into body identities. Public-extract observation dates stay separate from local snapshot and import dates. Both evidence sources sit beneath the same rebuild run and are exported with the fixture. The existing test entry point validates shared identity, provenance, date handling, idempotent reimport and rejection of missing review or conflicting decisions. No additional PowerShell entry point or live-schema table is needed.

## Scope boundary

By default this command migrates Establishment-owned data for the selected
URNs. It rebuilds the Governance schema and migrates StaffRecord only when
`-IncludeGovernance` is supplied.
