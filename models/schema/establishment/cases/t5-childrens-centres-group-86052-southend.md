# T5 — Southend Children's Centres

T5 tests that Southend Children's Centres is recorded as one organisation group with nine members, with Cambridge Road Children's Centre identified as its sole lead member.

## Children's-centre group

T5 covers Southend Children's Centres, group UID 86052, and its nine member establishments.

| Field | Local source value |
| --- | --- |
| Group UID | 86052 |
| Group name | Southend Children's Centres |
| Group type | Children's Centres Group (source code 08) |
| Group ID | Null |
| Local authority | Southend-on-Sea (code 882) |
| Group open date | 2016-10-01 |
| Group closed date | Null |
| Companies House number | Null |
| UKPRN | Null |
| Members | Nine active, open children's centres |
| Lead centre | Cambridge Road Children's Centre, URN 20549 |

Unlike the T4 federation, this group has its own recorded local authority. Code 882 comes directly from `EstablishmentGroup.localAuthority_code`; it is not inferred from the members. Every member also has establishment local-authority code 882.

## Local source evidence

The local source returns exactly nine links for group 86052, all with `archived = 0`. Every member is an open children's centre, source establishment type 47 and status 1. The query for other group links held by these nine establishments returned no additional records.

The group record's primary and contact address blocks are both blank. Neither block contains a street, locality, third address line, town, postcode, UPRN or site name. The raw county and country codes are `099` and `00`, but these codes alone are not a postal address. Both blank blocks are retained as source evidence against group UID 86052. No address is copied from a member centre or inferred from the group's Southend-on-Sea local-authority relationship.

| URN | Establishment | Source GroupLink ID | Establishment open date | Membership effective date | `ccLinkType` | Current lead assertion recorded |
| --- | --- | --- | --- | --- | --- | --- |
| 20338 | Blenheim Children's Centre | 25390 | 2008-02-07 | 2016-10-01 | STANDARD | False |
| 20549 | Cambridge Road Children's Centre | 25391 | 2006-03-14 | 2016-10-01 | LEAD | True |
| 20614 | Centre Place Family Centre | 25392 | 2008-03-03 | 2016-10-01 | STANDARD | False |
| 21363 | Hamstel Children and Family Centre | 25395 | 2009-12-14 | 2016-10-01 | STANDARD | False |
| 22422 | Prince Avenue Children and Family Centre | 25396 | 2009-12-14 | 2016-10-01 | STANDARD | False |
| 22459 | Friars Children's Centre | 25394 | 2008-01-16 | 2016-10-01 | STANDARD | False |
| 22975 | Summercourt Children's Centre | 25397 | 2008-01-16 | 2016-10-01 | STANDARD | False |
| 23004 | Eastwood Children's Centre | 25393 | 2008-02-07 | 2016-10-01 | STANDARD | False |
| 23122 | Temple Sutton Children's Centre | 25398 | 2006-09-28 | 2016-10-01 | STANDARD | False |

All establishment close dates are null. The membership links do not provide end dates. Each membership joined date comes from its own effective date; those dates happen to match the group's open date. The earlier establishment open dates remain separate lifecycle facts and are not replaced with the group or membership dates.

The explicit `ccLinkType` value controls lead periods: `LEAD` creates a current lead assertion and `STANDARD` does not. Both source codes remain in migration evidence; absence of a current lead row alone does not prove confirmed non-lead. An absent or unrecognised value must not silently become false. This case demonstrates one observed lead centre; it does not supply a history of changes to that flag.

## Relationship graph

```mermaid
flowchart LR
    G["Southend Children's Centres<br/>organisation group<br/>opens 1 October 2016"]
    U["GIAS group UID 86052<br/>no Group ID supplied"]
    LA["Southend-on-Sea<br/>local authority code 882"]
    L["Cambridge Road Children's Centre<br/>URN 20549<br/>Lead member"]
    B["Blenheim Children's Centre<br/>URN 20338<br/>Standard member"]
    C["Centre Place Family Centre<br/>URN 20614<br/>Standard member"]
    G -->|"identified by"| U
    G -->|"recorded local authority"| LA
    L -->|"Member from 1 October 2016<br/>Current lead recorded"| G
    B -->|"Member from 1 October 2016<br/>Source STANDARD; no current lead recorded"| G
    C -->|"Member from 1 October 2016<br/>Source STANDARD; no current lead recorded"| G
```

The graph shows the lead and two standard members for readability. Six further standard members are listed in the evidence table. The group has nine members in total, not three. The local authority relationship shown is recorded on the group; each establishment also has its own local-authority information.

## Target interpretation

| Target table | Expected records for T5 |
| --- | --- |
| `establishment` | Nine separate children's-centre records, retaining their five-digit URNs and independently recorded establishment open dates. |
| `organisation_group` | One children's-centre group named Southend Children's Centres, `open_date = 2016-10-01`, unknown `close_date`, and `local_authority_id` pointing to Southend-on-Sea. |
| `organisation_group_member` | Nine memberships, each with `joined_date = 2016-10-01` and unknown `left_date`. Cambridge Road has `Current lead recorded`; the other eight have false. |
| `organisation_group_member_lead_period` | One current lead assertion belonging to Cambridge Road's membership. Its `start_date` and `end_date` are unknown: neither the membership effective date nor a source observation date establishes when lead designation started. |
| `group_identifier` | One GIAS Group UID value `86052`, attached to the organisation group. No Group ID is invented. |
| `organisation_group_address`, `address` | No group address association or new postal address is created from the two blank source blocks. |
| `legal_entity`, `organisation_identifier`, `establishment_party_role`, `academy_trust_classification`, `establishment_responsibility` | No records created merely to represent this group, its lead designation or its memberships. |
| Migration evidence | Retain the nine source-link IDs, active-link state and `ccLinkType` values, with each membership linked to its own source record beneath the shared rebuild run. |

The group is not a legal entity. The lead designation is a separate period belonging to Cambridge Road's membership, not a separate legal entity, party role or operating responsibility. The group's local-authority association does not by itself create an establishment responsibility held by that authority.

The active links establish the observed current membership. Unknown leaving dates do not prove indefinite membership. The model can retain successive lead periods, but this source extract supplies only one current assertion with unknown boundaries. Future changes retain earlier assertions without fabricating historical business dates.

All nine establishments are required to exercise this whole-group case. Importing only Cambridge Road would demonstrate a lead flag, but would not validate the full membership set or establish that it is the only lead among the group's members.

## Evidence limits

The reviewed group and membership fields have no placeholder dates, duplicate member links, multiple lead flags or local-authority disagreement. This is a bounded assessment of those fields, not a claim that every source field is accurate. Core establishment approval snapshots retain the source values, including obfuscated contact and address data. Missing school-capacity measures and statutory school-age ranges remain absent rather than being invented for children's centres.

## Target query

```sql
SELECT e.urn, e.name AS establishment_name,
       g.name AS group_name, i.value AS gias_group_uid,
       m.joined_date, m.left_date,
       purpose.code AS address_purpose,
       address.address_line_1, address.address_line_2, address.address_line_3,
       address.town, address.county, address.postcode,
       group_address.start_date AS address_start_date,
       group_address.end_date AS address_end_date,
       group_address.is_current AS address_is_current,
       (SELECT count(*) FROM migration.organisation_group_address_evidence evidence
        WHERE evidence.organisation_group_id=g.organisation_group_id) AS address_source_blocks_retained
FROM establishment.organisation_group g
JOIN establishment.group_identifier i USING (organisation_group_id)
JOIN establishment.group_identifier_type identifier_type USING (group_identifier_type_id)
JOIN establishment.organisation_group_member m USING (organisation_group_id)
JOIN establishment.establishment e USING (establishment_id)
LEFT JOIN establishment.organisation_group_address group_address USING (organisation_group_id)
LEFT JOIN establishment.address_purpose purpose USING (address_purpose_id)
LEFT JOIN establishment.address address USING (address_id)
WHERE identifier_type.name='Group UID' AND i.value='86052'
ORDER BY e.urn;
```

## Expected checks

- All nine establishments retain their original five-digit URNs; no padding or replacement identifiers are introduced.
- UID 86052 identifies one children's-centre organisation group, not a party role.
- The group's local authority resolves from source code 882 to Southend-on-Sea.
- All nine members belong to that local authority and match the selected source membership set exactly.
- Each joined date comes from its own GroupLink effective date, with no invented leaving date.
- Exactly Cambridge Road, URN 20549, has `Current lead recorded`; the other eight explicitly have false.
- Cambridge Road has one current lead period with unknown start and end dates; no dated history is inferred from membership or snapshot dates.
- Missing or unrecognised lead codes stop for assessment rather than defaulting to a standard member.
- No Companies House number, organisation UKPRN, Group ID or group legal entity is invented.
- Membership and lead designation create no establishment responsibility.
- Each member's evidence points to the correct source link and retains the original `ccLinkType` beneath the shared rebuild run.
- Both blank group address blocks are retained as evidence; no address association is invented.
