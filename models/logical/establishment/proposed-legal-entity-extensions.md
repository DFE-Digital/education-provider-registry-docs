# Proposed legal-entity extensions: local authorities, sole traders and partnerships

Date: 2 November 2026.

Status: proposal for review. This document records the proposed changes to the EPR logical and physical models; it does not apply schema or migration changes.

## Proposed direction

Represent local authorities, sole-trader businesses and partnerships within the existing `legal_entity` structure. Link a sole-trader business to its individual trader and a partnership to its partners. Use typed, dated establishment responsibilities to describe each body's relationship to establishments.

Preserve the existing geographical relationship from an establishment to its local authority. Geography and maintenance remain separate facts, even when they refer to the same authority.

The EPR meaning of Legal entity includes unincorporated bodies and business representations. It does not imply separate legal personality in every case. In particular, a sole-trader business is not legally separate from its individual trader. The person and business records must remain explicitly connected.

## Current position and decisions being revisited

| Area | Current recorded position | Proposed change |
| --- | --- | --- |
| Legal-entity types | The logical model and SQL seeds already include Public body, Sole trader and Traditional partnership. | Retain these types and define the missing relationships. This is not a request to add duplicate reference values. |
| Local authority | `local_authority` exists as a separate table. Decision D6 deferred linking it to `legal_entity`. | Resolve that deferral by linking each in-scope authority to one legal entity. |
| Individual proprietor | D10 and the proprietor lifecycle explanation represent an individual proprietor as a person, without creating a second sole-trader record just for a trading name. | Revisit D10 for an evidenced sole-trader business: represent that business as a legal entity linked to the individual, with the proprietor responsibility held by the business representation. |
| Partnership proprietor | D10 already represents evidenced partnerships such as “Mr & Mrs Readhead (Partnership)” as traditional-partnership legal entities. | Retain that representation and add explicit partner relationships. |
| LA maintenance | `maintained_by_local_authority` is deferred to the accountability slice and is not seeded among current responsibility types. | Add the responsibility type and define its holder, applicability and lifecycle rules. |

Do not infer sole-trader status from a personal name, or partnership status from two names or a marriage. Resolve the actual arrangement using source evidence. Direct person-held sponsorship remains valid; sponsoring an academy does not imply operating a sole-trader business.

## Logical-model proposal

### Local authority as a legal entity

An authority's legal entity represents the public body. The existing `local_authority` entity retains its DfE code, jurisdiction, geographic references and contacts, and links to that legal entity. Use the existing Public body legal-entity type; Local authority is the specialist entity/category rather than a replacement legal-form value.

The authority can hold `maintained_by_local_authority` establishment responsibilities through its `legal_entity_id`. Do not create a second legal entity for each school or geographic reference. Do not invent a new recognised-role type solely because an authority has maintenance responsibilities; assess that separately if required.

```text
ESTABLISHMENT
   |
   +-- ESTABLISHMENT_GEOGRAPHY --> LOCAL_AUTHORITY
   |                                  |
   |                                  +-- identifies --> LEGAL_ENTITY
   |                                                     (public body)
   +-- ESTABLISHMENT_RESPONSIBILITY ----------------------+
          type: maintained_by_local_authority
          holder: that authority's legal entity
          own period and source-current status
```

This expands the responsibility pattern, rather than replacing precise relationships with a universal “operated by” label. Maintaining, running, sponsoring and being proprietor remain distinct responsibility types. Employer or admissions-authority responsibilities would require their own definitions if added later.

### Sole trader linked to one person

A sole-trader legal entity is the business representation of exactly one individual trader. It must have a required relationship to `person`. This does not assert a separate legal person or two independent owners of the same responsibility.

Proposed default: one sole-trader representation per individual, with trading names treated as names rather than new legal identities. Confirm this identity rule before implementing uniqueness constraints. A change of individual trader is not a routine name change: review identity and establishment-responsibility succession instead of repointing the existing business record to a different person.

Where evidence establishes a sole-trader proprietor, attach its establishment responsibility to the business legal entity. The linked person explains who the trader is. Avoid creating a duplicate current proprietor responsibility on the person for the same fact.

### Partnership linked to its partners

Represent the partnership as a legal entity, with dated relationships to each partner. An ordinary operating partnership has at least two partners; incomplete migration evidence must be distinguished from a confirmed one-partner arrangement.

Partners may be individuals or bodies, so the relationship must support either `person` or `legal_entity` as the partner. Record exactly one target for each partner relationship. Do not allow the partnership to be its own partner.

```text
LEGAL_ENTITY: sole-trader business --> PERSON: individual trader

LEGAL_ENTITY: partnership
   +-- partner relationship, period --> PERSON
   +-- partner relationship, period --> PERSON or LEGAL_ENTITY

LEGAL_ENTITY: business/partnership
   +-- ESTABLISHMENT_RESPONSIBILITY --> ESTABLISHMENT
```

Partner changes do not automatically imply either continuity or a new partnership identity. Define the succession rules from evidence and the relevant arrangement. Where the responsible party changes, end the old establishment responsibility and create the succeeding one, preserving history.

### Keep recognised roles separate

Legal-entity type describes the body's form or business arrangement. A recognised role describes its education capacity. A responsibility describes its relationship with one establishment for a period. Neither a person link nor a legal-entity type automatically confers an academy-trust or sponsor role.

Continue to link each responsibility directly to its holder and establishment. Do not add a responsibility-to-role foreign key as part of this proposal.

## Physical-model proposal

The names below are proposed additions, not existing implemented tables. Keep current schema names and identifiers where already defined.

| Object | Proposed physical change | Integrity rules |
| --- | --- | --- |
| `establishment.local_authority` | Add `legal_entity_id` referencing `establishment.legal_entity`. | Unique when populated: one LA specialist record per linked legal entity. Backfill before requiring it for the agreed in-scope authority population. Codes and geography FKs remain on the existing structures. |
| `establishment.legal_entity_sole_trader` — new | `legal_entity_id` as PK/FK to legal entity; required `person_id` FK to person. | Exactly one trader per sole-trader entity. Require the Sole trader type. Make `person_id` unique if the proposed one-representation-per-individual rule is accepted. |
| `establishment.legal_entity_partner` — new | Generated relationship ID; required `partnership_legal_entity_id`; alternative `partner_person_id` and `partner_legal_entity_id`; nullable `start_date` and `end_date`; explicit source-current status following the existing pattern. | Exactly one partner target. Validate the partnership type, prevent self-reference, validate date order and prevent duplicate/overlapping relationships for the same partnership and partner. Dates and source-current status remain distinct. |
| `establishment.establishment_responsibility_type` | Add Maintained by local authority using the agreed reference-code convention. | Select its identifier during implementation; do not assume an unused integer here. Existing responsibility values retain their meanings. |
| `establishment.establishment_responsibility` | Reuse the existing holder, establishment, type, period and `is_current` columns. | LA-maintenance rows require a legal-entity holder linked to `local_authority`; `person_id` must be null. Define school applicability and permitted concurrent-maintainer rules. |
| Existing seeds, mappings and views | Populate links and expose the agreed business/person traversal to consumers. | Preserve source evidence and avoid counting the linked person and sole-trader representation as two independent proprietors. |

Some rules span rows or tables: legal-entity type checks, existence of a required subtype link, partner counts and maintenance-holder eligibility cannot be enforced by a simple row-level CHECK alone. Select deferred constraint triggers, structural constraints and migration validation as appropriate to the final design. Do not claim the proposed FKs alone enforce all business rules.

Retain the existing exclusive holder rule on roles and responsibilities: exactly one of `legal_entity_id` and `person_id` is populated. This proposal does not remove direct person holders globally or make every establishment responsibility legal-entity-only.

## Migration and evidence

1. Resolve each LA to its public-body legal entity and backfill the explicit link. Preserve authority codes, geographic associations and reorganisation history; do not infer identity from a repeated name alone.
2. Review individual-proprietor evidence to distinguish confirmed sole-trader businesses from unresolved individuals. Retain the evidence supporting each classification and the link to the individual.
3. For converted sole-trader cases, migrate responsibility holders without creating a false business event or invented effective date. Preserve actual responsibility periods, source-current status and provenance.
4. Resolve existing partnership records and attach evidenced partners. Do not invent missing partners, personal identities or membership dates to satisfy completeness rules; stage unresolved cases for review.
5. Load maintenance responsibilities from maintenance/accountability evidence. Geographic LA alone must not generate maintenance responsibilities for all establishments, especially academies and independent schools.

## Acceptance scenarios for implementation

| Scenario | Expected outcome |
| --- | --- |
| One individual proprietor with an evidenced sole-trader business | One person linked to one sole-trader legal entity; the business holds the proprietor responsibility; no duplicate person-held copy. |
| One trader uses two trading names | No extra proprietor identity solely because the names differ, subject to the agreed identity rule. |
| Husband and wife are evidenced as a partnership proprietor | One partnership legal entity, two person partner links, and the partnership's proprietor responsibility. |
| A company is a partner | Partner relationship references the company legal entity rather than manufacturing a person record. |
| A trader incorporates and the registered proprietor changes | Separate company legal entity; preserve person/trader identity; end and start responsibilities at evidenced dates. |
| A maintained school and an academy are in the same LA | Both retain geographic LA associations; maintenance responsibility is recorded only where applicable and evidenced. |
| A person is recognised as an academy sponsor | Person-held role and sponsorship remain valid without creating a sole-trader business. |
| Missing trader link, self-partner or ineligible maintenance holder | Reject invalid target records or stage incomplete migration evidence under explicit review rules. |

## Decisions to settle before implementation

- Confirm the revised D10 rule, including how individual proprietors without evidence of a trading business should be represented.
- Confirm one sole-trader business representation per individual and how trading names are recorded.
- Define partnership continuity, current-partner completeness and supported partnership forms.
- Define the in-scope LA population, identity/reorganisation handling, maintenance applicability and concurrent-responsibility constraints.
- Select the database enforcement mechanisms and migrate existing consumers that currently follow person-held proprietor responsibilities.

## Model and documentation updates

- [Groups logical model](../../../../../education-provider-registry-docs/models/logical/establishment/establishment-groups-logical-model.md): legal entities, person associations, responsibilities and current accountability exclusions.
- [Geography logical model](../../../../../education-provider-registry-docs/models/logical/establishment/geography.md): LA identity link while retaining geographic associations.
- [Physical establishment schema](../../../../../education-provider-registry-docs/models/schema/establishment/establishment-schema.sql): LA link, sole-trader subtype, partner associations and integrity rules.
- [Reference-data seeds](../../../../../education-provider-registry-docs/models/schema/seed/seed-academy-trust-reference-data.sql): retain existing entity types; add maintenance responsibility and fixture coverage.
- [Groups modelling recommendation](../groups/establishment-groups-logical-model-recommendation.md): revisit D6 and D10 and update worked examples and migration rules.
- [Proprietor lifecycle explanation](../groups/establishment-proprietor-lifecycle-explained.md): reconcile its current direct-person rule with this proposal once agreed.
- [Establishment vocabulary](../../../../../education-provider-registry-docs/models/establishment/establishment-vocabulary.ttl), [taxonomy](../../../../../education-provider-registry-docs/models/establishment/establishment-taxonomy.ttl), [ontology](../../../../../education-provider-registry-docs/models/establishment/establishment-ontology.ttl) and related SHACL: align definitions, LA classification, holder rules and relationship semantics.

## External terminology references

- [GOV.UK: sole traders](https://www.gov.uk/become-sole-trader): an individual running their own business.
- [GOV.UK: partnerships](https://www.gov.uk/set-up-business-partnership): partners share business responsibilities; a partner can also be a legal person such as a company.
- [DfE maintained-schools governance guide](https://www.gov.uk/government/publications/maintained-schools-governance-guide/maintained-schools-governance-guide): responsibility allocation varies by school type, supporting precise responsibility types rather than a single “operated by” relationship.
