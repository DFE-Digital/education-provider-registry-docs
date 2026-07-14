# Establishment Subtype Attribute Matrix UI Validation

## Purpose

We need to validate `education-provider-registry-docs/information/fields/establishment-subtype-attribute-matrix.csv` against the observed public Details-tab evidence in `docs/data/extract-data/establishment-fields/establishment-details-tab-fields-by-type.md`.

This note records potential gaps where the Details-tab evidence says a field was visible for a representative establishment type, but the subtype attribute matrix leaves the corresponding type column blank.

## Method

We compared:

- the `Details tab fields observed` list for each establishment type in `establishment-details-tab-fields-by-type.md`
- the `Attribute` rows and establishment-type columns in `establishment-subtype-attribute-matrix.csv`

The comparison was intentionally conservative:

- only exact label matches were compared
- only blank matrix cells were reported as potential gaps
- labels that do not exist as matrix attributes were not treated as failures in this pass

This means the findings below are not a full semantic validation of every field. They are a focused list of places where the matrix appears to have dropped a field that the UI evidence explicitly observed.

The Details-tab evidence only records whether a label was rendered for one sampled establishment. It does not prove that the field is required, populated, or semantically applicable for every establishment of that type. For example, the sampled type `15 Local authority nursery school` record `100004 Sherborne Nursery School` renders `Nursery provision`, but the value is `Not applicable`.

For accuracy, we need to separate four different facts:

- whether the field is rendered on the public UI
- whether the field is configured for the establishment type in legacy field/type metadata
- whether the field is populated across real extract rows for that type
- whether the field should be required, optional or not applicable in the target model

## Summary

| Measure | Count |
| --- | ---: |
| Observed Details-tab field entries checked | 1,232 |
| Observed field entries with exact matrix attribute match | 703 |
| Potential blank-cell gaps found | 42 |

The largest pattern is `Local authority`. The Details-tab evidence shows `Local authority` for many types where the matrix is blank.

This is probably not because the sampled records lacked local-authority values. For example:

- type `18 Further education`, sample `127066`, had `Local authority` in the Details-tab evidence
- the extract row for `127066` has `LA (code) = 330` and `LA (name) = Birmingham`
- the extract row for `130793 Abingdon and Witney College` has `LA (code) = 931` and `LA (name) = Oxfordshire`
- all 489 type `18 Further education` rows in `edubasealldata20260616.csv` have a non-blank `LA (name)`
- `EstablishmentFieldToTypeMapping.csv` includes `LA,18`

The likely issue is that the matrix has blank `Local authority` cells even where the legacy public UI and extract evidence show a local authority value. For this analysis we should treat `Local authority` as the field we can evidence from legacy.

## Potential Gaps

| Type code | Establishment type | Sample URN | Attribute blank in matrix |
| --- | --- | ---: | --- |
| `35` | Free schools | 136750 | Academy sponsor |
| `49` | Online provider | 149905 | Admissions policy |
| `18` | Further education | 127066 | Further education type |
| `08` | Non-maintained special school | 101696 | Gender of entry |
| `10` | Other independent special school | 101077 | Gender of entry |
| `18` | Further education | 127066 | Gender of entry |
| `29` | Higher education institutions | 130545 | Gender of entry |
| `31` | Sixth form centres | 132838 | Gender of entry |
| `32` | Special post 16 institution | 121777 | Gender of entry |
| `49` | Online provider | 149905 | Gender of entry |
| `06` | City technology college | 100759 | Local authority |
| `08` | Non-maintained special school | 101696 | Local authority |
| `10` | Other independent special school | 101077 | Local authority |
| `11` | Other independent school | 100001 | Local authority |
| `18` | Further education | 127066 | Local authority |
| `24` | Secure units | 128604 | Local authority |
| `25` | Offshore schools | 132351 | Local authority |
| `26` | Service children's education | 132269 | Local authority |
| `27` | Miscellaneous | 104755 | Local authority |
| `28` | Academy sponsor led | 101857 | Local authority |
| `29` | Higher education institutions | 130545 | Local authority |
| `31` | Sixth form centres | 132838 | Local authority |
| `32` | Special post 16 institution | 121777 | Local authority |
| `33` | Academy special sponsor led | 138253 | Local authority |
| `34` | Academy converter | 136266 | Local authority |
| `35` | Free schools | 136750 | Local authority |
| `36` | Free schools special | 138271 | Local authority |
| `37` | British schools overseas | 130892 | Local authority |
| `38` | Free schools alternative provision | 138262 | Local authority |
| `39` | Free schools 16 to 19 | 138403 | Local authority |
| `40` | University technical college | 136933 | Local authority |
| `41` | Studio schools | 137317 | Local authority |
| `42` | Academy alternative provision converter | 138967 | Local authority |
| `43` | Academy alternative provision sponsor led | 137496 | Local authority |
| `44` | Academy special converter | 137286 | Local authority |
| `45` | Academy 16-19 converter | 138966 | Local authority |
| `46` | Academy 16 to 19 sponsor led | 141491 | Local authority |
| `49` | Online provider | 149905 | Local authority |
| `56` | Institution funded by other government department | 130784 | Local authority |
| `57` | Academy secure 16 to 19 | 150154 | Local authority |
| `15` | Local authority nursery school | 100004 | Nursery provision |
| `06` | City technology college | 100759 | Type of resourced provision |

## Interpretation

We should treat this as a matrix quality issue, not as a problem with the Details-tab evidence.

The Details-tab evidence was built from rendered pages and already warns that it is downstream public UI evidence. It should not be treated as the only source of truth for field applicability, but it is enough to flag matrix gaps where the matrix is blank for fields that were visibly rendered.

The strongest correction candidate is `Local authority`, because it is supported by:

- Details-tab evidence
- extract rows
- field/type mapping

Other candidate gaps, such as `Academy sponsor` for `35 Free schools` and `Type of resourced provision` for `06 City technology college`, should be checked against the underlying display policy and field metadata before changing the matrix. They may be record-specific UI visibility rather than universal type-level applicability.

`Nursery provision` for `15 Local authority nursery school` is a useful example of why we should not rely on the single sampled page alone. The sample record has a `Not applicable` value, but the full extract for type `15` contains 619 records:

| `NurseryProvision (name)` value | Count |
| --- | ---: |
| Has Nursery Classes | 450 |
| Not applicable | 161 |
| No Nursery Classes | 7 |
| Blank | 1 |

`EstablishmentFieldToTypeMapping.csv` also includes `NurseryProvision,15`. This means the field is configured for the type and often populated, even though the sampled establishment was not a good representative for the value distribution.

## Recommended Next Step

We should update the matrix generation or normalisation logic so it does not infer type-level absence from a narrow interpretation of the UI evidence.

At minimum, we should correct the `Local authority` cells where public UI, extract and mapping evidence show that the field is present.

Before bulk-editing the CSV, we should decide whether matrix values mean:

- displayed on the public Details tab for at least one sampled record
- configured in `EstablishmentFieldToTypeMapping`
- present in the extract
- required, optional or not applicable in the target model

Those are different evidence types. Mixing them is what appears to have created this gap.

A better validation pass would profile every candidate attribute across all rows in `docs/data/extract-data/establishment-fields/edubasealldata20260616.csv`, grouped by establishment type. For each field/type pair, we should record:

- UI observed in the one-record sample
- legacy field/type mapping present
- extract column present
- extract row count for the type
- non-blank count
- `Not applicable` count
- distinct values
- recommended matrix status
- confidence level

This avoids web-calling every establishment while still moving beyond a sample size of one.
