# Education provision and measures

This document defines education admissions, provision, age range and current capacity and pupil measures.

## Education admissions and provision

`education_admissions_and_provision` groups facts about how the establishment
operates as an education provider, including entry, admissions, boarding,
nursery and sixth-form provision.

Business-friendly pattern:

```text
How does this establishment admit and provide education to its pupils?
```

- It is an optional, at-most-one owned substructure for an establishment.
- Its values are direct references to controlled classifications.
- The statutory age range is a child concept reached through this boundary.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `education_admissions_and_provision_id` | Conditional | Technical key for the owned provision substructure. |
| `establishment_id` | Conditional | One-to-one owner relationship to `establishment`. |
| `gender_of_entry_type_id` | Conditional | Controlled gender-of-entry value where applicable. |
| `admissions_policy_id` | Conditional | Controlled admissions-policy value where applicable. |
| `boarding_provision_id` | Conditional | Controlled boarding-provision value where applicable. |
| `nursery_provision_id` | Conditional | Controlled nursery-provision value where applicable. |
| `sixth_form_provision_id` | Conditional | Controlled sixth-form-provision value where applicable. |

### Modelling placement and relationships

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

## Gender of entry type

`gender_of_entry_type` provides the controlled classification selected by an
establishment's provision record.

Business-friendly pattern:

```text
What gender-of-entry classification applies to this establishment?
```

- This is a classification, not an owned person or membership entity.
- Applicability is determined by the establishment context and reference data.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `gender_of_entry_type_id` | Yes | Seeded integer reference-data identifier. |
| `name` | Yes | Human-readable gender-of-entry label. |

## Admissions policy

`admissions_policy` provides the controlled classification of the
establishment's admissions policy.

Business-friendly pattern:

```text
What admissions policy applies to this establishment?
```

- It remains separate from establishment type and gender of entry.
- It is held through `education_admissions_and_provision`.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `admissions_policy_id` | Yes | Seeded integer reference-data identifier. |
| `name` | Yes | Human-readable admissions-policy label. |

## Boarding provision

`boarding_provision` describes the controlled boarding arrangement associated
with the establishment.

Business-friendly pattern:

```text
Does this establishment provide boarding, and what kind?
```

- It is a controlled provision classification, not a pupil or accommodation record.
- It is held through `education_admissions_and_provision`.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `boarding_provision_id` | Yes | Seeded integer reference-data identifier. |
| `name` | Yes | Human-readable boarding-provision label. |

## Nursery provision

`nursery_provision` records the controlled nursery-provision classification.

Business-friendly pattern:

```text
Does this establishment provide nursery classes?
```

- It is separate from the education phase and age range.
- It is held through `education_admissions_and_provision`.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `nursery_provision_id` | Yes | Seeded integer reference-data identifier. |
| `name` | Yes | Human-readable nursery-provision label. |

## Sixth-form provision

`sixth_form_provision` records the controlled sixth-form classification.

Business-friendly pattern:

```text
Does this establishment provide a sixth form?
```

- It is a provision classification, not an education-phase replacement.
- It is held through `education_admissions_and_provision`.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `sixth_form_provision_id` | Yes | Seeded integer reference-data identifier. |
| `name` | Yes | Human-readable sixth-form-provision label. |

## Statutory age range

`statutory_age_range` represents the regulated lower and upper ages for which
an establishment is registered.

Business-friendly pattern:

```text
What is the youngest and oldest age for which this establishment is registered?
```

- It is a distinct pair of related values, not two unrelated establishment attributes.
- It is reached through `education_admissions_and_provision`.
- The lower age is 0-19; the upper age is 0-25 and cannot be below the lower age.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `statutory_age_range_id` | Yes | Technical key for the age-range child record. |
| `education_admissions_and_provision_id` | Yes | One-to-one owner relationship to the provision substructure. |
| `lower_statutory_age` | Yes when a range exists | Lowest registered age; integer from 0 to 19. |
| `upper_statutory_age` | Yes when a range exists | Highest registered age; integer from 0 to 25 and no lower than the lower age. |

### Modelling placement and validation

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


## Capacity and pupil measures

`capacity_and_pupil_measures` groups current operational measures about places
and pupils at the establishment.

Business-friendly pattern:

```text
How many places and pupils does this establishment have,
and how many pupils are eligible for free school meals at the observation date?
```

- At most one current measure block is held for an establishment in this slice.
- `census_date` supplies the shared temporal context for pupil count and FSM measure.
- The FSM value counts eligible pupils, not meals served.
- Historical and multi-period measures are deferred to a future lifecycle/history model.

| Column | Required | Meaning and rule |
| --- | --- | --- |
| `capacity_and_pupil_measures_id` | Yes | Technical key for the owned measure block. |
| `establishment_id` | Yes | One-to-one owner relationship to `establishment`. |
| `school_capacity` | Conditional | Registered number of pupil places; non-negative integer. |
| `pupil_count` | Conditional | Number of pupils on roll in the source establishment record; non-negative integer. |
| `free_school_meal_measure` | Conditional | Number of pupils recorded as eligible for free school meals at the census date; non-negative integer. |
| `census_date` | Conditional | Statutory DfE school census date shared by the pupil measures. |


### Measurement placement and lifecycle

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

