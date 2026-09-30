# Establishment groups

This document defines the logical model for legal entities, responsibilities and organisation groups associated with establishments in the Establishment Registry. Source records and migration lineage are outside the target domain model.

## Establishment groups ERD

The groups branch is shown separately so that the main establishment ERD remains readable. The model is split into two diagrams: one for parties, roles and responsibilities, and one for organisation groups and group identifiers. A legal entity can hold dated establishment-party roles and can have dated responsibilities for establishments. A person can hold a school-sponsor role and permitted responsibilities. A federation or children's-centre grouping is instead a named group of establishments; it is not a legal entity.

The model contains:

- legal entities, their legal form, charity status and external identifiers;
- dated establishment-party roles held by a legal entity or, for a school sponsor, a person;
- dated academy-trust classifications for academy-trust roles;
- dated responsibilities held by a legal entity or person for an establishment;
- dated membership of federations and children's-centre organisation groups; and
- the group UIDs and Group IDs that identify roles and organisation groups.

### Parties, roles and responsibilities

This diagram contains the legal party, its recognised roles, its role classifications and its responsibilities for individual establishments.

```mermaid
erDiagram
    LEGAL_ENTITY }o--o| LEGAL_ENTITY_TYPE : "has type"
    LEGAL_ENTITY }o--o| CHARITY_STATUS : "has charity status"
    LEGAL_ENTITY ||--o{ ORGANISATION_IDENTIFIER : "identified by"
    ORGANISATION_IDENTIFIER }o--|| ORGANISATION_IDENTIFIER_TYPE : "has type"
    ESTABLISHMENT_PARTY_ROLE }o--o| LEGAL_ENTITY : "held by"
    ESTABLISHMENT_PARTY_ROLE }o--o| PERSON : "held by (sponsor only)"
    ESTABLISHMENT_PARTY_ROLE }o--|| ESTABLISHMENT_PARTY_ROLE_TYPE : "has type"
    ESTABLISHMENT_PARTY_ROLE ||--o{ ACADEMY_TRUST_CLASSIFICATION : "classified as (academy trust only)"
    ACADEMY_TRUST_CLASSIFICATION }o--|| ACADEMY_TRUST_TYPE : "has type"
    ESTABLISHMENT ||--o{ ESTABLISHMENT_RESPONSIBILITY : "is subject of"
    ESTABLISHMENT_RESPONSIBILITY }o--|| RESPONSIBILITY_TYPE : "has type"
    ESTABLISHMENT_RESPONSIBILITY }o--o| LEGAL_ENTITY : "held by"
    ESTABLISHMENT_RESPONSIBILITY }o--o| PERSON : "held by"
    ESTABLISHMENT {
        uuid establishment_id PK
        numeric urn UK
        string name
    }
    LEGAL_ENTITY {
        uuid legal_entity_id PK
        string name
        integer legal_entity_type_id FK
        integer charity_status_id FK
        date incorporation_date
        date dissolution_date
    }
    LEGAL_ENTITY_TYPE {
        integer legal_entity_type_id PK
        string name UK
    }
    CHARITY_STATUS {
        integer charity_status_id PK
        string name UK
    }
    ORGANISATION_IDENTIFIER {
        uuid organisation_identifier_id PK
        uuid legal_entity_id FK
        integer organisation_identifier_type_id FK
        string value
        boolean is_current
    }
    ORGANISATION_IDENTIFIER_TYPE {
        integer organisation_identifier_type_id PK
        string name UK
    }
    ESTABLISHMENT_PARTY_ROLE {
        uuid establishment_party_role_id PK
        integer establishment_party_role_type_id FK
        uuid legal_entity_id FK
        uuid person_id FK
        date start_date
        date end_date
    }
    ESTABLISHMENT_PARTY_ROLE_TYPE {
        integer establishment_party_role_type_id PK
        string name UK
    }
    ACADEMY_TRUST_CLASSIFICATION {
        uuid academy_trust_classification_id PK
        uuid establishment_party_role_id FK
        integer academy_trust_type_id FK
        date start_date
        date end_date
    }
    ACADEMY_TRUST_TYPE {
        integer academy_trust_type_id PK
        string name UK
    }
    ESTABLISHMENT_RESPONSIBILITY {
        uuid establishment_responsibility_id PK
        uuid establishment_id FK
        integer responsibility_type_id FK
        uuid legal_entity_id FK
        uuid person_id FK
        date start_date
        date end_date
    }
    RESPONSIBILITY_TYPE {
        integer responsibility_type_id PK
        string name UK
    }
    PERSON {
        uuid person_id PK
    }
```

### Organisation groups and group identifiers

This diagram contains federations and children's-centre groups, their establishment memberships and identifiers issued for role or organisation-group records. `ESTABLISHMENT_PARTY_ROLE` is shown as the endpoint for role identifiers; its attributes are defined in the first diagram.

```mermaid
erDiagram
    ESTABLISHMENT_PARTY_ROLE ||--o{ GROUP_IDENTIFIER : "identified by"
    ORGANISATION_GROUP ||--o{ GROUP_IDENTIFIER : "identified by"
    GROUP_IDENTIFIER }o--|| GROUP_IDENTIFIER_TYPE : "has type"
    GROUP_IDENTIFIER }o--|| IDENTIFIER_ISSUER : "issued by"
    ORGANISATION_GROUP }o--|| ORGANISATION_GROUP_TYPE : "has type"
    ORGANISATION_GROUP }o--o| LOCAL_AUTHORITY : "coordinated by"
    ORGANISATION_GROUP ||--o{ ORGANISATION_GROUP_MEMBER : "has"
    ESTABLISHMENT ||--o{ ORGANISATION_GROUP_MEMBER : "is"

    ESTABLISHMENT_PARTY_ROLE {
        uuid establishment_party_role_id PK
    }
    ORGANISATION_GROUP {
        uuid organisation_group_id PK
        string name
        integer organisation_group_type_id FK
        uuid local_authority_id FK
        date open_date
        date close_date
    }
    ORGANISATION_GROUP_TYPE {
        integer organisation_group_type_id PK
        string name UK
    }
    ORGANISATION_GROUP_MEMBER {
        uuid organisation_group_member_id PK
        uuid organisation_group_id FK
        uuid establishment_id FK
        date joined_date
        date left_date
        boolean is_lead_centre
    }
    GROUP_IDENTIFIER {
        uuid group_identifier_id PK
        uuid establishment_party_role_id FK
        uuid organisation_group_id FK
        integer group_identifier_type_id FK
        integer identifier_issuer_id FK
        string value
        boolean is_current
    }
    GROUP_IDENTIFIER_TYPE {
        integer group_identifier_type_id PK
        string name UK
    }
    IDENTIFIER_ISSUER {
        integer identifier_issuer_id PK
        string name UK
    }
    ESTABLISHMENT {
        uuid establishment_id PK
        numeric urn UK
        string name
    }
    LOCAL_AUTHORITY {
        uuid local_authority_id PK
        integer code UK
        string name
    }
```

`ESTABLISHMENT` and `LOCAL_AUTHORITY` are defined in the establishment slice. `PERSON` belongs to the people slice. They are shown here only as relationship endpoints.

## Model scope

### Included concepts

- Legal entities that run, sponsor or support establishments, or are their proprietors.
- Legal entity type, charity status and external identifiers.
- Dated academy-trust, foundation-trust, umbrella-trust and school-sponsor roles.
- Dated single-academy trust, multi-academy trust and secure single-academy trust classifications.
- Responsibilities held by academy trusts, sponsors, foundation trusts and proprietors.
- Federations, children's-centre groups and children's-centre collaborations, with their establishment members.
- Group UIDs and Group IDs for roles and organisation groups.

### Excluded attributes and relationships

- Legal-entity addresses, contacts, head-of-group details and proprietor contact details.
- Name history.
- Local-authority maintenance, which belongs to the accountability slice.
- Succession between legal entities beyond a change from SAT to MAT.
- Umbrella-trust relationships and user-permission scopes.
- Group-ID issuance rules for new academy trusts.
- Role assignability and role-retirement dates.

### Source representation

GIAS group UIDs and Group IDs are target data. They are business identifiers: GIAS group pages, search, extracts and links use them, and they stay in use after migration. They are held in [`group_identifier`](#group-identifier) against the role or organisation group they identify.

Source names, source type codes, source links and identity-resolution evidence are migration lineage and are outside the target model.

A GIAS group identifier identifies a role or an organisation group, never a legal entity directly. Several GIAS records can resolve to one legal entity, and each keeps its own identifiers on its own role.

## Entities

### Legal entity

`legal_entity` identifies an organisation that is not an establishment. It represents academy trusts, sponsoring bodies, foundation trusts, umbrella trusts and proprietor bodies.

- One row represents one real-world legal entity. A SAT record, a MAT record and a sponsor record can resolve to the same row.
- An establishment remains an `establishment`; the wider organisation concept is a union view, not a shared target table.
- Academy-trust type is not a legal-entity type.
- The current name is held here. Name history is not represented.

| Attribute | Required | Rule |
| --- | --- | --- |
| `legal_entity_id` | Yes | Generated opaque target identifier. |
| `name` | Yes | Current name; for a company, its registered name. |
| `legal_entity_type_id` | No | Controlled type where known. |
| `charity_status_id` | No | Registered, exempt, excepted or not a charity; null when unknown. |
| `incorporation_date` | No | Date of incorporation where incorporated. |
| `dissolution_date` | No | Date of dissolution where known from an authoritative register. |

The `legal_entity_type` vocabulary is: charitable company limited by guarantee; company limited by guarantee; private limited company; public limited company; limited liability partnership; charitable incorporated organisation; body incorporated by Royal Charter; unincorporated charitable trust; public body; overseas entity; sole trader; and traditional partnership.

### Organisation identifier

`organisation_identifier` holds an identifier issued by an external authority for a legal entity.

- Identifier types are Companies House number, UKPRN and Charity Commission number.
- A legal entity can have several values of one type over time, but only one current value of a type.
- A current value is unique within its identifier type. A replaced value cannot be current for another legal entity.
- Values are stored as text so leading zeroes are retained.

| Attribute | Required | Rule |
| --- | --- | --- |
| `organisation_identifier_id` | Yes | Generated opaque target identifier. |
| `legal_entity_id` | Yes | The owning legal entity. |
| `organisation_identifier_type_id` | Yes | Controlled identifier type. |
| `value` | Yes | Identifier as issued. |
| `is_current` | Yes | False when a value has been replaced. |

### Establishment party role

`establishment_party_role` records that a legal entity or person held a recognised role in relation to establishments for one continuous period.

- The role types are academy trust, foundation trust, umbrella trust and school sponsor.
- Every role has exactly one holder. Exactly one of `legal_entity_id` and `person_id` is set.
- A person can hold only a school-sponsor role.
- A party can hold the same role type more than once, but each row represents one continuous period. If a role ends and later starts again, the later period is a new row.
- Periods for the same party and role type cannot overlap. A gap between periods is allowed.
- Role assignability and role-retirement dates are not represented.

| Attribute | Required | Rule |
| --- | --- | --- |
| `establishment_party_role_id` | Yes | Generated opaque target identifier. |
| `establishment_party_role_type_id` | Yes | Academy trust, foundation trust, umbrella trust or school sponsor. |
| `legal_entity_id` | Conditional | The legal entity holding the role. |
| `person_id` | Conditional | The person holding the role; permitted only for school sponsor. |
| `start_date` | No | First date on which the role applies; null means unknown. |
| `end_date` | No | First date on which the role no longer applies. |

The school-sponsor role means that DfE recognised the party as a school sponsor. It does not, by itself, assert formal approval, sponsorship of a particular establishment or governance rights over an academy trust. Sponsorship of a particular establishment is recorded separately as an `establishment_responsibility`. Formal approval and trust-level governance rights are outside this model unless a reliable source is identified.

### Academy trust classification

`academy_trust_classification` records the classification held by an academy-trust role for a period.

- The types are single-academy trust, multi-academy trust and secure single-academy trust.
- Classifications exist only for academy-trust roles. Every academy-trust role has at least one classification.
- Classification periods for one role cannot overlap and fall within the role's period where both boundaries are known.
- A SAT-to-MAT change creates two classification periods for one continuous academy-trust role and one legal entity. It does not create a second legal entity or a second role.
- The classification is recorded, not derived from the number of academies.

| Attribute | Required | Rule |
| --- | --- | --- |
| `academy_trust_classification_id` | Yes | Generated opaque target identifier. |
| `establishment_party_role_id` | Yes | The academy-trust role being classified. |
| `academy_trust_type_id` | Yes | Single-academy trust, multi-academy trust or secure single-academy trust. |
| `start_date` | No | First date on which the classification applies; null means unknown. |
| `end_date` | No | First date on which the classification no longer applies. |

#### Date semantics

The two periods represent separate lifecycle facts:

| Record | Meaning | What causes a new period? |
| --- | --- | --- |
| `establishment_party_role` | When did this party act as an academy trust? | The academy-trust role ends, or it ends and later restarts. |
| `academy_trust_classification` | During that academy-trust role, when was it a SAT, MAT or secure SAT? | The recorded academy-trust type changes. |

The role is the longer-lived concept. A classification describes the academy-trust role; it is not a second role and it is not the legal entity's lifecycle. Neither period says when the trust ran a particular academy; that period belongs to `establishment_responsibility`. One continuous role can therefore contain several successive classification periods.

The dates follow these rules:

- A classification cannot exist without its academy-trust role.
- Every known part of a classification period falls within the role period.
- Classification periods for the same role do not overlap.
- Successive classifications can meet on the same date because periods are half open: the earlier classification ends on the first day the later classification applies.
- Ending a classification does not end the academy-trust role when another classification starts immediately.
- Ending the academy-trust role ends every classification under it. If the party later becomes an academy trust again, that is a new role with its own classification history.
- Null dates mean that the boundary is unknown. They do not mean that the role and classification are necessarily coterminous.

### Establishment responsibility

`establishment_responsibility` records that a legal entity or person runs, sponsors or supports an establishment, or is its proprietor, for a period.

There is one row per party, establishment, responsibility type and period. Exactly one of `legal_entity_id` and `person_id` is set. A person can be the party only for `sponsored_by` and `proprietor`.

| Attribute | Required | Rule |
| --- | --- | --- |
| `establishment_responsibility_id` | Yes | Generated opaque target identifier. |
| `establishment_id` | Yes | The existing establishment. |
| `responsibility_type_id` | Yes | Controlled responsibility type. |
| `legal_entity_id` | Conditional | Responsible legal entity. |
| `person_id` | Conditional | Responsible person, where permitted. |
| `start_date` | No | First date on which the responsibility applies; null means unknown. |
| `end_date` | No | First date on which it no longer applies. |

| Responsibility type | Meaning |
| --- | --- |
| `run_by_academy_trust` | The academy trust runs the academy or free school and is accountable for it. |
| `sponsored_by` | The legal entity or person recorded as the establishment's sponsor. |
| `supported_by_foundation_trust` | The foundation trust that supports a foundation school. |
| `proprietor` | The legal entity or person responsible for managing an independent school, non-maintained special school or city technology college. This does not model ownership of premises or a proprietor company. |

`maintained_by_local_authority` belongs to the accountability slice.

### Organisation group

`organisation_group` is a named group of establishments with its own lifecycle but no legal identity.

- It is used only for federations, children's-centre groups and children's-centre collaborations.
- It is not a legal entity and has neither a legal-entity type nor organisation identifiers. Its group UID, and any Group ID, are held in `group_identifier`.
- Children's-centre groups and collaborations are coordinated by a local authority; federations are not.
- Status is derived from dates.

| Attribute | Required | Rule |
| --- | --- | --- |
| `organisation_group_id` | Yes | Generated opaque target identifier. |
| `name` | Yes | Current name. |
| `organisation_group_type_id` | Yes | Federation, children's-centre group or children's-centre collaboration. |
| `local_authority_id` | Conditional | Required for children's-centre types and absent for federations. |
| `open_date` | No | First date on which the group existed, where known. |
| `close_date` | No | First date on which the group no longer existed, where known. |

### Organisation group member

`organisation_group_member` records that an establishment belongs to an organisation group for a period.

Only establishments can be group members in this slice.

| Attribute | Required | Rule |
| --- | --- | --- |
| `organisation_group_member_id` | Yes | Generated opaque target identifier. |
| `organisation_group_id` | Yes | The organisation group. |
| `establishment_id` | Yes | The member establishment. |
| `joined_date` | No | First date on which membership applies; null means unknown. |
| `left_date` | No | First date on which membership no longer applies. |
| `is_lead_centre` | Conditional | Used only for children's-centre groups. True identifies the lead centre; null means the source does not say. Lead-centre history is not represented. |

### Group identifier

`group_identifier` holds the group UIDs and Group IDs that identify an establishment-party role or an organisation group.

- **Owner:** exactly one of `establishment_party_role_id` and `organisation_group_id` is set. A group identifier never belongs to a legal entity or person directly: Outwood Grange Academies Trust is one legal entity whose academy-trust role holds UID `4119` and Group ID `TR01585`, and whose school-sponsor role holds UID `4118` and Group ID `SP00396`.
- **Types:** group UID and Group ID.
- **One scheme, two issuers:** there is one group UID scheme. Values migrated from GIAS have issuer GIAS; values allocated after cutover have issuer Establishment Registry.
- **Several values per owner:** a SAT-to-MAT consolidation gives one academy-trust role two UIDs, for example `2224` (the SAT record) and `17488` (the MAT record), and one Group ID, `TR00125`, stored once. The current value is the one the owner is known by now; the others are kept so that old references still resolve.
- **Uniqueness:** a group UID is unique across all owners and both issuers. A Group ID is unique across owners.
- **Values** are stored as text, as issued. A Group ID keeps its prefix, such as `TR`, `SP` or `UT`.
- Proprietors have no GIAS group record, so they have no group identifier.

| Attribute | Required | Rule |
| --- | --- | --- |
| `group_identifier_id` | Yes | Generated opaque target identifier. |
| `establishment_party_role_id` | Conditional | The owning role. |
| `organisation_group_id` | Conditional | The owning organisation group. |
| `group_identifier_type_id` | Yes | Group UID or Group ID. |
| `identifier_issuer_id` | Yes | GIAS or Establishment Registry. |
| `value` | Yes | The identifier as issued. |
| `is_current` | Yes | True for the value the owner is known by now. False for a value kept so that old references still resolve. |

## Derived views

The following are views of responsibilities and memberships. They are not separately stored collections.

| View | Definition |
| --- | --- |
| Academy trust's academies | `run_by_academy_trust` responsibilities in effect on a date, grouped by the legal entity holding the academy-trust role. |
| Sponsor's academies | `sponsored_by` responsibilities in effect on a date, grouped by party. |
| Foundation trust's schools | `supported_by_foundation_trust` responsibilities in effect on a date. |
| Proprietor's schools | `proprietor` responsibilities in effect on a date, grouped by party. |
| Academy count check | Number of academies per academy trust; a data-quality check, not a way to set trust type. |
| Group lookup | The role or organisation group identified by a group UID or Group ID, whether current or not, and for a role its holder. |

An on-date view has three states:

- **Known in effect:** the start is known and on or before the date.
- **Possibly in effect:** the start is unknown; this distinction is retained as migration evidence rather than as live-service data.
- **Not in effect:** otherwise, including after a known end date.

## Cardinality and integrity rules

1. Every establishment-party role has exactly one party. A person may hold only a school-sponsor role.
2. Each `establishment_party_role` row represents one continuous period. A party holds at most one role of each type in effect on a date. If the role ends and later starts again, create a second role row. Periods for the same party and role type cannot overlap, but a gap is allowed.
3. A role's start date cannot be after its end date. A null start date means unknown, not "since the beginning".
4. Academy-trust classifications exist only for academy-trust roles. Every academy-trust role has at least one classification. One role may have successive classifications, but its classification periods cannot overlap.
5. A classification period falls within its academy-trust role period where both boundaries are known. A source conflict is reported; it does not extend the role or classification to make the dates agree.
6. Every establishment responsibility has exactly one party. A person may be the party only for `sponsored_by` and `proprietor`.
7. Responsibility start dates cannot be after end dates. A null start date means unknown, not "since the beginning".
8. For `run_by_academy_trust`, the party is a legal entity holding an academy-trust role. An establishment has at most one in effect on a date. An open academy or free school must have one. A responsibility outside the role period is reported as a warning.
9. For `sponsored_by`, an establishment has at most one in effect on a date, and only academy and free-school establishment types may have one. A sponsor holds a school-sponsor role covering the responsibility; a conflict or missing role is reported as a warning.
10. For `supported_by_foundation_trust`, the party is a legal entity holding a foundation-trust role. An establishment has at most one in effect on a date, and only foundation and foundation-special establishment types may have one. A responsibility outside the role period is reported as a warning. The legal-form and charity-status check is also a warning where the necessary evidence is unavailable.
11. An establishment may have more than one proprietor in effect. Only independent school types, non-maintained special schools and city technology colleges may have a proprietor. Open other independent schools and other independent special schools must have at least one.
12. An establishment is in at most one organisation group of each type on a date. Federation members are maintained schools; children's-centre group and collaboration members are children's centres.
13. An open federation has at least two members.
14. A children's-centre group has at most one member with `is_lead_centre = true`. `is_lead_centre` is null for all other group types.
15. `local_authority_id` is required for children's-centre group types and absent for federations. Every member of a children's-centre group or collaboration is in the group's local authority; a member in another local authority is reported as a warning, because local-government reorganisation can move a centre.
16. No stored collection restates a responsibility: an academy trust's academies are not organisation-group memberships.
17. A relationship falls within the lifetime of its party or group where those dates are known. A conflict is reported; it does not invent a date to satisfy the rule.
18. A possible overlap involving an unknown start date is reported as a warning. Known-date overlaps block loading.
19. Every group identifier has exactly one owner: an establishment-party role or an organisation group.
20. A group UID is unique across all owners, whatever its issuer. A Group ID is unique across owners.
21. An owner has at most one current value of each group-identifier type.
22. Every migrated role or organisation group whose source record has a GIAS group UID keeps that UID, with issuer GIAS. A group UID with issuer Establishment Registry is allocated from the range for its owner's kind.

## Date convention

All dated relationships use a half-open period. The start date is the first day that the relationship applies; the end or left date is the first day it no longer applies. Successive periods can therefore meet on the same day without a gap or overlap.

- A placeholder source date becomes null, not a factual business date.
- Source-derived date basis, first-observed dates and inference rules are retained in the separate `migration` schema. They are migration evidence for administrators, not attributes of new live-service records.
- An end or left date is `evidenced` when a source records it, and `inferred` when it is derived from the closure of an establishment, party or group. An inferred end is an upper bound: the relationship may have ended earlier.
- Audit timestamps record when a target row was entered separately from these business dates.

## Source correspondence

Source tables and fields correspond to target concepts as follows; they do not define target entities or identifiers.

| Source data | Target concept | Mapping outcome |
| --- | --- | --- |
| Academy-trust records | `legal_entity`, `establishment_party_role`, `academy_trust_classification`, `organisation_identifier` | Resolve to the real legal entity. Create an academy-trust role and its dated SAT, MAT or SSAT classifications. SAT and MAT records for the same company become one continuous role with successive classifications. Authoritative Companies House, UKPRN and Charity Commission identifiers become organisation identifiers. |
| Academy-trust links | `establishment_responsibility` | Create `run_by_academy_trust` periods after identity resolution. |
| Sponsor records and links | `legal_entity` or `person`, `establishment_party_role`, then `establishment_responsibility` | Resolve the sponsor party and create a school-sponsor role for each continuous role period. Create `sponsored_by` responsibilities only for evidenced establishment links. The role does not assert formal approval or governance rights. |
| Foundation-trust records and links | `legal_entity`, `establishment_party_role`, then `establishment_responsibility` | Create a foundation-trust role for each continuous role period and `supported_by_foundation_trust` responsibilities for evidenced links. |
| Umbrella-trust records | `legal_entity`, `establishment_party_role` | Create a legal entity and an umbrella-trust role. No establishment responsibility follows without relationship evidence. |
| Proprietor names and proprietor records | `legal_entity` or `person`, then `establishment_responsibility` | Create `proprietor` periods after resolving a body or person. |
| Federation and children's-centre records | `organisation_group` | Create the appropriate group type and lifecycle. |
| Federation and children's-centre links | `organisation_group_member` | Create dated memberships and the current lead-centre indication where evidenced. |
| Group UIDs and Group IDs | `group_identifier` | Keep each value exactly as issued, with issuer GIAS, against the role or organisation group that the source record resolves to. SAT and MAT records of one company put both UIDs on one role, with the MAT's current; a shared Group ID is stored once. Non-standard Group IDs are corrected in GIAS before the production migration. |
| Source group relationships | Migration lineage only | May support identity resolution but do not create a target group-to-group relationship. |

## Physical-model boundary

The target physical schema for this slice will contain the target tables represented in the ERD: `legal_entity`, `legal_entity_type`, `charity_status`, `organisation_identifier_type`, `organisation_identifier`, `establishment_party_role_type`, `establishment_party_role`, `academy_trust_type`, `academy_trust_classification`, `responsibility_type`, `establishment_responsibility`, `organisation_group_type`, `organisation_group`, `organisation_group_member`, `group_identifier_type`, `identifier_issuer` and `group_identifier`. Physical types, sequences and allocation mechanisms are specified by the physical schema.

It references the existing establishment, local-authority and person tables by their opaque identifiers. Migration lineage is deliberately outside this schema.
