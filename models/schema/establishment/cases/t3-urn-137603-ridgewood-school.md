# T3 — Ridgewood School

T3 tests that Ridgewood School's trust remains one legal entity as it changes from SAT to MAT, with the trust's classification periods recorded separately from its responsibilities for the school.

## Establishment

| Field | Value |
| --- | --- |
| Test case | T3 |
| URN | 137603 |
| Establishment name | Ridgewood School |
| Establishment type | Academy converter (source type 34) |
| Source status | Open (status 1) |
| Open date | 1 November 2011 |
| Close date | Null |

## Local source evidence

Ridgewood School is the selected local case for T3.

| Field | Predecessor SAT | Successor MAT |
| --- | --- | --- |
| Group UID | 2055 | 20364 |
| Group ID | TR00009 | TR00009 |
| Name | THE ACADEMY @ RIDGEWOOD TRUST | THE ACADEMY @ RIDGEWOOD TRUST |
| Type code | 10 | 06 |
| Companies House number | Null | 07795736 |
| UKPRN | 10059335 | 10059335 |
| Source group open date | 3 October 2011 | 3 October 2011 |
| Source group closed date | 30 March 2021 | Null |
| GroupLink ID | 4778 | 34277 |
| Link effective date | 1 November 2011 | 30 March 2021 |
| Link archived | 1 | 0 |

The identity search by Group ID, Companies House number or UKPRN returned exactly these two group records. The query for all links to URN 137603 returned exactly these two links. Only one current academy-trust link exists for this establishment.

`GroupRelationsLink` explicitly records the conversion:

| Relationship ID | linking_group | linked_group | Type | establishedDate | systemLinkDate |
| --- | --- | --- | --- | --- | --- |
| 547 | 2055 | 20364 | 1M — Successor MAT | 2021-03-30 | 2021-03-30 |
| 548 | 20364 | 2055 | 1S — Predecessor SAT | 2021-03-30 | 2021-03-30 |

The type names were verified against `dbo.GroupLinkType`. The transition date is supported by the explicit relationship records, SAT closure and MAT link effective date; it is not derived from the closure date alone.

The local address observation on 12 October 2026 supplies identical primary addresses for SAT UID `2055` and MAT UID `20364`: Ridgewood School Barnsley Road, Scawsby, Doncaster, DN5 7UB. These resolve to one current administrative address association for the continuing trust, with separate evidence for both source records. Matching the school's postal values can reuse its address record, but does not create another school site, establish property ownership or merge the school and trust.

Both contact blocks are blank and no registered-office purpose is evidenced. The migration therefore creates neither a contact nor a registered-office association. Four source blocks retain evidence, including the two blank blocks. County/country codes remain raw evidence and the unavailable county label stays null. Address start/end dates remain null: the classification transition on 30 March 2021 does not prove an address change. Unchanged reimports retain the same period; changed or conflicting source addresses require review.

## Relationship graph

```mermaid
flowchart LR
    E["Ridgewood School<br/>URN 137603"]
    L["The Academy @ Ridgewood Trust<br/>legal entity<br/>Companies House 07795736<br/>UKPRN 10059335"]
    R["One continuing academy trust role<br/>role dates unknown"]
    SAT["Historical SAT classification<br/>start unknown<br/>ends 30 March 2021"]
    MAT["Current MAT classification<br/>starts 30 March 2021<br/>no end date"]
    U["GIAS group identifiers<br/>UID 2055 historical<br/>UID 20364 current<br/>Group ID TR00009 current"]

    E -->|"Historical SAT responsibility<br/>from 1 November 2011; end unknown"| L
    E -->|"Current MAT responsibility<br/>from 30 March 2021; end unknown"| L
    L -->|"holds"| R
    R -->|"identified by"| U
    L -->|"has"| SAT
    L -->|"has"| MAT
    SAT -.->|"Classification transition<br/>30 March 2021"| MAT
```

The classification changes within the same legal entity. Its academy-trust role continues, while its responsibility for Ridgewood School is recorded as separate SAT and MAT periods. Their dates are independent of the classification dates.

## Target interpretation

T3 can exercise one resolved legal entity, one continuing academy-trust role, historical SAT UID 2055, current MAT UID 20364 and shared Group ID TR00009. The MAT record supplies Companies House number 07795736; the matching UKPRN, Group ID, dates and explicit predecessor/successor relationships support consolidation.

The historical SAT responsibility starts on 1 November 2011, from GroupLink 4778. Its end date is unknown and it is not current because that link is archived. The current MAT responsibility starts on 30 March 2021, from GroupLink 34277, with an unknown end date. Both responsibilities point to the same legal entity: the classification change is not a new legal operator. Each responsibility retains its own source-link migration evidence.

| Record | Start date | End date | Current |
| --- | --- | --- | --- |
| SAT responsibility for Ridgewood School | 2011-11-01 | Unknown | No |
| MAT responsibility for Ridgewood School | 2021-03-30 | Unknown | Yes |
| SAT classification of the trust | Unknown | 2021-03-30 | No |
| MAT classification of the trust | 2021-03-30 | Unknown | Yes |

The historical SAT classification ends at the transition on 30 March 2021 and the current MAT classification starts at that transition. The initial SAT classification start remains unknown: neither incorporation nor the establishment link alone establishes when that classification began. The source SAT closure does not end the continuing legal entity or academy-trust role, and its classification end date is not copied into the SAT responsibility's end date. The MAT responsibility and classification start dates coincide because each is supported by its own evidence, not because one is derived from the other.

No structural DQ concern was identified in these checks. This assessment concerns the local fixture evidence, rather than independent verification of the live trust's history.

## Target query

Run against `establishment_local` to display the school, responsibilities, continuing legal entity, role, classifications, identifiers and address periods together. Expect one administrative address association, current with unknown business dates, independently of the two trust classifications.

```sql
WITH target AS (
    SELECT *
    FROM establishment.establishment
    WHERE urn = 137603
),
responsibilities AS (
    SELECT er.*, rt.name AS responsibility_type
    FROM establishment.establishment_responsibility AS er
    JOIN target AS e USING (establishment_id)
    JOIN establishment.establishment_responsibility_type AS rt
      USING (responsibility_type_id)
),
parties AS (
    SELECT DISTINCT le.*
    FROM establishment.legal_entity AS le
    JOIN responsibilities AS er USING (legal_entity_id)
),
roles AS (
    SELECT r.*, rpt.name AS role_type
    FROM establishment.establishment_party_role AS r
    JOIN parties AS le USING (legal_entity_id)
    JOIN establishment.establishment_party_role_type AS rpt
      USING (establishment_party_role_type_id)
),
classifications AS (
    SELECT atc.*, att.name AS academy_trust_type
    FROM establishment.academy_trust_classification AS atc
    JOIN parties AS le USING (legal_entity_id)
    JOIN establishment.academy_trust_type AS att
      USING (academy_trust_type_id)
),
identifiers AS (
    SELECT gi.*, git.name AS identifier_type, issuer.name AS issuer
    FROM establishment.group_identifier AS gi
    JOIN roles AS r USING (establishment_party_role_id)
    JOIN establishment.group_identifier_type AS git
      USING (group_identifier_type_id)
    JOIN establishment.group_identifier_issuer AS issuer
      USING (group_identifier_issuer_id)
),
addresses AS (
    SELECT link.*, purpose.code AS address_purpose,
           a.address_line_1, a.address_line_2, a.address_line_3,
           a.town, a.county, a.postcode
    FROM establishment.legal_entity_address AS link
    JOIN parties AS le USING (legal_entity_id)
    JOIN establishment.address_purpose AS purpose USING (address_purpose_id)
    JOIN establishment.address AS a USING (address_id)
)
SELECT 'establishment' AS record_type, to_jsonb(e) AS data
FROM target AS e
UNION ALL
SELECT 'responsibility', to_jsonb(er)
FROM responsibilities AS er
UNION ALL
SELECT 'legal_entity', to_jsonb(le)
FROM parties AS le
UNION ALL
SELECT 'party_role', to_jsonb(r)
FROM roles AS r
UNION ALL
SELECT 'academy_trust_classification', to_jsonb(c)
FROM classifications AS c
UNION ALL
SELECT 'group_identifier', to_jsonb(i)
FROM identifiers AS i
UNION ALL
SELECT 'legal_entity_address', to_jsonb(a)
FROM addresses AS a
ORDER BY record_type;
```

