# Establishment Subtype Attribute Matrix Gap Analysis

## Purpose

This document identifies candidate gaps in `education-provider-registry-docs/information/fields/establishment-subtype-attribute-matrix.csv` using the field evidence gathered under `docs/data/extract-data/establishment-fields/analysis`.

The focus is deliberately narrow: where the matrix has a blank cell for an establishment type and attribute, but our evidence says the Details tab can or does show that field for that type.

## Evidence Used

| Evidence | How it is used |
|---|---|
| `education-provider-registry-docs/information/fields/establishment-subtype-attribute-matrix.csv` | Target matrix being checked. A blank cell is treated as no current status for that attribute/type pair. |
| `details-tab-fields-csharp-resolution.md` | C# and metadata-derived view of fields that can render on the public Details tab. |
| `details-tab-fields-csharp-resolution-public-sample-validation.md` | Public website sample scrape, five random URNs per type where available. This is the strongest evidence that a field is actually rendered publicly. |
| `details-tab-fields-csharp-resolution-gap-analysis.md` | Existing comparison between C# resolution and the public sample scrape. |
| `establishment-subtype-attribute-matrix-ui-validation.md` | Earlier one-sample UI validation of the matrix. |
| `establishment-details-tab-fields-extract-gap-analysis.md` | Extract-led candidate gaps, especially where a field is data-driven or relationship-driven. |

## Method

We compared matrix attributes to resolved and scraped Details-tab field labels by exact label match. We did not fold synonyms or infer that differently named fields are equivalent.

A gap is reported where:

- the matrix contains an attribute row;
- the establishment type column for that attribute is blank; and
- either the public sample scrape renders the same field label for that type, or the C# resolver says the same field label can render for that type.

This means the table below is conservative for naming, but not a final business decision. Some fields are relationship-driven, display-only, or policy-driven rather than simple scalar establishment attributes.

## Summary

- Establishment type columns checked: 41
- Candidate blank-cell gaps found: 53
- Strong gaps with public website sample evidence: 47
- Resolver-only candidates: 6

### Gap Categories

| Category | Gap count |
|---|---:|
| Details-tab scalar field | 17 |
| Local authority display/geography | 30 |
| Relationship-driven field | 6 |

## Strong Candidate Gaps

These are the gaps we should review first because a sampled public establishment page rendered the field while the matrix cell is blank.

| Attribute | Blank type count | Affected establishment types |
|---|---:|---|
| Local authority | 30 | `06` City technology college<br>`08` Non-maintained special school<br>`10` Other independent special school<br>`11` Other independent school<br>`18` Further education<br>`24` Secure units<br>`25` Offshore schools<br>`26` Service children's education<br>`27` Miscellaneous<br>`28` Academy sponsor led<br>`29` Higher education institutions<br>`31` Sixth form centres<br>`32` Special post 16 institution<br>`33` Academy special sponsor led<br>`34` Academy converter<br>`35` Free schools<br>`36` Free schools special<br>`37` British schools overseas<br>`38` Free schools alternative provision<br>`39` Free schools 16 to 19<br>`40` University technical college<br>`41` Studio schools<br>`42` Academy alternative provision converter<br>`43` Academy alternative provision sponsor led<br>`44` Academy special converter<br>`45` Academy 16-19 converter<br>`46` Academy 16 to 19 sponsor led<br>`49` Online provider<br>`56` Institution funded by other government department<br>`57` Academy secure 16 to 19 |
| Gender of entry | 7 | `08` Non-maintained special school<br>`10` Other independent special school<br>`18` Further education<br>`29` Higher education institutions<br>`31` Sixth form centres<br>`32` Special post 16 institution<br>`49` Online provider |
| Academy sponsor | 6 | `35` Free schools<br>`38` Free schools alternative provision<br>`39` Free schools 16 to 19<br>`40` University technical college<br>`42` Academy alternative provision converter<br>`43` Academy alternative provision sponsor led |
| Admissions policy | 1 | `49` Online provider |
| Further education type | 1 | `18` Further education |
| Nursery provision | 1 | `15` Local authority nursery school |
| Type of resourced provision | 1 | `06` City technology college |

## Strong Gap Detail

| Type code | Establishment type | Attribute | Category | Sample URNs used |
|---|---|---|---|---|
| `06` | City technology college | Local authority | Local authority display/geography | 111772, 101850, 122153, 104129, 101092 |
| `06` | City technology college | Type of resourced provision | Details-tab scalar field | 111772, 101850, 122153, 104129, 101092 |
| `08` | Non-maintained special school | Gender of entry | Details-tab scalar field | 113652, 125460, 117064, 125482, 122390 |
| `08` | Non-maintained special school | Local authority | Local authority display/geography | 113652, 125460, 117064, 125482, 122390 |
| `10` | Other independent special school | Gender of entry | Details-tab scalar field | 135454, 135784, 137807, 149890, 134614 |
| `10` | Other independent special school | Local authority | Local authority display/geography | 135454, 135784, 137807, 149890, 134614 |
| `11` | Other independent school | Local authority | Local authority display/geography | 120333, 133738, 123928, 133524, 138871 |
| `15` | Local authority nursery school | Nursery provision | Details-tab scalar field | 109763, 100100, 104135, 119081, 100472 |
| `18` | Further education | Further education type | Details-tab scalar field | 135658, 130626, 130554, 130473, 128521 |
| `18` | Further education | Gender of entry | Details-tab scalar field | 135658, 130626, 130554, 130473, 128521 |
| `18` | Further education | Local authority | Local authority display/geography | 135658, 130626, 130554, 130473, 128521 |
| `24` | Secure units | Local authority | Local authority display/geography | 133084, 128614, 133061, 128604, 133205 |
| `25` | Offshore schools | Local authority | Local authority display/geography | 132446, 132401, 139586, 132488, 132452 |
| `26` | Service children's education | Local authority | Local authority display/geography | 133007, 132390, 132388, 132678, 132395 |
| `27` | Miscellaneous | Local authority | Local authority display/geography | 133924, 133072, 133047, 132903, 133161 |
| `28` | Academy sponsor led | Local authority | Local authority display/geography | 138435, 147758, 143145, 144985, 141233 |
| `29` | Higher education institutions | Gender of entry | Details-tab scalar field | 133845, 133827, 133850, 133847, 133793 |
| `29` | Higher education institutions | Local authority | Local authority display/geography | 133845, 133827, 133850, 133847, 133793 |
| `31` | Sixth form centres | Gender of entry | Details-tab scalar field | 132915, 132931, 135368, 134821, 132956 |
| `31` | Sixth form centres | Local authority | Local authority display/geography | 132915, 132931, 135368, 134821, 132956 |
| `32` | Special post 16 institution | Gender of entry | Details-tab scalar field | 148194, 142918, 131947, 147315, 143526 |
| `32` | Special post 16 institution | Local authority | Local authority display/geography | 148194, 142918, 131947, 147315, 143526 |
| `33` | Academy special sponsor led | Local authority | Local authority display/geography | 151644, 143862, 142940, 146668, 149322 |
| `34` | Academy converter | Local authority | Local authority display/geography | 149649, 149415, 136297, 137222, 144322 |
| `35` | Free schools | Academy sponsor | Relationship-driven field | 147650, 140934, 151634, 139421, 140204 |
| `35` | Free schools | Local authority | Local authority display/geography | 147650, 140934, 151634, 139421, 140204 |
| `36` | Free schools special | Local authority | Local authority display/geography | 144764, 147845, 149108, 151726, 147849 |
| `37` | British schools overseas | Local authority | Local authority display/geography | 150058, 151343, 150766, 149171, 150980 |
| `38` | Free schools alternative provision | Academy sponsor | Relationship-driven field | 141942, 141164, 145918, 141136, 141141 |
| `38` | Free schools alternative provision | Local authority | Local authority display/geography | 141942, 141164, 145918, 141136, 141141 |
| `39` | Free schools 16 to 19 | Academy sponsor | Relationship-driven field | 150793, 151725, 141030, 140621, 149755 |
| `39` | Free schools 16 to 19 | Local authority | Local authority display/geography | 150793, 151725, 141030, 140621, 149755 |
| `40` | University technical college | Academy sponsor | Relationship-driven field | 142884, 141111, 140542, 146648, 141941 |
| `40` | University technical college | Local authority | Local authority display/geography | 142884, 141111, 140542, 146648, 141941 |
| `41` | Studio schools | Local authority | Local authority display/geography | 139783, 138256, 140965, 142128, 137317 |
| `42` | Academy alternative provision converter | Academy sponsor | Relationship-driven field | 142487, 142258, 140241, 151933, 144285 |
| `42` | Academy alternative provision converter | Local authority | Local authority display/geography | 142487, 142258, 140241, 151933, 144285 |
| `43` | Academy alternative provision sponsor led | Academy sponsor | Relationship-driven field | 147594, 146734, 148144, 146958, 150652 |
| `43` | Academy alternative provision sponsor led | Local authority | Local authority display/geography | 147594, 146734, 148144, 146958, 150652 |
| `44` | Academy special converter | Local authority | Local authority display/geography | 143506, 143013, 140277, 138661, 141726 |
| `45` | Academy 16-19 converter | Local authority | Local authority display/geography | 144886, 152062, 144829, 145007, 150514 |
| `46` | Academy 16 to 19 sponsor led | Local authority | Local authority display/geography | 150380, 141491 |
| `49` | Online provider | Admissions policy | Details-tab scalar field | 150780, 151867, 151745, 151523, 150541 |
| `49` | Online provider | Gender of entry | Details-tab scalar field | 150780, 151867, 151745, 151523, 150541 |
| `49` | Online provider | Local authority | Local authority display/geography | 150780, 151867, 151745, 151523, 150541 |
| `56` | Institution funded by other government department | Local authority | Local authority display/geography | 130784 |
| `57` | Academy secure 16 to 19 | Local authority | Local authority display/geography | 150154 |

## Resolver-Only Candidates

These fields are blank in the matrix and are resolved by the C# view/model evidence, but were not seen in the public sample for that establishment type. They need more caution because rendering may depend on record data, public display policy, security/legacy type handling, or relationship state.

| Attribute | Blank type count | Affected establishment types |
|---|---:|---|
| Diocese | 1 | `57` Academy secure 16 to 19 |
| Further education type | 1 | `57` Academy secure 16 to 19 |
| Inspectorate name | 1 | `57` Academy secure 16 to 19 |
| Religious character | 1 | `57` Academy secure 16 to 19 |
| Religious ethos | 1 | `57` Academy secure 16 to 19 |
| Special classes | 1 | `57` Academy secure 16 to 19 |

## Interpretation

### Local Authority Is The Clearest Matrix Issue

The largest and clearest gap pattern is `Local authority`. The public Details tab renders `Local authority` for many establishment types where the matrix has a blank cell. The legacy evidence points to a single displayed local-authority field in this analysis. We should correct `Local authority` directly where the evidence shows it is displayed or extractable.

### Relationship Fields Need A Modelling Decision

Fields such as `Academy trust`, `Academy sponsor`, `Single-academy trust`, `Trust`, `Federation`, and `Childrens' centre group` are visible on public pages, but they are not ordinary scalar establishment attributes. They are derived from group or governance relationships. If the matrix is intended to describe the public Details tab, these should be represented. If the matrix is intended only to describe scalar establishment attributes, it should explicitly exclude relationship-derived fields.

### Display And Service-Link Fields Need Scope Confirmation

Fields such as `Website`, `Ofsted rating and reports`, and `Data from other services` appear on public pages. Some are links or presentation constructs rather than source attributes. The matrix should either include them as displayable attributes or document that these are intentionally outside scope.

### Resolver-Only Fields Are Not Automatic Matrix Corrections

The C# resolver identifies fields that can render, but the public page may suppress a field for a specific record. For example, previous analysis showed that `Proprietor's name` can be present in metadata but not shown on a checked public page. Resolver-only candidates should be treated as prompts for further checking, not automatic matrix updates.

## Recommended Updates

1. Update the matrix for strong public-sample gaps where the attribute is a normal Details-tab field and the matrix is intended to describe public display capability.
2. Correct the blank `Local authority` cells where the public Details tab and extract evidence show that the field is present.
3. Decide whether relationship-derived fields belong in the matrix. If they do, populate academy trust, sponsor, trust, federation and children's centre group fields from relationship evidence rather than scalar-field assumptions.
4. Decide whether display/service-link fields belong in the matrix. If they are excluded, add an explicit exclusion note so future readers do not treat these as accidental gaps.
5. Use the resolver-only candidate list as a review backlog, not as an automatic correction list.

## Limits

- The comparison uses exact field-label matches only.
- The public sample validation used up to five random establishments per type, not every establishment.
- Some fields depend on data availability, display policy, establishment status, group membership, or secure/legacy handling.
- A blank matrix cell may be intentional if the matrix has a narrower scope than public Details-tab display. Where that is the case, the scope should be documented in the matrix itself.
