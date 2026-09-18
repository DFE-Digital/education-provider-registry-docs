# Establishment Local Rebuild Automation Refactor Plan

## Status

Planning document only. This document does not authorise or perform the
refactor. The existing automation remains unchanged until this plan is agreed.

## Purpose

Refactor the local Establishment PostgreSQL rebuild automation so that it has
one shared schema-and-reference-data path and two clearly separated ways to
provide Establishment records:

1. A developer with the approved local BAU SQL Server copy rebuilds
   `establishment_local` and migrates the complete establishment-centric data
   for selected establishment IDs (currently represented by URNs). That data
   may be distributed across several BAU tables keyed by the selected
   establishment ID; it is not limited to `dbo.Establishment`.
2. A developer without SQL Server rebuilds the same PostgreSQL schema and
   loads checked-in sample Establishment SQL.

Both paths must create the same physical schema, load the same checked-in
reference data, run equivalent validation, and remain restricted to local
databases.

Goal 2 has a data-provenance dependency on Goal 1: the checked-in sample
Establishment SQL is initially created by selecting approved Establishment
IDs through Goal 1, then reviewing, minimising and sanitising the resulting
Establishment-centric data. It is a repository artefact after it is created;
Goal 2 must not invoke Goal 1, require SQL Server, or require the BAU source at
runtime.

Governance migration is outside this refactor. The current combined Registry
wrapper may continue to orchestrate Governance separately, but Establishment
schema creation and Establishment data loading should no longer depend on the
Governance database or `dbo.StaffRecord`.

## Goals

### Goal 1: rebuild from selected local BAU Establishment data

The developer has:

- local SQL Server database `gias_bau_test_local`;
- populated establishment-centric source tables, including `dbo.Establishment`
  and the child tables required by the selected model slice;
- local PostgreSQL database `establishment_local`.

One command will:

1. Verify that both endpoints are approved local databases.
2. Drop and recreate the disposable PostgreSQL `establishment` schema.
3. Load all checked-in reference data.
4. Read the selected URNs from the selection manifest.
5. Extract only the selected establishment-centric rows from the required BAU
   tables, using the selected establishment IDs as the boundary.
6. Transform and load the Establishment-owned target tables.
7. Validate reference data, selected URNs, foreign-key resolution and target
   row counts.
8. When sample export is requested, persist the selected validated target
   data as PostgreSQL SQL files for Goal 2, as described below.
9. Remove temporary fixtures and credentials unless diagnostic retention was
   requested.

After the refactor, this path will be documented in
`rebuild-establishment-from-local-bau.md` and run by
`rebuild-establishment-from-local-bau.ps1`.

### Goal 2: rebuild from checked-in sample Establishment SQL

The developer has no SQL Server database. The developer needs only local
PostgreSQL and the repository.

One command will:

1. Verify the approved local PostgreSQL target.
2. Drop and recreate the same disposable `establishment` schema.
3. Load the same checked-in reference data used by Goal 1.
4. Load the selected checked-in sample Establishment SQL files.
5. Run the same target-side validation used by Goal 1.

This path will have a standalone runbook and PowerShell entry point in this
directory:

```text
rebuild-establishment-from-checked-in-sql.md
rebuild-establishment-from-checked-in-sql.ps1
```

The runbook will follow the structure of the existing documentation, but it
will have no SQL Server,
BAU access, SQL Server login or temporary CSV prerequisite.

## Current State And Problems To Resolve

The current implementation has the right building blocks, but their
responsibilities overlap:

- `core-establishment-schema.sql` is the shared disposable physical baseline.
- `seed-reference-data.sql` seeds only part of the required reference data.
- `load-establishment-fixture.sql` also inserts reference data, even though it
  should load Establishment-owned rows only.
- Individual sample Establishment SQL files repeat inserts for several
  reference tables.
- `seed-local-authorities-from-bau.ps1` and
  `seed-government-office-regions-from-bau.ps1` pull reference data from SQL
  Server on every source-backed rebuild.
- `establishment-from-bau.sql` joins several SQL Server lookup tables without
  clearly separating reference data from the selected establishment-centric
  source slice.
- The current main runbook combines Establishment and Governance concerns.

These overlaps make the two developer experiences diverge and make a rebuild
depend on BAU lookup tables that should instead be supplied by the shared
checked-in reference seed. The refactor must still support multiple BAU tables
for establishment-centric data where the target slice requires them.

## Reference And Static Fixture Data Inventory

The following tables should be populated from checked-in, hard-coded SQL for
both goals.

### Controlled reference tables

| Table | Current role | Proposed source |
| --- | --- | --- |
| `establishment.establishment_type` | Establishment classification | Checked-in reference SQL |
| `establishment.education_phase` | Education phase classification | Checked-in reference SQL |
| `establishment.gender_of_entry_type` | Gender-of-entry classification | Checked-in reference SQL |
| `establishment.admissions_policy` | Admissions classification | Checked-in reference SQL |
| `establishment.boarding_provision` | Boarding classification | Checked-in reference SQL |
| `establishment.nursery_provision` | Nursery classification | Checked-in reference SQL |
| `establishment.sixth_form_provision` | Sixth-form classification | Checked-in reference SQL |
| `establishment.specialist_provision_type` | Specialist-provision classification | Checked-in reference SQL |
| `establishment.establishment_status` | Establishment lifecycle status | Checked-in reference SQL |
| `establishment.reason_establishment_opened` | Opening reason | Checked-in reference SQL |
| `establishment.reason_establishment_closed` | Closing reason | Checked-in reference SQL |
| `establishment.local_authority_jurisdiction` | English/Welsh jurisdiction | Checked-in reference SQL |
| `establishment.local_authority` | Local-authority code and name | Checked-in reference SQL |
| `establishment.government_office_region` | GOR code and name | Checked-in reference SQL |

### Static local fixture data

| Table | Treatment |
| --- | --- |
| `establishment.local_authority_contact` | Seed from checked-in SQL for the local fixture. These are contacts associated with reference organisations rather than a taxonomy. Keep any synthetic contacts clearly labelled as fake and deterministic. |

`local_authority_contact` is not reference data in the strict domain sense
because contact information can change independently. It is nevertheless a
static prerequisite for these local fixtures, so it belongs in the shared
seed phase requested for both goals.

### Establishment-owned data

The following tables must not be placed in the shared reference seed. Goal 1
populates them from the selected establishment-centric BAU slice; Goal 2
populates them from checked-in sample Establishment SQL:

- `establishment.establishment`
- `establishment.establishment_geography`
- `establishment.establishment_contact`
- `establishment.establishment_lifecycle`
- `establishment.address`
- `establishment.site`
- `establishment.establishment_to_site`
- `establishment.capacity_and_pupil_measures`
- `establishment.education_admissions_and_provision`
- `establishment.statutory_age_range`
- `establishment.specialist_provision`
- `establishment.resourced_provision`
- `establishment.sen_unit_provision`

## Proposed Design

### Shared target initializer

Introduce one reusable operation responsible for target setup:

```text
Assert local PostgreSQL target
    -> apply core-establishment-schema.sql
    -> apply complete checked-in reference/static-fixture seed
    -> validate reference seed
```

Both modes of the rebuild command must call this operation. Neither Establishment data
provider may create or update reference rows.

Keep `seed-reference-data.sql` as one complete SQL file. Split it only if its
size actually prevents review; do not introduce one file per reference table.

Recommended internal ordering is:

1. `local_authority_jurisdiction`
2. classification and lifecycle lookup tables
3. `local_authority`
4. `government_office_region`
5. `local_authority_contact`

Hard-coded UUID reference keys should be stable across rebuilds. Integer IDs
and codes must also remain explicit and must not be renumbered casually.

### Goal 1 provider: local SQL Server Establishment extraction

Refactor the SQL Server extraction so its source boundary is the selected
establishment-centric slice. The root identity is read from:

```text
gias_bau_test_local.dbo.Establishment
```

Additional establishment-centric tables may be read when they contain data for
the selected establishments. For example, the current model identifies
`dbo.EstablishmentAdditionalAddresses` as a source for additional sites. The
implementation must maintain an explicit source-table inventory and require a
join/filter through the selected establishment ID for every such table.

The initial source inventory should therefore distinguish:

| Source table | Classification | Selection rule |
| --- | --- | --- |
| `dbo.Establishment` | Establishment-centric root | `URN` is in the selected ID set |
| `dbo.EstablishmentAdditionalAddresses` | Establishment-centric child data, where additional sites are in scope | `URN` is in the selected ID set |
| Any further BAU table added to the slice | Establishment-centric only if it is directly or transitively keyed to the selected establishment | Must be documented and filtered to the selected ID set |
| `dbo.EstablishmentType`, `dbo.EducationPhase`, `dbo.GovernmentOfficeRegion` and similar dictionaries | Reference data | Not read by the routine Goal 1 extractor; supplied by checked-in seed SQL |

This inventory is a design boundary, not a claim that the two example tables
are the complete long-term BAU source. The source-table list must be reviewed
against the target slice before implementation.

It should select raw BAU codes such as `type_code`, `educationPhase_code`,
`status_code`, reason codes, `LA_code` and `GOR_code`, plus the fields needed
from other selected-establishment tables. It must not join BAU lookup tables
to obtain reference labels; those labels and mappings belong to the shared
checked-in reference/mapping data.

BAU-code-to-target-ID decisions must be held in checked-in transformation
logic. They should be centralised rather than repeated across PowerShell,
source SQL and target SQL. The preferred implementation is a reviewed mapping
section within the existing PostgreSQL loader; it keeps migration-specific BAU
codes out of the target domain tables while allowing unresolved mappings to
fail explicitly.

The source-backed wrapper should:

- use `one-organisation.json` as the selected URN manifest unless a replacement
  manifest is agreed;
- prompt once for the local SQL Server reader credential;
- retain the existing bounded per-URN extraction initially, using explicit
  columns and separate result sets for one-to-many child records;
- write a target-shaped temporary fixture;
- call the shared PostgreSQL Establishment loader;
- fail if a required source code cannot be resolved to seeded reference data.

The existing local SQL Server copies of `LocalAuthority`,
`GovernmentOfficeRegion` and other lookup tables may be retained for
investigation, but routine Goal 1 execution will not depend on them.

### Goal 2 provider: checked-in sample Establishment SQL

Refactor each `seed-<establishment>-<urn>.sql` file so it contains only
Establishment-owned rows. Remove duplicated inserts into classification and
reference tables.

Each sample file should assume that the shared initializer has already loaded:

- every referenced classification ID;
- its local authority;
- its Government Office Region;
- any static local-authority contact fixture.

The sample runner should support:

- the documented default sample set;
- a `-SeedFile` array for an explicit subset when called from PowerShell;
- local-only target guards;
- fail-fast `psql` execution;
- the shared target validation step.

No source credential, SQL Server provider, CSV extraction or BAU database is
permitted on this path.

The sample SQL files are versioned fixtures, not a second live source system.
When the target model or mapping changes, the fixtures must be regenerated or
reviewed against the Goal 1 extraction contract and updated deliberately. The
Goal 2 runbook should record the source/provenance date, selected Establishment
IDs, sanitisation status and any intentional differences from BAU.

## Proposed Automation Shape

Use two explicit rebuild entry points, one for each developer decision. Share
the setup, reference seeding, error handling, validation and database helpers
behind them. Reuse the existing extraction/loader pair. Proposed executable
files are limited to the two entry points, target validation SQL and sample
export SQL:

```text
automation/
  common/
    local-database-guards.ps1
    sql-client-functions.ps1
  rebuild-establishment-from-local-bau.ps1       # Goal 1; optional sample export
  rebuild-establishment-from-checked-in-sql.ps1  # Goal 2; no SQL Server
  invoke-establishment-migration.ps1         # existing SQL Server adapter

establishment/
  core-establishment-schema.sql              # existing baseline
  transforms/establishment-from-bau.sql      # existing extraction
  load/load-establishment-fixture.sql        # existing mapping + loading
  validate-establishment-fixture.sql         # shared assertions
  export-establishment-fixture.sql           # selected target rows -> SQL

seed/
  seed-reference-data.sql                     # single reference seed entry point
  seed-<establishment>-<urn>.sql               # establishment-owned rows only
```

Keep initialization as shared functions called by both entry points and
execute validation SQL directly; separate PowerShell scripts for these steps
would add indirection without another caller. Do not introduce a provider
framework, configuration classes or a general-purpose export engine.

Proposed commands from the repository root (not implemented yet):

```powershell
# Goal 1: use the existing URN manifest and local BAU SQL Server
& ./models/schema/automation/rebuild-establishment-from-local-bau.ps1

# Goal 1: also generate selected samples for review and check-in
& ./models/schema/automation/rebuild-establishment-from-local-bau.ps1 -ExportSamples

# Goal 2: use checked-in sample SQL, without source credentials
& ./models/schema/automation/rebuild-establishment-from-checked-in-sql.ps1
```

Keep the existing `one-organisation.json` as the Goal 1 selection. For Goal 2,
retain the current four sample files as the default list in the entry point;
do not introduce another manifest. Source and sample selections may differ.

Rename/replace `rebuild-and-seed-establishment.ps1` with
`rebuild-establishment-from-checked-in-sql.ps1` after updating its callers and
documentation. Split the Establishment portion of
`rebuild-and-run-registry-data-fixture.ps1` into
`rebuild-establishment-from-local-bau.ps1`. Keep the combined
Registry/Governance wrapper as a thin composition of the new Local BAU command
and existing Governance runner, preserving its current purpose. The two
standalone runbooks document the two developer choices; the combined command
is documented separately as orchestration.

Remove the two BAU reference seed runners and their dedicated transforms/loaders
once their reviewed values are captured in `seed-reference-data.sql` and no
callers remain. Preserve the shared helpers used by Governance.

### Persisting samples from Goal 1

Make export an explicit `-ExportSamples` option after a successful Goal 1 load
and validation. Export the transformed PostgreSQL records, so Goal 2 does not
duplicate BAU mapping logic. Emit one SQL file per selected URN, containing
explicit column lists and dependency-ordered inserts for establishment-centric
records, including additional sites. Reference rows are excluded.

Use PostgreSQL literal quoting in the export SQL to preserve NULLs, quotes,
Unicode and line breaks. Select rows by the URN and its related keys; never
export the whole database. Preserve internal UUID relationships within each
file and use the stable reference IDs from the shared seed. Exported files
target a freshly rebuilt schema; independent upsert/replay semantics are not
required for every sample file.

Write candidate files to a local output directory for review before replacing
the checked-in sample files. Include provenance and intentional sanitisation
in SQL comments, avoiding a separate metadata file. Export is not an automatic
Git commit. Keep the exporter specific to the 13 model tables and add coverage
when the model grows. Repeated export of the same loaded data must have stable
ordering; comparisons across rebuilds use URNs and business values where UUIDs
are generated anew.

### Implementation details that keep the code small and correct

- Source extraction returns explicit named columns. Read them by column name
  and consume every result set; remove the parallel positional header lists
  currently maintained in PowerShell.
- Keep raw BAU codes in temporary fixtures and map once in the PostgreSQL
  loader. Replace fallback mappings that silently classify unknown values.
- Use proper CSV serialization instead of replacing delimiters in field values.
- Check credentials, required source tables, selected URNs and input files
  before executing the destructive local schema rebuild. Guard the exact
  `establishment_local` target in both modes.
- Keep the existing ten clearly labelled fake local-authority contacts as
  static seeds. Capture the other missing reference values once, with provenance.
- Reuse one source connection per run if straightforward. Retain per-URN
  queries until measured volume justifies batching; do not multiply parent
  rows by flattening one-to-many child tables into a single join.

## Validation Contract

Both goals should run the same target validation and fail on any violation.

### Schema and reference validation

- All expected physical tables exist.
- Every listed reference/static-fixture table contains its expected rows.
- Codes and names that are defined as unique contain no duplicates.
- All hard-coded foreign keys resolve.
- GOR codes remain text values; values such as `A`, `B`, `H`, `W` and `Z` are
  not coerced to integers.

### Establishment validation

- Every selected/default URN exists exactly once in
  `establishment.establishment`.
- No unexpected URNs were loaded when an explicit selection was supplied.
- Each populated source code resolves to the intended target reference row.
- Required lifecycle, classification and owned-substructure relationships are
  present.
- There are no orphaned rows.
- The validation output reports counts and identifiers without exposing
  sensitive data.

### Path-parity validation

For a sample URN represented in both paths, compare a stable target projection
from Goal 1 and Goal 2. Identity, classification, geography, lifecycle,
contact, site and provision fields should agree except where the sample SQL is
explicitly synthetic and documented as such.

## Documentation Changes During The Refactor

### Goal 1 runbook: `rebuild-establishment-from-local-bau.md`

Create/update `rebuild-establishment-from-local-bau.md` so that it clearly
documents:

- the establishment-centric source dependency, rooted at `dbo.Establishment`
  and including any additional selected-establishment tables;
- schema rebuild and complete checked-in reference-data seeding;
- selected-URN extraction;
- credential and temporary-file handling;
- target validation;
- the separate status of Governance orchestration.

The runbook must no longer say that Establishment migration requires BAU
lookup tables once that dependency has been removed.

### Goal 2 runbook: `rebuild-establishment-from-checked-in-sql.md`

Create `rebuild-establishment-from-checked-in-sql.md` with equivalent
sections:

- purpose;
- prerequisites;
- command;
- optional sample selection;
- internal execution flow;
- reference-data behaviour;
- validation;
- troubleshooting.

It should state prominently that it requires no SQL Server database and does
not attempt to reproduce a live BAU extract.

## Implementation Sequence

1. Agree this plan and the classification of the 15 shared seed tables.
2. Capture and review the hard-coded `local_authority`,
   `government_office_region` and local contact fixture values.
3. Complete `seed-reference-data.sql` and add reference-seed validation.
4. Remove reference inserts from `load-establishment-fixture.sql`.
5. Remove reference inserts from every sample Establishment SQL file.
6. Refactor the BAU extraction to read the selected establishment-centric
   source tables while removing joins to BAU lookup/reference tables.
7. Centralise and test BAU-code-to-target mappings.
8. Introduce the two explicitly named rebuild commands and shared validation
   SQL.
9. Wire `rebuild-establishment-from-local-bau.ps1`, including sample export,
   and update its Goal 1 runbook.
10. Wire `rebuild-establishment-from-checked-in-sql.ps1`, add its Goal 2
    runbook, and update the combined wrapper.
11. Run Goal 1, export a sample, rebuild through Goal 2 with that export, and
    compare target projections and child-row counts. Include the additional-site
    example, text GOR codes, NULL values and text requiring SQL/CSV quoting.
12. Retire superseded scripts only after both paths pass.

## Acceptance Criteria

- Goal 1 succeeds with the documented establishment-centric source tables
  available in the local SQL Server copy, without requiring BAU lookup tables
  because reference data is seeded from checked-in SQL.
- Goal 2 succeeds on a machine with no SQL Server installation or source data.
- Goal 2's checked-in Establishment fixtures have documented provenance from
  an approved Goal 1 extraction or an explicitly approved synthetic fixture.
- Both paths use the same physical schema and reference seed.
- Reference data is not inserted by Establishment loaders or sample school
  files.
- All 14 controlled reference tables and the static
  `local_authority_contact` fixture are loaded before Establishment data.
- Unknown or unmapped BAU codes fail with an actionable error.
- Both paths are repeatable from an empty local PostgreSQL target.
- Local database guards prevent either path from targeting shared, Test,
  staging or production databases.
- Credentials and transient extraction files are not committed and are removed
  after execution by default. Reviewed sample SQL exports are intentionally
  retained and checked in for Goal 2.
- Goal 1 generates the sample SQL; Goal 2 replays it without BAU mapping or
  SQL Server dependencies. The round trip preserves the selected slice.
- Goal 1 and Goal 2 each have an accurate standalone runbook.

## Review Findings And Recommended Decisions

The revised design uses two explicit developer-facing entry points, one shared
reference seed, one mapping/load implementation and one shared validator. The
entry-point names make the decision visible without remembering a `-Source`
value:

| Developer choice | Runbook | PowerShell entry point |
| --- | --- | --- |
| Goal 1: extract selected establishment-centric data from the local BAU SQL Server | `rebuild-establishment-from-local-bau.md` | `rebuild-establishment-from-local-bau.ps1` |
| Goal 2: rebuild from checked-in sample SQL | `rebuild-establishment-from-checked-in-sql.md` | `rebuild-establishment-from-checked-in-sql.ps1` |

The existing combined wrapper stays as a small composition command for
Governance users. No extra initializer, validator PowerShell wrapper,
per-table reference scripts or replacement selection manifest is proposed.

The current schema inventory confirms 28 tables: 14 controlled references,
one static contact fixture and 13 establishment-centric tables. Reference
seeding currently covers only part of that inventory. The sample runner also
lacks the local-target guard used by the source workflow. Both gaps are
implementation requirements, not reasons to introduce another framework.

The source SQL already returns additional addresses, while the current
PowerShell adapter reads the first row from the first result set. Refactoring
must consume child result sets explicitly to satisfy the multi-table slice.
The export/replay comparison above must prove that those rows survive.

This review changes the plan only. Implementation and database execution
follow agreement of the plan.
