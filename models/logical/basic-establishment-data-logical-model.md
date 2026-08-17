# Basic Establishment Data Logical Model

## Purpose

This is the first logical-model slice for the Establishment Registry. It defines the minimum data needed to identify and describe an establishment for the anonymous Find and Share journeys.

## Scope

In scope:

- URN.
- Local authority code and establishment number (displayed together as the DfE number / LAESTAB).
- UKPRN.
- Establishment name.
- Establishment type.
- Age range.
- Phase of education.
- Gender of entry.
- Admissions policy.
- Boarding provision.
- Nursery provision.
- Sixth-form provision.
- School capacity.
- Pupil count.
- Free school meal measure.
- Census date for the pupil measures.
- Specialist provision measures, including SEN unit and resourced provision where applicable.
- Main site, additional sites, and postal address.

Out of scope for this slice:

- Establishment lifecycle and closure history.
- Contact details and address history.
- Groups, memberships and governance.
- Alternative and historic names.
- Source provenance, stewardship workflow, change history and audit structures.
- Physical database choices.

## Methodology

We have treated the current GIAS identifiers and public Establishment Details terminology as evidence, not as a target schema. The model follows the logical-model development process and keeps identifiers separate from classifications. It is a first, reviewable slice; it does not yet settle migration rules, identifier minting or physical storage.

## Logical Model

```mermaid
erDiagram
    ESTABLISHMENT }o--|| ESTABLISHMENT_TYPE : "has type"
    ESTABLISHMENT }o--o| EDUCATION_PHASE : "has phase"
    ESTABLISHMENT ||--o| EDUCATION_ADMISSIONS_AND_PROVISION : "has"
    ESTABLISHMENT ||--o| CAPACITY_AND_PUPIL_MEASURES : "has"
    ESTABLISHMENT ||--o| SPECIALIST_PROVISION : "has"
    EDUCATION_ADMISSIONS_AND_PROVISION }o--o| GENDER_OF_ENTRY_TYPE : "has gender of entry"
    EDUCATION_ADMISSIONS_AND_PROVISION }o--o| ADMISSIONS_POLICY : "has admissions policy"
    EDUCATION_ADMISSIONS_AND_PROVISION }o--o| BOARDING_PROVISION : "has boarding provision"
    EDUCATION_ADMISSIONS_AND_PROVISION }o--o| NURSERY_PROVISION : "has nursery provision"
    EDUCATION_ADMISSIONS_AND_PROVISION }o--o| SIXTH_FORM_PROVISION : "has sixth-form provision"
    EDUCATION_ADMISSIONS_AND_PROVISION ||--o| STATUTORY_AGE_RANGE : "has"

    ESTABLISHMENT {
        uuid establishment_id PK
        numeric urn UK
        string local_authority_code
        integer establishment_number
        numeric ukprn
        string name
    }

    ESTABLISHMENT_TYPE {
        integer establishment_type_id PK
        string name
    }

    EDUCATION_PHASE {
        integer education_phase_id PK
        string name
    }

    GENDER_OF_ENTRY_TYPE {
        integer gender_of_entry_type_id PK
        string name
    }

    ADMISSIONS_POLICY {
        integer admissions_policy_id PK
        string name
    }

    BOARDING_PROVISION {
        integer boarding_provision_id PK
        string name
    }

    NURSERY_PROVISION {
        integer nursery_provision_id PK
        string name
    }

    SIXTH_FORM_PROVISION {
        integer sixth_form_provision_id PK
        string name
    }

    EDUCATION_ADMISSIONS_AND_PROVISION {
        uuid education_admissions_and_provision_id PK
        uuid establishment_id FK, UK
        integer gender_of_entry_type_id FK
        integer admissions_policy_id FK
        integer boarding_provision_id FK
        integer nursery_provision_id FK
        integer sixth_form_provision_id FK
    }

    CAPACITY_AND_PUPIL_MEASURES {
        uuid capacity_and_pupil_measures_id PK
        uuid establishment_id FK, UK
        integer school_capacity
        integer pupil_count
        integer free_school_meal_measure
        date census_date
    }

    SPECIALIST_PROVISION {
        uuid specialist_provision_id PK
        uuid establishment_id FK, UK
    }

    STATUTORY_AGE_RANGE {
        uuid statutory_age_range_id PK
        uuid education_admissions_and_provision_id FK, UK
        integer lower_statutory_age
        integer upper_statutory_age
    }
```

## Location And Contact ERD

The location-and-contact branch is shown separately so the main establishment ERD remains readable. This branch contains every physical site at which the establishment operates — exactly one designated as the main site, plus zero or more additional sites — and each site's postal address. Contact details and address history are deferred.

```mermaid
erDiagram
    ESTABLISHMENT ||--|| ESTABLISHMENT_LOCATION_AND_CONTACT : "has"
    ESTABLISHMENT_LOCATION_AND_CONTACT ||--|{ SITE : "has"
    ESTABLISHMENT_LOCATION_AND_CONTACT ||--|| SITE : "designates as main"
    SITE }o--|| ADDRESS : "uses"

    ESTABLISHMENT {
        uuid establishment_id PK
        numeric urn UK
        string name
    }

    ESTABLISHMENT_LOCATION_AND_CONTACT {
        uuid establishment_location_and_contact_id PK
        uuid establishment_id FK, UK
        uuid main_site_id FK, UK
    }

    SITE {
        uuid site_id PK
        uuid establishment_location_and_contact_id FK
        uuid address_id FK
        string site_name
        integer uprn UK
    }

    ADDRESS {
        uuid address_id PK
        string address_line_1
        string address_line_2
        string address_line_3
        string town
        string county
        string postcode
    }
```

## Specialist Provision ERD

The specialist-provision branch is shown separately because it has its own internal structure and would make the main establishment ERD too dense.

```mermaid
erDiagram
    ESTABLISHMENT ||--o| SPECIALIST_PROVISION : "has"
    SPECIALIST_PROVISION }o--o| SPECIALIST_PROVISION_TYPE : "has type"
    SPECIALIST_PROVISION ||--o| RESOURCED_PROVISION : "has"
    SPECIALIST_PROVISION ||--o| SEN_UNIT_PROVISION : "has"

    ESTABLISHMENT {
        uuid establishment_id PK
        numeric urn UK
        string name
    }

    SPECIALIST_PROVISION {
        uuid specialist_provision_id PK
        uuid establishment_id FK, UK
        integer specialist_provision_type_id FK
    }

    SPECIALIST_PROVISION_TYPE {
        integer specialist_provision_type_id PK
        string name
    }

    RESOURCED_PROVISION {
        uuid resourced_provision_id PK
        uuid specialist_provision_id FK, UK
        integer capacity
        integer pupil_count
    }

    SEN_UNIT_PROVISION {
        uuid sen_unit_provision_id PK
        uuid specialist_provision_id FK, UK
        integer capacity
        integer pupil_count
    }
```

## Entities And Attributes

| Entity | Attribute | Required | Meaning and rule |
| --- | --- | --- | --- |
| Establishment | `establishment_id` | Yes | Generated, opaque technical key used for internal database relationships. It is not a public identifier. |
| Establishment | `urn` | Yes | Immutable, globally unique canonical business identifier. It is used for public routes, search and migration reconciliation. |
| Establishment | `local_authority_code` | Conditional | Local authority code component of the DfE number / LAESTAB. Stored separately so the owning authority and component can be validated independently. |
| Establishment | `establishment_number` | Conditional | Local-authority-scoped establishment number, between 1 and 9999 where present. The frontend composes it with `local_authority_code` for DfE number / LAESTAB display. |
| Establishment | `ukprn` | Conditional | Current UK Provider Reference Number supplied by UKRLP where applicable. |
| Establishment | `name` | Yes | Current published establishment name. Historic and alternative names are deferred. |
| Establishment type | `establishment_type_id` | Yes | Explicitly seeded integer reference-data identifier. An establishment has one current type in this slice. |
| Establishment type | `name` | Yes | Human-readable type label. |
| Education phase | `education_phase_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Education phase | `name` | Yes | Human-readable phase label. |
| Education admissions and provision | `education_admissions_and_provision_id` | Conditional | One owned substructure for education, admissions and provision facts where they apply to the establishment. This slice uses it to hold gender of entry, admissions policy, boarding provision, nursery provision, sixth-form provision and the statutory age range child fact. |
| Education admissions and provision | `gender_of_entry_type_id` | Conditional | Controlled gender-of-entry value selected for this establishment, where applicable. |
| Education admissions and provision | `admissions_policy_id` | Conditional | Controlled admissions-policy value selected for this establishment, where applicable. |
| Education admissions and provision | `boarding_provision_id` | Conditional | Controlled boarding-provision value selected for this establishment, where applicable. |
| Education admissions and provision | `nursery_provision_id` | Conditional | Controlled nursery-provision value selected for this establishment, where applicable. |
| Education admissions and provision | `sixth_form_provision_id` | Conditional | Controlled sixth-form-provision value selected for this establishment, where applicable. |
| Gender of entry type | `gender_of_entry_type_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Gender of entry type | `name` | Yes | Human-readable gender-of-entry label. |
| Admissions policy | `admissions_policy_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Admissions policy | `name` | Yes | Human-readable admissions-policy label. |
| Boarding provision | `boarding_provision_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Boarding provision | `name` | Yes | Human-readable boarding-provision label. |
| Nursery provision | `nursery_provision_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Nursery provision | `name` | Yes | Human-readable nursery-provision label. |
| Sixth-form provision | `sixth_form_provision_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Sixth-form provision | `name` | Yes | Human-readable sixth-form-provision label. |
| Capacity and pupil measures | `capacity_and_pupil_measures_id` | Conditional | One owned substructure for capacity and pupil-measure facts where they apply to the establishment. This slice uses it to hold school capacity, pupil count, the free school meal measure and the shared census date. |
| Capacity and pupil measures | `school_capacity` | Conditional | Registered number of pupil places for which the establishment is organised. Must be a non-negative integer where present. |
| Capacity and pupil measures | `pupil_count` | Conditional | Total number of pupils on roll at the establishment as recorded in the source establishment record. Must be a non-negative integer where present. |
| Capacity and pupil measures | `free_school_meal_measure` | Conditional | Number of pupils recorded as eligible for free school meals at the census date. Must be a non-negative integer where present. This is an eligibility count, not the number of meals served. |
| Capacity and pupil measures | `census_date` | Conditional | Statutory DfE school census date to which `pupil_count` and `free_school_meal_measure` relate. Stored once on the capacity-and-pupil-measures substructure, not repeated on each measure. |
| Specialist provision | `specialist_provision_id` | Conditional | One owned substructure for specialist-provision facts, including SEN unit and resourced-provision facts where they apply to the establishment. |
| Specialist provision | `specialist_provision_type_id` | Conditional | Controlled value indicating whether the establishment has resourced provision, a SEN unit, or both. |
| Specialist provision type | `specialist_provision_type_id` | Yes | Explicitly seeded integer reference-data identifier. |
| Specialist provision type | `name` | Yes | Human-readable specialist-provision-type label. |
| Establishment location and contact | `establishment_location_and_contact_id` | Yes | Owned boundary for the establishment's location and contact facts. This slice uses it for the establishment's sites; contact facts are deferred. |
| Establishment location and contact | `main_site_id` | Yes | Designates which one of the establishment's sites is the principal site. Exactly one is required in this slice. Must reference a `Site` owned by the same `establishment_location_and_contact_id`. |
| Site | `site_id` | Yes | Technical key for a physical site at which the establishment operates. |
| Site | `establishment_location_and_contact_id` | Yes | Owning establishment's location-and-contact boundary. A site belongs to exactly one establishment. |
| Site | `address_id` | Yes | Reusable technical key for the site's postal address. |
| Site | `site_name` | Conditional | Optional name for the site where one is supplied. It is not used to identify the establishment. |
| Site | `uprn` | Conditional | Ordnance Survey Unique Property Reference Number for the site's addressable location, where supplied. Numeric and persistent for the property's life cycle; identifies the physical property, not the establishment. Modelled on `Site`, not `Address` — see UPRN section below. |
| Address | `address_id` | Yes | Reusable technical key for a postal address. The address does not point back to a site; owning subjects hold the relationship. |
| Address | `address_line_1` | Conditional | First address line, mapped from BAU `Street`. |
| Address | `address_line_2` | Conditional | Second address line, where supplied. |
| Address | `address_line_3` | Conditional | Third address line, mapped from BAU `Address3`. |
| Address | `town` | Conditional | Town or locality town, mapped from BAU `Town`. |
| Address | `county` | Conditional | County where supplied. |
| Address | `postcode` | Conditional | Postal code, mapped from BAU `Postcode`. |
| Resourced provision | `capacity` | Conditional | Number of designated places in the resourced provision unit. Must be a non-negative integer where present. |
| Resourced provision | `pupil_count` | Conditional | Number of pupils on roll in the resourced provision unit. Must be a non-negative integer where present and must not exceed capacity when both are present. |
| SEN unit provision | `capacity` | Conditional | Number of designated places in the SEN unit. Must be a non-negative integer where present. |
| SEN unit provision | `pupil_count` | Conditional | Number of pupils on roll in the SEN unit. Must be a non-negative integer where present. |
| Statutory age range | `lower_statutory_age` | Yes, when a range exists | Lowest age for which the establishment is registered. Must be a non-negative integer no greater than `19`. |
| Statutory age range | `upper_statutory_age` | Yes, when a range exists | Highest age for which the establishment is registered. Must be a non-negative integer no greater than `25` and not lower than `lower_statutory_age`. |

## Statutory Age Range Placement

Age range is represented as `StatutoryAgeRange`, reached through `EducationAdmissionsAndProvision`, rather than as two bare attributes on `Establishment`. Its validation limits are defined in `education-provider-registry-docs/models/establishment/establishment-data-quality-shacl.ttl`.

```text
Establishment
  -> EducationAdmissionsAndProvision
    -> StatutoryAgeRange
       - AgeLow
       - AgeHigh
```

We should follow that logical boundary. Age range is a distinct, regulated pair of values, not two unrelated Establishment attributes. It also sits alongside admissions and provision facts which are outside this first slice but will be modelled later.

A physical model may ultimately store the two values as columns on an `Establishment` table for simplicity or performance. That is a physical-design decision. It must not erase the logical `StatutoryAgeRange` boundary or the type-specific applicability and validation rules.

The data-quality SHACL model sets the following limits:

- `AgeLow`: `0` to `19`.
- `AgeHigh`: `0` to `25`.
- `AgeHigh` must not be lower than `AgeLow`.

The last rule is stated in the current SHACL shape's comment but is not yet expressed as an executable cross-field constraint. The target implementation must enforce it.

## Education, Admissions And Provision Placement

`EducationAdmissionsAndProvision` is the owned substructure for education, admissions and provision facts that describe how the establishment operates as a school or provider.

In this slice it carries:

- `gender_of_entry_type_id`, a direct reference to controlled `GenderOfEntryType` reference data, the same pattern used for `establishment_type_id` and `education_phase_id` on `Establishment`.
- `admissions_policy_id`, a direct reference to controlled `AdmissionsPolicy` reference data.
- `boarding_provision_id`, a direct reference to controlled `BoardingProvision` reference data.
- `nursery_provision_id`, a direct reference to controlled `NurseryProvision` reference data.
- `sixth_form_provision_id`, a direct reference to controlled `SixthFormProvision` reference data.
- `StatutoryAgeRange`, which records the lower and upper statutory ages.

This means gender of entry, admissions policy, boarding provision, nursery provision and sixth-form provision are associated with an establishment through the provision substructure:

```text
Establishment
  -> EducationAdmissionsAndProvision
    -> GenderOfEntryType
    -> AdmissionsPolicy
    -> BoardingProvision
    -> NurseryProvision
    -> SixthFormProvision
```

These are deliberately not attributes on `Establishment` itself. The establishment record holds identity and headline classification facts; provision-specific facts sit below `EducationAdmissionsAndProvision`. Both are direct reference-data columns, not wrapper entities, because neither carries attributes of its own beyond the type it selects.

## Capacity And Specialist Provision Placement

One shared census date applies to the whole capacity-and-pupil-measures block, not a separate date per measure. Whether the free-school-meal measure is required or not applicable is determined per establishment type by the data-quality SHACL shapes.

School capacity, pupil count and the free school meal measure sit on `CapacityAndPupilMeasures`, not directly on `Establishment`, because they are business measurement facts about the establishment's operation, not identity or classification attributes. The `census_date` is held once on the same block because it provides the temporal context for both the pupil count and free school meal measure.

```text
Establishment
  -> CapacityAndPupilMeasures
     - SchoolCapacity
     - PupilCount
     - FreeSchoolMealMeasure
     - CensusDate
```

`SchoolCapacity` is the registered number of pupil places for which the establishment is organised. `PupilCount` is the current number of pupils on roll recorded in the source establishment record. They are separate business measures, but they are simple scalar values with the same owner and current lifecycle in this slice, so the physical model stores them as columns on `capacity_and_pupil_measures`.

`FreeSchoolMealMeasure` is the number of pupils recorded as eligible for free school meals. It is an eligibility measure, not a count of meals served. It is a separate scalar measure on the same substructure because it describes the establishment's pupil population and shares the census-date context with `PupilCount`.

`CensusDate` is the statutory DfE school census date to which `PupilCount` and `FreeSchoolMealMeasure` relate, typically a January census date. It is stored once for the block rather than repeated on each measure. The model therefore keeps the observation date explicit without turning each measure into a separate time-series entity; historical and multiple-period observations remain deferred to the lifecycle and history model.

SEN unit and resourced provision facts sit below `SpecialistProvision`, not below `EducationAdmissionsAndProvision`. These are specialist facility facts about the establishment, not admissions-policy facts.

`SpecialistProvision` is the establishment-level container for this branch of the model. It exists when the establishment has a recorded specialist SEN facility. The `SpecialistProvisionType` classifier records which kind of specialist provision is present:

- `Resourced provision`.
- `SEN unit`.
- `Resourced provision and SEN unit`.

`ResourcedProvision` and `SenUnitProvision` are modelled separately because they are not the same operational concept.

`ResourcedProvision` means the establishment has designated specialist resources for pupils with particular needs, usually within a mainstream setting. Pupils may access mainstream classes while receiving targeted specialist support. The model records the designated capacity and pupil count for that resourced provision.

`SenUnitProvision` means the establishment has a more distinct SEN unit provision, usually with dedicated places, staff or accommodation for pupils who need a more specialist setting. The model records the designated capacity and pupil count for that SEN unit provision.

An establishment can have one, the other, or both. The numeric measures are therefore separate child records because each provision type has its own capacity and pupil-count values.

```text
Establishment
    -> SpecialistProvision
    -> SpecialistProvisionType
    -> ResourcedProvision
       - Capacity
       - PupilCount
    -> SenUnitProvision
       - Capacity
       - PupilCount
```

## Site Placement

The BAU model does not have a first-class `Site` concept for the principal location. The primary site is implicit: its postal address is held as columns on `dbo.Establishment` (`Street`, `Locality`, `Address3`, `Town`, `Postcode`, `UPRN`, `Easting` and `Northing`). BAU stores additional physical locations separately in `dbo.EstablishmentAdditionalAddresses`, linked by URN and `record_number`.

The target model makes every physical location explicit as a `Site`, because it is a business concept, not just a group of address strings, and because an establishment can operate at more than one location:

```text
Establishment
  -> EstablishmentLocationAndContact
    -> Site (main)
      -> Address
    -> Site (additional, zero or more)
      -> Address
```

`EstablishmentLocationAndContact` is the owning boundary for location and contact facts; contact details are still deferred. It holds every `Site` at which the establishment operates and designates exactly one of them as the main site via `main_site_id`, rather than a role or Boolean flag carried on `Site` itself. This is a deliberate choice: "main" is a fact about which site the establishment currently points to, not an attribute of the site record, and a per-row flag would allow invalid states a single designating foreign key cannot (zero sites flagged main, or more than one).

Which establishment types, if any, should be permitted to have additional sites is not yet defined in this slice, and the logical model does not currently restrict it. This should be confirmed against evidence (for example, actual usage patterns in BAU's `EstablishmentAdditionalAddresses`) before an executable constraint is added.

`Address` is a reusable postal-address concept. It does not contain a `site_id`, because an address may be referenced by a site, a registered legal entity or another future subject. The foreign key is held by the using relationship (`Site.address_id`). The logical model therefore does not add address columns directly to `Establishment`. `main_site_id` must reference a `Site` owned by the same `establishment_location_and_contact_id`; this cross-field constraint is a physical-implementation decision, not yet expressed as an executable rule in this slice.

## UPRN

`Site.uprn` is the Ordnance Survey [Unique Property Reference Number](https://www.ordnancesurvey.co.uk/public/unique-property-reference-numbers) — a numeric identifier for the addressable location itself, not for the establishment.

**Justification.** The OS page defines a UPRN as "a unique numeric identifier for every spatial address in Great Britain" that persists "throughout a property's life cycle – from planning permission through to demolition." Read literally, the first clause ties a UPRN to an address; but the second clause only makes sense if the UPRN survives changes to that address's postal text over the property's lifetime — otherwise "persists throughout the life cycle" would say nothing beyond "exists while the property exists." This is not just a hypothetical reading: street names can and do change independently of the property itself — a local authority can rename or renumber a street, updating every postal address on it — while the property occupying any given plot, and its UPRN, remains the same. OS's own definition therefore implies the UPRN tracks the underlying property, not any one rendering of its postal text.

That distinction is what decides the placement in this model. `Address` here is a bag of current-value text fields (`address_line_1`, `town`, `postcode`) with no versioning or history — this slice explicitly defers address history (see Scope). An identifier that OS itself says must outlive changes to that text cannot correctly live on a record with no guarantee of surviving such changes. `Site` is the entity representing the stable physical location; `Address` is deliberately the mutable, current-value rendering of it. `uprn` therefore belongs on `Site`.

## Identifier Rules

| Identifier | Cardinality | Constraint | Note |
| --- | --- | --- | --- |
| URN | Exactly one | Globally unique and immutable | The canonical public establishment identifier for this slice. |
| DfE number / LAESTAB | Derived | Uniqueness requires local-authority context | Derived from `local_authority_code` and `establishment_number`, commonly rendered as `LA/ESTAB` with the establishment number zero-padded to four digits. |
| UKPRN | Zero or one | Eight-digit value; global uniqueness is not yet a target rule | Optional because it does not apply to every establishment. It is externally owned by UKRLP. |

The model must enforce the stated uniqueness constraints for the direct identifier attributes. The uniqueness scope for each identifier type must be defined by its owning authority.

## Classification Rules

- Establishment type and phase of education are reference-data classifications, not free text.
- An establishment has one current establishment type.
- An establishment may have one phase of education in this first slice. Any need for multiple phases must be evidenced before extending the model.
- An establishment has at most one current education, admissions and provision substructure and at most one statutory age range within it.
- An establishment has at most one current capacity and pupil measures substructure, carrying at most one school capacity, pupil-count, free-school-meal-measure and census-date value.
- `census_date` is shared by `pupil_count` and `free_school_meal_measure`; it is not a separate date for each measure.
- `free_school_meal_measure` is a count of pupils eligible for free school meals, not a count of meals served.
- An establishment has at most one current specialist-provision substructure, at most one resourced-provision measure and at most one SEN-unit-provision measure within it.
- Gender of entry is a reference-data classification held on the education, admissions and provision substructure, not its own owned entity.
- Admissions policy is a reference-data classification held on the education, admissions and provision substructure, not its own owned entity.
- Boarding provision is a reference-data classification held on the education, admissions and provision substructure, not its own owned entity.
- Nursery provision is a reference-data classification held on the education, admissions and provision substructure, not its own owned entity.
- Sixth-form provision is a reference-data classification held on the education, admissions and provision substructure, not its own owned entity.
- Every establishment has one or more current sites, exactly one of which is designated the main site, and every site has one current address in this slice.
- Additional sites are permitted for any establishment type in this slice; type-scoped restrictions are not yet defined (see Site Placement).
- The main site is not an establishment identifier; URN remains the canonical public identifier.
- Classification identifiers must be stable and labels may change without changing the establishment record.

## Deferred Decisions

| Decision | Why It Is Deferred |
| --- | --- |
| Identifier effective dates, supersession and reuse. | Requires lifecycle and migration evidence. |
| Type and phase history. | Requires a change-history and lifecycle model. |
| Complete age-range applicability by establishment type. | The EPR SHACL model contains many type-specific rules; this first slice does not yet reproduce them all. |
| Percentage eligible for free school meals. | A percentage sub-measure alongside the eligibility count has been raised as a candidate field; this slice first adds the requested count and shared census-date context. The percentage's logical placement and derivation rule should be confirmed in the next capacity-measures increment. |
| Provenance, stewardship and audit metadata. | These are cross-cutting structures to be designed consistently across later slices. |
| Additional-site type-scoped applicability as an executable rule. | Whether additional sites should be restricted to particular establishment types needs evidence (for example, BAU `EstablishmentAdditionalAddresses` usage patterns) before this slice encodes a rule. |
| Contact details and address history. | They require separate ownership, privacy and temporal decisions. |
| Site OS grid reference (easting/northing). | BAU carries `Easting` and `Northing` columns alongside the address fields; not requested for this slice. |

## Future-Requirements Assessment

| Requirement | Applies? | Score | Rationale | Required Action |
| --- | --- | --- | --- | --- |
| RBAC and ABAC | No | N/A | This anonymous public-data slice does not model protected operations. | Assess when create and edit journeys are modelled. |
| Data stewardship workflows | No | N/A | Workflow state is outside this read-focused slice. | Add to the authorised-change slice. |
| Change history | No | N/A | The slice holds current values only. | Add history structures with lifecycle and stewardship modelling. |
| Policy-change flexibility | Yes | 3 - Strong | Identifiers and classifications are separated; type and phase values are reference data. | Retain controlled reference-data governance. |

## Open Questions

- Which establishment types legitimately have no age range or phase of education?
- Is UKPRN uniqueness global across all provider and organisation records, not just establishments?
- Does the anonymous public beta require identifiers to be searchable, display-only, or both?
- Is `percentage eligible for free school meals` in scope for the next increment as a separate derived measure alongside `free_school_meal_measure`, and should it be stored or calculated from the count and pupil count?
- Which address fields are mandatory for each establishment type, and how should non-geocodable or non-postal establishments be represented?

### Local BAU migration mapping

The controlled local migration reads `dbo.Establishment` from `gias_bau_test_local`. `NumberOfPupils` maps to `pupil_count`, `freeSchoolMeals` maps to `free_school_meal_measure`, and `SchoolCapacity` maps to `school_capacity`. The primary address fields map to the main `Site -> Address`; additional rows from `dbo.EstablishmentAdditionalAddresses` map to additional `Site -> Address` records but are not yet implemented by the local migration. The source copy has no census-date field, so the migration leaves `census_date` null and records that absence rather than asserting a date that was not supplied by the source. The reusable BAU transform is maintained with the published model; the local target loader and orchestration runner are maintained privately in the local transformation workspace.
