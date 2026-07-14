# Details Tab Fields C# Resolution Gap Analysis

## Purpose

This document compares the C# and field-metadata resolver in `details-tab-fields-csharp-resolution.md` with the public-page sample scrape in `details-tab-fields-csharp-resolution-public-sample-validation.md`.

It identifies where the resolver expects a Details-tab field that was not seen in the sampled public pages, and where the public sample shows a field that is missing from the resolver.

## Methodology

- Parsed the per-type field table from `details-tab-fields-csharp-resolution.md`.
- Parsed the per-type public scrape table from `details-tab-fields-csharp-resolution-public-sample-validation.md`.
- Compared field labels case-insensitively within each establishment type.
- Treated labels as exact strings. No synonym folding was applied, so labels such as `School type`, `Provider type` and `Establishment type` remain distinct.
- Reported two gap directions: `Resolved but not seen in public sample` and `Seen in public sample but not resolved`.

## Summary

| Measure | Count |
| --- | ---: |
| Establishment types compared | 46 |
| Types with at least one sampled public URN | 41 |
| Types without sampled public URNs | 5 |
| Types with resolver-only fields | 45 |
| Types with public-sample-only fields | 41 |

## Main Patterns

The public sample often shows fields that the resolver deliberately excluded or under-resolved, especially:

- `Website`, `Ofsted rating and reports`, `Data from other services` and free-school-meals fields. These are C# render paths but are not controlled only by simple `EstablishmentFieldToTypeMapping.csv` rows.
- Academy relationship labels such as `Academy trust`, `Academy sponsor` and `Single-academy trust`. These are rendered from group relationships in `Header.cshtml`, not from a simple establishment field.
- `Proprietor's name` for independent and online-provider types. This confirms the resolver needs more than the single `ProprietorBodyName` mapping used in the first pass.
- `Trust`, `Federation` and `Childrens' centre group`, which are group relationship labels rather than scalar establishment fields.

The resolver-only side is strongest where the backend metadata says a field can apply, but the sampled public pages did not happen to show it, or public display policy suppresses it for sampled records. Secure and legacy-like types show this most clearly.

## Most Common Resolver-Only Fields

| Field | Type count | Type codes |
| --- | ---: | --- |
| Headteacher / Principal appointment date | 43 | 01, 02, 03, 05, 06, 07, 08, 09, 10, 11, 12, 14, 15, 17, 18, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 56, 57, 98 |
| Type of SEN provision | 7 | 09, 10, 17, 22, 23, 57, 98 |
| Teenage mothers places | 6 | 09, 17, 22, 23, 57, 98 |
| Teenage mothers | 6 | 09, 17, 22, 23, 57, 98 |
| Childcare facilities provision | 6 | 09, 17, 22, 23, 57, 98 |
| Special classes | 6 | 09, 17, 22, 23, 57, 98 |
| Number of pupils | 6 | 09, 17, 22, 23, 57, 98 |
| Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan | 6 | 09, 17, 22, 23, 57, 98 |
| Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan | 6 | 09, 17, 22, 23, 57, 98 |
| SEN facilities | 6 | 09, 17, 22, 23, 57, 98 |
| Resourced provision capacity | 6 | 09, 17, 22, 23, 57, 98 |
| Resourced provision number on roll | 6 | 09, 17, 22, 23, 57, 98 |
| Special Educational Needs (SEN) unit capacity | 6 | 09, 17, 22, 23, 57, 98 |
| Special Educational Needs (SEN) unit number on roll | 6 | 09, 17, 22, 23, 57, 98 |
| Number of places | 6 | 09, 17, 22, 23, 57, 98 |

## Most Common Public-Sample-Only Fields

| Field | Type count | Type codes |
| --- | ---: | --- |
| Percentage of children eligible for free school meals | 37 | 01, 02, 03, 05, 06, 07, 08, 10, 11, 12, 14, 15, 18, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 56 |
| Number of pupils eligible for free school meals | 37 | 01, 02, 03, 05, 06, 07, 08, 10, 11, 12, 14, 15, 18, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 56 |
| Website | 33 | 01, 02, 03, 05, 06, 07, 08, 10, 11, 12, 14, 15, 18, 28, 29, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 49, 57 |
| Ofsted rating and reports | 32 | 01, 02, 03, 05, 06, 07, 08, 10, 11, 12, 14, 15, 18, 26, 28, 29, 32, 33, 34, 35, 36, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48 |
| Data from other services | 24 | 01, 02, 03, 05, 06, 07, 08, 10, 11, 12, 18, 26, 28, 31, 33, 34, 35, 36, 39, 40, 41, 44, 45, 46 |
| Type of resourced provision | 22 | 01, 02, 03, 05, 06, 07, 12, 15, 28, 33, 34, 35, 36, 38, 39, 40, 41, 42, 43, 44, 45, 46 |
| Academy trust | 15 | 28, 33, 34, 35, 36, 38, 39, 40, 41, 42, 43, 44, 45, 46, 57 |
| Academy sponsor | 13 | 28, 33, 34, 35, 36, 38, 39, 40, 42, 43, 44, 45, 46 |
| Single-academy trust | 4 | 34, 39, 44, 45 |
| Proprietor's name | 4 | 08, 10, 11, 49 |
| Federation | 3 | 03, 07, 12 |
| Inspectorate name | 3 | 08, 10, 11 |
| Trust | 2 | 05, 12 |
| Date of Next Inspection Visit | 1 | 37 |
| Inspectorate report | 1 | 37 |
| Childrens' centre group | 1 | 47 |
| Date last changed / confirmed | 1 | 32 |
| Closed date | 1 | 32 |
| Date of Last Inspection Visit | 1 | 37 |

## Per-Type Gap Analysis

| Type code | Establishment type | Resolved field count | Sample URNs fetched | Scraped field count | Resolved but not seen in public sample | Seen in public sample but not resolved | Notes |
| --- | --- | ---: | --- | ---: | --- | --- | --- |
| `01` | Community school | 30 | 129944, 120888, 102154, 119299, 114479 | 35 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `02` | Voluntary aided school | 30 | 127940, 109219, 112011, 115154, 103868 | 35 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `03` | Voluntary controlled school | 30 | 110515, 124240, 129250, 116847, 123141 | 36 | Headteacher / Principal appointment date | Data from other services; Federation; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `05` | Foundation school | 30 | 117525, 101554, 113106, 119771, 117568 | 36 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Trust; Type of resourced provision; Website |  |
| `06` | City technology college | 32 | 111772, 101850, 122153, 104129, 101092 | 37 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `07` | Community special school | 30 | 103601, 107183, 100666, 104840, 118147 | 36 | Headteacher / Principal appointment date | Data from other services; Federation; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `08` | Non-maintained special school | 28 | 113652, 125460, 117064, 125482, 122390 | 34 | Headteacher / Principal appointment date | Data from other services; Inspectorate name; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Proprietor's name; Website |  |
| `09` | Independent school approved for SEN pupils | 42 |  | 0 | Address; Local authority; Headteacher / Principal; Headteacher / Principal appointment date; Age range; Phase of education; School type; Further education type; Gender of entry; ID; Establishment status; Admissions policy; Telephone; Religious character; Diocese; Religious ethos; Boarders; Nursery provision; Official sixth form; School capacity; Number of pupils; Open date; Reason establishment opened; Closed date; Reason establishment closed; Special classes; Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan; Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan; Type of SEN provision; Date last changed / confirmed; Teenage mothers; Teenage mothers places; Childcare facilities provision; SEN facilities; Pupils with EBD; Number of places; Full time provision; Pupils educated by other providers; Resourced provision number on roll; Resourced provision capacity; Special Educational Needs (SEN) unit number on roll; Special Educational Needs (SEN) unit capacity | None | No sampled URNs available in local extracts. |
| `10` | Other independent special school | 29 | 135454, 135784, 137807, 149890, 134614 | 34 | Headteacher / Principal appointment date; Type of SEN provision | Data from other services; Inspectorate name; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Proprietor's name; Website |  |
| `11` | Other independent school | 28 | 120333, 133738, 123928, 133524, 138871 | 34 | Headteacher / Principal appointment date | Data from other services; Inspectorate name; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Proprietor's name; Website |  |
| `12` | Foundation special school | 30 | 119036, 103622, 100766, 108652, 113643 | 37 | Headteacher / Principal appointment date | Data from other services; Federation; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Trust; Type of resourced provision; Website |  |
| `14` | Pupil referral unit | 27 | 106022, 118230, 138450, 138102, 134024 | 30 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Website |  |
| `15` | Local authority nursery school | 30 | 109763, 100100, 104135, 119081, 100472 | 34 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `17` | European schools | 42 |  | 0 | Address; Local authority; Headteacher / Principal; Headteacher / Principal appointment date; Age range; Phase of education; School type; Further education type; Gender of entry; ID; Establishment status; Admissions policy; Telephone; Religious character; Diocese; Religious ethos; Boarders; Nursery provision; Official sixth form; School capacity; Number of pupils; Open date; Reason establishment opened; Closed date; Reason establishment closed; Special classes; Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan; Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan; Type of SEN provision; Date last changed / confirmed; Teenage mothers; Teenage mothers places; Childcare facilities provision; SEN facilities; Pupils with EBD; Number of places; Full time provision; Pupils educated by other providers; Resourced provision number on roll; Resourced provision capacity; Special Educational Needs (SEN) unit number on roll; Special Educational Needs (SEN) unit capacity | None | No sampled URNs available in local extracts. |
| `18` | Further education | 19 | 135658, 130626, 130554, 130473, 128521 | 23 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Website |  |
| `22` | Early years setting | 42 |  | 0 | Address; Local authority; Headteacher / Principal; Headteacher / Principal appointment date; Age range; Phase of education; School type; Further education type; Gender of entry; ID; Establishment status; Admissions policy; Telephone; Religious character; Diocese; Religious ethos; Boarders; Nursery provision; Official sixth form; School capacity; Number of pupils; Open date; Reason establishment opened; Closed date; Reason establishment closed; Special classes; Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan; Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan; Type of SEN provision; Date last changed / confirmed; Teenage mothers; Teenage mothers places; Childcare facilities provision; SEN facilities; Pupils with EBD; Number of places; Full time provision; Pupils educated by other providers; Resourced provision number on roll; Resourced provision capacity; Special Educational Needs (SEN) unit number on roll; Special Educational Needs (SEN) unit capacity | None | No sampled URNs available in local extracts. |
| `23` | Playing for success centres | 42 |  | 0 | Address; Local authority; Headteacher / Principal; Headteacher / Principal appointment date; Age range; Phase of education; School type; Further education type; Gender of entry; ID; Establishment status; Admissions policy; Telephone; Religious character; Diocese; Religious ethos; Boarders; Nursery provision; Official sixth form; School capacity; Number of pupils; Open date; Reason establishment opened; Closed date; Reason establishment closed; Special classes; Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan; Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan; Type of SEN provision; Date last changed / confirmed; Teenage mothers; Teenage mothers places; Childcare facilities provision; SEN facilities; Pupils with EBD; Number of places; Full time provision; Pupils educated by other providers; Resourced provision number on roll; Resourced provision capacity; Special Educational Needs (SEN) unit number on roll; Special Educational Needs (SEN) unit capacity | None | No sampled URNs available in local extracts. |
| `24` | Secure units | 16 | 133084, 128614, 133061, 128604, 133205 | 17 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Percentage of children eligible for free school meals |  |
| `25` | Offshore schools | 17 | 132446, 132401, 139586, 132488, 132452 | 18 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Percentage of children eligible for free school meals |  |
| `26` | Service children's education | 17 | 133007, 132390, 132388, 132678, 132395 | 20 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals |  |
| `27` | Miscellaneous | 16 | 133924, 133072, 133047, 132903, 133161 | 17 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Percentage of children eligible for free school meals |  |
| `28` | Academy sponsor led | 32 | 138435, 147758, 143145, 144985, 141233 | 39 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `29` | Higher education institutions | 18 | 133845, 133827, 133850, 133847, 133793 | 21 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Website |  |
| `30` | Welsh establishment | 17 | 401405, 401867, 400339, 401338, 401768 | 18 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Percentage of children eligible for free school meals |  |
| `31` | Sixth form centres | 18 | 132915, 132931, 135368, 134821, 132956 | 20 | Headteacher / Principal appointment date | Data from other services; Number of pupils eligible for free school meals; Percentage of children eligible for free school meals |  |
| `32` | Special post 16 institution | 19 | 148194, 142918, 131947, 147315, 143526 | 23 | Headteacher / Principal appointment date | Closed date; Date last changed / confirmed; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Website |  |
| `33` | Academy special sponsor led | 32 | 151644, 143862, 142940, 146668, 149322 | 39 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `34` | Academy converter | 32 | 149649, 149415, 136297, 137222, 144322 | 40 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Single-academy trust; Type of resourced provision; Website |  |
| `35` | Free schools | 32 | 147650, 140934, 151634, 139421, 140204 | 39 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `36` | Free schools special | 32 | 144764, 147845, 149108, 151726, 147849 | 39 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `37` | British schools overseas | 18 | 150058, 151343, 150766, 149171, 150980 | 23 | Headteacher / Principal appointment date | Date of Last Inspection Visit; Date of Next Inspection Visit; Inspectorate report; Number of pupils eligible for free school meals; Percentage of children eligible for free school meals; Website |  |
| `38` | Free schools alternative provision | 32 | 141942, 141164, 145918, 141136, 141141 | 38 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `39` | Free schools 16 to 19 | 32 | 150793, 151725, 141030, 140621, 149755 | 40 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Single-academy trust; Type of resourced provision; Website |  |
| `40` | University technical college | 32 | 142884, 141111, 140542, 146648, 141941 | 39 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `41` | Studio schools | 32 | 139783, 138256, 140965, 142128, 137317 | 38 | Headteacher / Principal appointment date | Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `42` | Academy alternative provision converter | 32 | 142487, 142258, 140241, 151933, 144285 | 38 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `43` | Academy alternative provision sponsor led | 32 | 147594, 146734, 148144, 146958, 150652 | 38 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `44` | Academy special converter | 32 | 143506, 143013, 140277, 138661, 141726 | 40 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Single-academy trust; Type of resourced provision; Website |  |
| `45` | Academy 16-19 converter | 32 | 144886, 152062, 144829, 145007, 150514 | 40 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Single-academy trust; Type of resourced provision; Website |  |
| `46` | Academy 16 to 19 sponsor led | 32 | 150380, 141491 | 39 | Headteacher / Principal appointment date | Academy sponsor; Academy trust; Data from other services; Number of pupils eligible for free school meals; Ofsted rating and reports; Percentage of children eligible for free school meals; Type of resourced provision; Website |  |
| `47` | Children's centre | 20 | 21081, 22461, 20646, 20912, 23575 | 16 | Manager appointment date; Operational hours; Governance; Governance detail; Group lead centre; Disadvantaged area; Direct provision of early years | Childrens' centre group; Ofsted rating and reports; Website |  |
| `48` | Children's centre linked site | 13 | 21462, 23571, 23454, 22870, 20220 | 13 | Manager appointment date | Ofsted rating and reports |  |
| `49` | Online provider | 26 | 150780, 151867, 151745, 151523, 150541 | 28 | None | Proprietor's name; Website |  |
| `56` | Institution funded by other government department | 16 | 130784 | 17 | Headteacher / Principal appointment date | Number of pupils eligible for free school meals; Percentage of children eligible for free school meals |  |
| `57` | Academy secure 16 to 19 | 54 | 150154 | 17 | Headteacher / Principal appointment date; Age range; Further education type; Admissions policy; Religious character; Diocese; Religious ethos; Boarders; Nursery provision; Official sixth form; Number of pupils; Section 41 approved; Operational hours; Governance; Governance detail; Group lead centre; Disadvantaged area; Direct provision of early years; Special classes; Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan; Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan; Type of SEN provision; Quality assurance body name; Quality assurance body report; Companies House number; Establishment accredited; Teenage mothers; Teenage mothers places; Childcare facilities provision; SEN facilities; Pupils with EBD; Number of places; Full time provision; Pupils educated by other providers; Resourced provision number on roll; Resourced provision capacity; Special Educational Needs (SEN) unit number on roll; Special Educational Needs (SEN) unit capacity; Inspectorate name | Academy trust; Website |  |
| `98` | Legacy types | 42 |  | 0 | Address; Local authority; Headteacher / Principal; Headteacher / Principal appointment date; Age range; Phase of education; School type; Further education type; Gender of entry; ID; Establishment status; Admissions policy; Telephone; Religious character; Diocese; Religious ethos; Boarders; Nursery provision; Official sixth form; School capacity; Number of pupils; Open date; Reason establishment opened; Closed date; Reason establishment closed; Special classes; Number of special pupils under a special educational needs (SEN) statement/education, health and care (EHC) plan; Number of special pupils not under a special educational needs (SEN) statement/education, health and care (EHC) plan; Type of SEN provision; Date last changed / confirmed; Teenage mothers; Teenage mothers places; Childcare facilities provision; SEN facilities; Pupils with EBD; Number of places; Full time provision; Pupils educated by other providers; Resourced provision number on roll; Resourced provision capacity; Special Educational Needs (SEN) unit number on roll; Special Educational Needs (SEN) unit capacity | None | No sampled URNs available in local extracts. |

## Interpretation

The comparison shows that the C# resolver is useful, but incomplete as a source of public Details-tab truth. It resolves scalar display-policy fields well, but misses relationship-driven rows and service-link rows unless those are modelled separately.

The public sample is also incomplete because it is still sampled evidence. A field can be valid for a type but absent from five sampled records if the value, relationship, status or display-policy condition is not present in those records.

The next improvement should be to extend the resolver with separate treatment for:

- Group relationship labels from `Header.cshtml`, including academy trust, academy sponsor, single-academy trust, trust, federation and children's centre group.
- Service-link fields such as `Website`, `Ofsted rating and reports` and `Data from other services`.
- Public display-policy suppression for secure and other restricted establishment types.
- Independent-school and online-provider proprietor display, which is visible in sampled public pages but not fully captured by the current resolver.
