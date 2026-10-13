# T10 — Outwood Grange Academies Trust has three kinds of responsibility

T10 tests that Outwood Grange Academies Trust is recorded as one legal entity running and sponsoring Outwood Grange Academy and acting as proprietor of Outwood Alternative Provision Eston, without asserting ownership of either school's business or premises.

## One party, different responsibilities

The selected slice contains two establishments, one legal entity, two party roles and three establishment responsibilities. The Academy trust and School sponsor roles have separate GIAS group identifiers. Proprietorship is a responsibility directly held by the same legal entity; it does not create a third party-role type.

Only one academy is selected to exercise operator and sponsor coexistence. The wider Outwood portfolio is outside this slice.

## Establishments

| Field | T10a — independent school | T10b — academy |
| --- | --- | --- |
| URN | 148341 | 135961 |
| Establishment name | Outwood Alternative Provision Eston | Outwood Grange Academy |
| Establishment type | Other independent school (source code 11) | Academy sponsor led (source code 28) |
| Accepted extract status | Open (1) | Open (1) |
| Accepted extract open date | 2021-02-18 | 2009-09-01 |
| Accepted extract close date | Null | Null |
| Accepted extract school UKPRN | 10092329 | 10028145 |
| Accepted extract local authority | Redcar and Cleveland (807) | Wakefield (384) |
| Exact extract `PropsName` | Outwood Grange Academies Trust | Empty |

These establishment and proprietor assertions come from the 16 June 2026 establishment extract, `edubasealldata20260616.csv`. The selected values are reproduced above. The academy's identity and lifecycle agree with the selected local source record; the independent school's do not, as described below.

The school's UKPRNs identify the establishments. Neither is the trust's organisation UKPRN.

## Local group and relationship evidence

| Field | Academy-trust record | Sponsor record |
| --- | --- | --- |
| Source name | OUTWOOD GRANGE ACADEMIES TRUST | Outwood Grange Academies Trust |
| Group UID | 4119 | 4118 |
| Group ID | TR01585 | SP00396 |
| Group type | Multi-academy trust (06) | School sponsor (05) |
| Companies House number | 06995649 | Null |
| Organisation UKPRN | 10058273 | Null |
| Source group open date | 2009-08-19 | 1900-01-01 — placeholder |
| Source group closed date | Null | Null |
| Source group local-authority code | 999 (not recorded) | 999 (not recorded) |
| Selected establishment | Outwood Grange Academy, URN 135961 | Outwood Grange Academy, URN 135961 |
| GroupLink ID | 5716 | 5254 |
| Link effective date | 2009-09-01 | 2009-09-01 |
| Link archived / version | 0 / 0 | 0 / 0 |
| Link `linkType` / `ccLinkType` | Both null | Both null |

Both selected links are active and supply non-placeholder responsibility starts. The local active link sets for UIDs 4118 and 4119 are identical and non-empty, with 21 active links each. The full local sets contain 25 sponsor rows and 24 MAT rows, each covering 24 distinct URNs. These counts are local observations, not the 40-academy June-extract portfolio, and they do not imply that every unselected link is clean.

The reviewed sponsor-to-trust identity resolution uses the matching names and shared active link set alongside the identified MAT party. The sponsor does not independently supply a company number or UKPRN. Preserve that identity decision rather than treating name equality alone as a universal matching rule.

Both sponsor address blocks and the trust contact block are blank. The MAT primary block is `Potovens Lane`, `Outwood`, `obfuscated`, `Wakefield`, `WF1 2PF`. The source supplies no county, UPRN or site name. The primary block is one current administrative association on the accepted shared legal entity, with unknown business dates. The source does not establish registered-office meaning, and the source-obfuscated third line is retained unchanged.

## Controlled proprietor and establishment evidence

The accepted proprietor assertion resolves the independent school's exact extract `PropsName` to the same Outwood legal entity. This is an explicitly accepted proprietor-identity assumption for this controlled fixture, not a direct identity match from the obfuscated local proprietor fields.

The local copy of URN 148341 differs from the accepted extract:

| Field | Local source | Accepted extract |
| --- | --- | --- |
| Status | Rejected opening (8) | Open (1) |
| Open date | 2018-11-10 | 2021-02-18 |
| Close date | 2018-11-10 | Null |
| Establishment UKPRN | Null | 10092329 |
| Local-authority code | 865 | 807 |
| Proprietor classification | N/A (03) | Named proprietor body assertion |

The local copy has no group links for URN 148341 and no additional `EstablishmentProprietors` rows for it. That does not contradict a proprietor responsibility: proprietors are not represented by GIAS group links.

On 9 October 2026 the user approved a controlled establishment fixture based on the extract: Open, opened 2021-02-18, close date unknown, UKPRN 10092329 and local authority 807. The fixture also retains establishment number 6003, Other independent school and Not applicable education phase from the extract. Only these core fields are loaded for the independent school; unreviewed contact, address, measures and finer geography remain unset rather than importing conflicting local details. The academy is loaded from the verified BAU projection.

The user also approved the shared sponsor/trust/proprietor identity assumption. It does not resolve the source discrepancy as fact: the local rejected-opening values and proprietor classification remain separate context evidence, while the approved extract fields and exact PropsName are recorded as a controlled migration decision. The migration changes only the local PostgreSQL fixture, never the BAU database. Actual migration requires a recorded manual identity and lifecycle decision.

## Relationship graph

```mermaid
flowchart LR
    P["Outwood Grange Academies Trust<br/>One resolved legal entity<br/>Companies House 06995649<br/>Organisation UKPRN 10058273"]
    AR["Academy-trust role<br/>GIAS UID 4119 / TR01585"]
    SR["School-sponsor role<br/>GIAS UID 4118 / SP00396"]
    C["Multi-academy trust classification<br/>Source-current; dates unknown"]
    A["Outwood Grange Academy<br/>URN 135961<br/>School UKPRN 10028145"]
    I["Outwood Alternative Provision Eston<br/>URN 148341<br/>Approved controlled establishment fixture"]
    P -->|holds| AR
    P -->|holds| SR
    P -->|classified as| C
    AR -->|"Run by academy trust<br/>from 2009-09-01"| A
    SR -->|"Sponsored by<br/>from 2009-09-01"| A
    P -->|"Proprietor<br/>Accepted extract assertion; dates unknown"| I
```

The academy-trust and sponsor arrows represent separate responsibilities held by the same legal entity. The proprietor arrow means responsibility for managing the independent school, not ownership of its business, assets, land, buildings or operating-company shares.

## Target interpretation

These expectations use the controlled establishment and proprietor assertions approved on 9 October 2026.

| Target table | Expected records for T10 |
| --- | --- |
| `establishment` and core substructures | Two separate establishments. Load the academy from the reviewed local source and the independent school's approved extract-based core fields without copying its rejected-opening BAU lifecycle or unrelated local details. |
| `legal_entity` | One Outwood legal entity shared by all three responsibilities, not separate trust, sponsor and proprietor entities. |
| `organisation_identifier` | Current Companies House number `06995649` and organisation UKPRN `10058273`, both attached to that one legal entity and sourced from MAT UID 4119. |
| Legal form and company dates | The existing MR011 academy-trust mapping supplies Charitable company limited by guarantee as a migration assumption; the MAT group open date supplies the current mapping's incorporation date 2009-08-19. Neither is described as a fresh Companies House verification. Charity status and dissolution date are not invented. |
| `establishment_party_role` | Two roles: Academy trust and School sponsor, held by the same legal entity. Role start/end dates remain unknown. No Proprietor role is created. |
| `group_identifier` | UID 4119 / TR01585 on the Academy trust role; UID 4118 / SP00396 on the School sponsor role. All four are source-current, with issuer GIAS. No group identifier is created for proprietorship. |
| `academy_trust_classification` | One source-current MAT classification with unknown start/end dates. |
| `establishment_responsibility` | Run by academy trust (MAT) and Sponsored by responsibilities for URN 135961, both current from 2009-09-01 with unknown ends; one current Proprietor responsibility for URN 148341 from the accepted extract assertion, with unknown start/end dates. |
| `legal_entity_address`, `address` | One current administrative association for the shared Outwood legal entity, using the MAT primary block with unknown business dates. No contact or registered-office association is inferred. |
| `person`, `organisation_group`, `organisation_group_member` | No records created to represent these three responsibilities. |
| Migration evidence | Retain GroupLinks 5716 and 5254, the shared-party identity decisions, exact proprietor assertion and extract observation date 2026-06-16. Retain the local lifecycle/proprietor context and controlled establishment-field decisions separately beneath the import run. |

Proprietor is a responsibility without a corresponding party role. The academy-trust legal form and incorporation date above are migration assumptions; authoritative Companies House verification and enrichment remain deferred.

## Dates and evidence limits

- The two academy responsibility starts come from their respective GroupLinks, not from group opening or company incorporation.
- Sponsor group open date 1900-01-01 is a placeholder. Retain it as raw migration evidence; do not populate a role start or company date with it.
- The independent school's accepted opening date does not establish when Outwood became its proprietor. Keep the responsibility start null and retain the extract observation date in migration evidence.
- Matching active link sets support the reviewed sponsor/trust consolidation; they do not prove legal identity of an unrelated proprietor name by themselves.
- The accepted proprietor decision does not establish ownership, and its relationship cannot resolve the conflicting local establishment lifecycle.
- No unrelated academy links or historical responsibility ends are inferred by this slice.

## Expected checks

- Exactly one selected Outwood legal entity holds all three responsibilities across the two selected establishments.
- The two schools retain separate identities and their own school UKPRNs; neither school UKPRN is assigned to the trust.
- Two party roles and four correctly owned GIAS identifiers are retained; there is no Proprietor role or proprietor group identifier.
- The academy has exactly one current MAT operating responsibility and one separate current sponsorship responsibility, both pointing to Outwood.
- The independent school has a current Proprietor responsibility to the same legal entity, not an invented academy-trust operating responsibility.
- Both academy responsibility starts are 2009-09-01; the proprietor responsibility and role/classification boundaries remain unknown.
- The sponsor placeholder date is excluded from target business dates and retained in migration evidence.
- The controlled independent-school fields and proprietor identity decision are explicit, traceable and not substituted for raw local facts.
- Re-running the migration reuses the resolved party and does not duplicate its roles, identifiers or responsibilities.

## Migration validation

Migrated on 9 October 2026 using the approved controlled establishment and shared-party assertions. Both sponsor/trust import orders passed transaction rollback probes. The committed load and reverse-order repeat import retained business identities and unrelated establishments. Changed school UKPRN and unreviewed decision evidence were rejected without committing the probes. The source database was not changed. Conflicting local school values remain migration context, not target business facts.

## Target query

```sql
SELECT e.urn, e.name, le.legal_entity_id, le.name AS responsible_party,
       rt.name AS responsibility, tt.name AS trust_type,
       r.start_date, r.end_date, r.is_current,
       address_purpose.code AS address_purpose,
       address.address_line_1, address.address_line_2, address.address_line_3,
       address.town, address.county, address.postcode,
       legal_address.start_date AS address_start_date,
       legal_address.end_date AS address_end_date,
       legal_address.is_current AS address_is_current
FROM establishment.establishment e
JOIN establishment.establishment_responsibility r USING (establishment_id)
JOIN establishment.legal_entity le USING (legal_entity_id)
JOIN establishment.establishment_responsibility_type rt USING (responsibility_type_id)
LEFT JOIN establishment.academy_trust_type tt USING (academy_trust_type_id)
LEFT JOIN establishment.legal_entity_address legal_address USING (legal_entity_id)
LEFT JOIN establishment.address_purpose address_purpose USING (address_purpose_id)
LEFT JOIN establishment.address address USING (address_id)
WHERE e.urn IN (148341,135961)
ORDER BY e.urn, rt.name;
```

Expected: three rows sharing one legal_entity_id. Eston has only Proprietor with unknown dates; Outwood Grange Academy has Run by academy trust and Sponsored by from 2009-09-01. No Proprietor party role is created.

