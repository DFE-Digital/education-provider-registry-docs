# Source-owned reference data

The BAU rebuild reads source-owned reference values from local MSSQL. It does not load `seed-reference-data.sql` or `seed-sen-reference-data.sql`. Those files support offline fixture rebuilds.

## Flow

1. Extract all 19 non-geographic dictionaries, including local-authority jurisdiction, before resetting the target.
2. Create the target schema and load target-owned route, role, legal-form and identifier definitions.
3. Import the complete eligible dictionaries. Reconcile source and target code/name sets in both directions.
4. Load geographic reference data and actual local-authority contacts from MSSQL.
5. Resolve establishment relationships against the imported dictionaries by source business code.
6. Validate, then export the target for offline fixture replay.

The [source transform](../establishment/transforms/reference-data-from-bau.sql) reads every dictionary row. The [loader](../establishment/load/load-reference-data-fixture.sql) records all extracted rows, inclusion flags, source tables and counts in migration run/snapshot/record evidence. Target rows are not restricted to values used by the selected establishments.

## Rules

- Preserve source labels, spelling and case. Do not substitute the old seed labels.
- Exclude archive flag `1`; accept null and zero. Reject other flag values.
- Omit Not applicable, Not recorded, Unknown and Not collected values. SEN `00` is also excluded: neither its lookup row nor establishment associations are brought across. An establishment with only code `00` has no target SEN relationship.
- Establishment status retains the supported public lifecycle codes `1`–`4`; local-authority jurisdiction retains English and Welsh.
- Each integer-keyed reference list has its own identity sequence starting at 1 and incrementing by 1. Initial source imports allocate consecutive IDs in code order. Preserve every BAU business code in a separate unique `code` column: integer for plain integers, text for leading-zero or alphabetic codes. Replays retain internal IDs and allocate new ones only for previously unseen codes.
- New dioceses use stable UUIDs from `md5('epr/diocese/' || code)::uuid`. Replays preserve any existing UUID for that code. Source row identity values are not used as business codes.
- Relationship loads, type-to-category mapping, category validation and query projections use business codes independently of internal IDs. Offline restores advance each identity sequence to its restored maximum. UUID-keyed lists retain their existing design.
- Import all eligible source rows, including values unused by the current establishment selection. Delete stale unreferenced target values; foreign keys prevent silently deleting referenced values.
- Fail on a source establishment code absent from its dictionary. A recorded exclusion becomes no relationship; an included value missing from the target is an error.

The local-authority contact import copies the source contact facts. It generates no synthetic FAKE contacts. Reviewed council identities and area periods remain a separately maintained target mapping; they are not claimed to be copied from BAU council tables.

## Expanded dictionaries: 12 November 2026

| BAU dictionary | Previously seeded | Source-driven target |
| --- | ---: | ---: |
| AdmissionsPolicy | 2 | 4 |
| Boarders | 4 | 4 |
| Diocese | 4 | 62 |
| FurtherEducationType | 9 | 8 |
| NurseryProvision | 2 | 2 |
| OfficialSixthForm | 2 | 2 |
| Section41Approved | 2 | 2 |
| TypeOfReservedProvision | 3 | 3 |

Further-education code `09` is archived in the local source and is excluded. Admissions codes `1` and `3` have null archive flags in this source, so they are included; older repository snapshots describe different archive states. The current migration uses the imported source flags. Religious character and religious ethos each expand to 48 values. The local-authority contact import carries 132 populated source contact blocks.

Establishment `137603` now retains source admissions code `1`, which the former fixed mapping discarded. The selected establishments otherwise retain their business codes and measures. Reference labels now use the source wording. Diocese identity is reproducible across independent BAU rebuilds without a reference-data SQL snapshot.

Nine importer scenarios exercise replay, source-label changes, a previously unseen diocese, archive and absence exclusions, missing dictionaries, duplicate codes, invalid flags and invalid numeric codes. All test writes roll back. The fixture export retains source-reference evidence, allowing the same checks during offline rebuilds.

Validation on 12 November 2026: the complete BAU-source rebuild and subsequent checked-in-fixture rebuild passed all nine reference-import cases, 14 SEN cases, three establishment approvals and the existing core and scope checks. The BAU run loaded 291 eligible values from 343 extracted dictionary rows. `code-lists.md` reflects the final exports, with eight lists curtailed to 50 rows.
