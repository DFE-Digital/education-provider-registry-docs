# T22: URN 142869, Wootton Park School

T22 tests a classification change within one historical legal entity, followed by a change of operator to a separate current legal entity. The historical SAT and MAT are treated as the same entity; the current SAT is treated as different, despite the shared Group ID stem and source opening date. This is the user's accepted test-case assertion, not independently verified registered identity.

## Establishment

| Field | Value |
| --- | --- |
| URN | 142869 |
| Name | Wootton Park School |
| Establishment number | 4020 |
| Source type | Free schools (35) |
| Type group | Free schools |
| Education phase | All-through (7) |
| Local authority | Northamptonshire, code 928 |
| Source status | Open (1) |
| Establishment UKPRN | 10056995 |
| Open date | 2016-09-01 |
| Close date | Unknown |

## Source groups and relationships

The local BAU observations on 9 October 2026 contain exactly these three GroupLinks for this school:

| Source field | Historical SAT | Historical MAT | Current SAT |
| --- | --- | --- | --- |
| Group UID | 16279 | 17115 | 17397 |
| Exact name | THE NORTHAMPTON FREE SCHOOL TRUST | THE NORTHAMPTON FREE SCHOOL TRUST | WOOTTON PARK ACADEMY TRUST |
| Group ID | TR03305.old | TR03305.old2 | TR03305 |
| Type code | 10 | 06 | 10 |
| Companies House number | Unknown | Unknown | 08782697 |
| Organisation UKPRN | Unknown | Unknown | 10064301 |
| Group open date | 2013-11-20 | 2013-11-20 | 2013-11-20 |
| Group closed date | 2018-10-09 | 2019-07-09 | Unknown |
| GroupLink ID | 25267 | 28287 | 29262 |
| Effective date | 2016-09-01 | 2018-10-09 | 2019-07-09 |
| Archived | 1 | 1 | 0 |

GroupRelationsLink 25 links UID 16279 to UID 17115 with type 1M; relation 26 records the reverse 1S assertion. Both establishedDate and systemLinkDate are 2018-10-09. These are the only relations involving the three selected groups. They explicitly support the historical SAT-to-MAT transition. No relation explicitly establishes shared identity with the current SAT or a later return to SAT.

## Identity and date interpretation

For this bounded test case, treat historical UIDs 16279 and 17115 as one provisional THE NORTHAMPTON FREE SCHOOL TRUST legal entity. Their common name, Group ID stem, source opening date and explicit predecessor/successor relations support the accepted consolidation. Their company number and organisation UKPRN remain unknown. Do not copy the current SAT's identifiers onto them. Historical legal form, incorporation, charity-register status and dissolution remain unknown; source openDate 2013-11-20 is retained as evidence rather than asserting incorporation without a registered company identity.

Treat UID 17397 as a separate WOOTTON PARK ACADEMY TRUST legal entity, owning company number 08782697 and organisation UKPRN 10064301. For this current company only, map 2013-11-20 as source-derived incorporation, not independently verified Companies House incorporation. Its assumed legal form is Charitable company limited by guarantee; charity-register status and dissolution remain unknown. School UKPRN 10056995 stays on the establishment.

This two-entity interpretation is an accepted user assertion for testing. BAU does not independently prove it, and shared names, Group ID stems or source opening dates cannot settle legal identity. Actual migration requires a recorded manual identity and lifecycle decision.

The historical SAT classification has unknown start and ends on 2018-10-09; the historical MAT classification starts on that date, supported by relations 25/26. Its end is 2019-07-09 under the bounded source-group-closure interpretation. Closing that group does not prove company dissolution or establish an end to its Academy trust role. The separate current SAT classification has unknown start and end. Its school responsibility starts on 2019-07-09, but that does not establish when the company became a SAT.

Each entity has its own Academy trust role with unknown business boundaries. The historical entity has two historical Run by academy trust responsibilities, typed SAT and MAT, retaining their individual GroupLink starts. The current entity has one current SAT responsibility. All responsibility ends remain unknown; a new operator's start is not copied into the old operator's end. Dates use inclusive starts and exclusive ends without adding a day.

## Relationship graph

```text
Historical entity: THE NORTHAMPTON FREE SCHOOL TRUST
  Registered identifiers and incorporation unknown
  One Academy trust role: start/end unknown
  Classifications: SAT [unknown, 2018-10-09)
                   MAT [2018-10-09, 2019-07-09)
  Historical responsibilities for Wootton Park School:
    SAT from 2016-09-01, end unknown
    MAT from 2018-10-09, end unknown

Separate current entity: WOOTTON PARK ACADEMY TRUST
  Company 08782697 / organisation UKPRN 10064301
  One Academy trust role: start/end unknown
  Current SAT classification: start/end unknown
  Current SAT responsibility from 2019-07-09, end unknown

The same school, URN 142869, retains its identity throughout.
```

## Expected target representation

| Target | Expected result |
| --- | --- |
| Establishment and lifecycle | One open Free school, retaining its own URN, UKPRN, authority, phase and opening date. |
| Legal entity | Two parties: one provisional historical entity with unknown registered identity, legal form and incorporation; one separate current company with source-derived incorporation 2013-11-20 and assumed charitable-company legal form. Both dissolution dates and charity-register statuses unknown. |
| Organisation identifiers | Company 08782697 and UKPRN 10064301, both current and owned only by the current entity. No organisation identifiers on the historical entity. |
| Academy trust role | Two separate roles with unknown business boundaries. The historical pair shares one role. |
| Classifications | Historical entity has SAT then MAT; separate current entity has one current SAT with unknown start. Three rows in total. |
| Responsibilities | Three Run by academy trust rows, one per source link and start date; all ends unknown and only the final SAT current. |
| Group identifiers | Historical UIDs 16279/17115 and suffixed Group IDs on the historical role; UID 17397 and TR03305 on the separate current role, issuer GIAS. Only UID 17397 and TR03305 current; suffixed IDs remain historical. |
| Migration evidence | All source links, original archive flags, explicit historical transition relations, two-entity identity assertion and bounded historical MAT closure interpretation retained outside the live model. |
| Other relationships | No sponsor, proprietor, person, federation or children's-centre membership created. No other schools or wider trust portfolio imported. |

## Target query

```sql
SELECT e.urn, le.legal_entity_id, le.name AS responsible_party, tt.name AS trust_type,
       r.start_date, r.end_date, r.is_current
FROM establishment.establishment e
JOIN establishment.establishment_responsibility r USING (establishment_id)
JOIN establishment.legal_entity le USING (legal_entity_id)
JOIN establishment.academy_trust_type tt USING (academy_trust_type_id)
WHERE e.urn=142869
ORDER BY r.start_date;

SELECT le.name, tt.name AS classification, c.start_date, c.end_date, c.is_current
FROM establishment.academy_trust_classification c
JOIN establishment.legal_entity le USING (legal_entity_id)
JOIN establishment.academy_trust_type tt USING (academy_trust_type_id)
WHERE c.legal_entity_id IN (
    SELECT r.legal_entity_id FROM establishment.establishment_responsibility r
    JOIN establishment.establishment e USING (establishment_id)
    WHERE e.urn=142869
)
ORDER BY le.name, c.start_date NULLS FIRST;
```

## Expected checks and evidence limits

- Exactly one school, two legal entities, two Academy trust roles, three classifications and three operating responsibilities exist.
- Historical identifiers retain their exact suffixes and remain attached to the historical role, without being made current.
- The current SAT belongs to a different legal entity, not a return to SAT by the historical entity.
- Unknown role boundaries, initial historical SAT and current SAT classification starts, responsibility ends and dissolution remain null.
- The historical SAT-to-MAT transition is explicit; the later school link is treated as a change of operator under the accepted assertion, not an evidenced legal-identity fact.
- Registered identifiers supplied by the current SAT remain exclusive to the current party. Historical registered identity remains unknown.
- Reverse-order reimport preserves all business UUIDs and produces no duplicate parties, classifications or responsibilities.
- Changed source assertions or conflicting identifier ownership require review, not automatic stem/name merging or silent reassignment.
- This is a bounded school-level migration, not independent company verification or a complete trust-portfolio migration.
