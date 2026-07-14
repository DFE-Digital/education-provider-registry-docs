# Establishment Details Tab Fields Extract Gap Analysis

## Purpose

We need to improve the accuracy of `docs/data/extract-data/establishment-fields/establishment-details-tab-fields-by-type.md`.

That document records the fields observed on the public GIAS Details tab for one sampled establishment per establishment type. This is useful rendered-page evidence, but it can miss fields where the sampled establishment is not representative.

This note uses the full establishment extract to identify targeted candidate gaps. For each candidate, we capture a URN that can be checked on the public website before changing the observed Details-tab field list.

## Method

We compared three evidence sources:

- `docs/data/extract-data/establishment-fields/establishment-details-tab-fields-by-type.md`
- `docs/data/extract-data/establishment-fields/edubasealldata20260616.csv`
- `docs/data/extract-data/establishment-fields/EstablishmentFieldToTypeMapping.csv`

A candidate gap is reported only where:

- the field label is not present in the sampled Details-tab field list for that establishment type
- the legacy field/type mapping includes the field for that establishment type
- the full extract contains at least one establishment of that type with a populated value for the corresponding extract column
- placeholder values such as blank, `Not applicable`, `Does not apply`, `Not recorded` and `-` are ignored

This gives us a focused list of URNs to web-check. It does not prove that the field appears on the public Details tab, because the extract records data availability rather than presentation policy.

### Web-check status values

The `Web-check status` column records whether the captured URN has been checked against the public Details tab:

- `Not checked` means the row is still only an extract and mapping candidate.
- `Confirmed gap` means the label rendered on the public Details tab for the captured URN and should be considered for addition to `establishment-details-tab-fields-by-type.md`.
- `Not a Details-tab gap` means the captured URN was checked and the label did not render on the public Details tab, even though the extract had a populated value.

## Finding

The targeted gaps are mostly relationship fields: academy trust, academy sponsor and proprietor. This makes sense because the sampled establishment can have a different relationship profile from other establishments of the same type.

The strongest next step is to call the public Details page for the captured URNs and confirm whether the missing label renders for that establishment.

The first web-check shows why this status is needed. URN `100759` has `PropsName = Haberdasherers Askes CTC` in the extract and `AdditionalProprietorNumber` is mapped for type `06 City technology college`, but the public Details tab at `https://www.get-information-schools.service.gov.uk/Establishments/Establishment/Details/100759#school-dashboard` does not render `Proprietor's name`. This is therefore not a confirmed gap in the Details-tab evidence.

## Candidate Web Checks

| Type code | Establishment type | Current sample URN | Candidate missing label | Legacy mapped field | Type row count | Populated rows | URN to check | Establishment to check | Extract column | Example value | Web-check status | Web-check note |
| --- | --- | ---: | --- | --- | ---: | ---: | ---: | --- | --- | --- | --- | --- |
| `06` | City technology college | 100759 | Proprietor's name | AdditionalProprietorNumber | 15 | 13 | 100759 | Haberdashers' Aske's Hatcham College | PropsName | Haberdasherers Askes CTC | Not a Details-tab gap | Checked public Details tab for URN `100759`; `Proprietor's name` was not visible. |
| `12` | Foundation special school | 100060 | Academy trust | Trusts | 129 | 55 | 100760 | Brent Knoll School | Trusts (name) | *Co-op Brent Knoll and Watergate Co-operative Trust | Not checked |  |
| `28` | Academy sponsor led | 101857 | Academy sponsor | SchoolSponsors | 2,923 | 2,607 | 129342 | Grace Academy Solihull | SchoolSponsors (name) | Tove Learning Trust | Not checked |  |
| `28` | Academy sponsor led | 101857 | Academy trust | Trusts | 2,923 | 2,680 | 105135 | St Paul's Academy | Trusts (name) | ST BENEDICT CATHOLIC ACADEMY TRUST | Not checked |  |
| `38` | Free schools alternative provision | 138262 | Academy sponsor | SchoolSponsors | 61 | 33 | 138277 | Derby Pride Academy | SchoolSponsors (name) | Esteem Multi-Academy Trust | Not checked |  |
| `38` | Free schools alternative provision | 138262 | Academy trust | Trusts | 61 | 54 | 138264 | Stone Soup Academy | Trusts (name) | STONE SOUP LEARNS | Not checked |  |
| `39` | Free schools 16 to 19 | 138403 | Academy sponsor | SchoolSponsors | 39 | 22 | 139433 | Trinity Sixth Form Academy | SchoolSponsors (name) | Trinity Multi Academy Trust | Not checked |  |
| `40` | University technical college | 136933 | Academy sponsor | SchoolSponsors | 67 | 29 | 139234 | The JCB Academy | SchoolSponsors (name) | JCB | Not checked |  |
| `40` | University technical college | 136933 | Academy trust | Trusts | 67 | 47 | 136933 | Black Country UTC | Trusts (name) | BLACK COUNTRY UTC | Not checked |  |
| `41` | Studio schools | 137317 | Academy sponsor | SchoolSponsors | 48 | 13 | 138368 | Parkside Studio College | SchoolSponsors (name) | The Rosedale Hewens Academy Trust | Not checked |  |
| `41` | Studio schools | 137317 | Academy trust | Trusts | 48 | 20 | 138368 | Parkside Studio College | Trusts (name) | THE ROSEDALE HEWENS ACADEMY TRUST | Not checked |  |
| `42` | Academy alternative provision converter | 138967 | Academy sponsor | SchoolSponsors | 109 | 70 | 139197 | Links Academy | SchoolSponsors (name) | Links Academy Trust | Not checked |  |
| `42` | Academy alternative provision converter | 138967 | Academy trust | Trusts | 109 | 95 | 139197 | Links Academy | Trusts (name) | LINKS MULTI ACADEMY TRUST | Not checked |  |
| `43` | Academy alternative provision sponsor led | 137496 | Academy sponsor | SchoolSponsors | 47 | 31 | 140627 | Three Towers Alternative Provision Academy | SchoolSponsors (name) | The Rowan Learning Trust | Not checked |  |
| `43` | Academy alternative provision sponsor led | 137496 | Academy trust | Trusts | 47 | 36 | 140627 | Three Towers Alternative Provision Academy | Trusts (name) | THE ROWAN LEARNING TRUST | Not checked |  |
| `44` | Academy special converter | 137286 | Academy sponsor | SchoolSponsors | 359 | 227 | 137363 | Cambridge Park Academy | SchoolSponsors (name) | Humber Education Trust | Not checked |  |
| `45` | Academy 16-19 converter | 138966 | Academy sponsor | SchoolSponsors | 42 | 15 | 142283 | One Sixth Form College | SchoolSponsors (name) | West Suffolk College | Not checked |  |

## Interpretation

This analysis supports the idea that the Details-tab field list should not be treated as a complete type-level field catalogue when it is based on one establishment per type.

However, we should not automatically add every candidate field to `establishment-details-tab-fields-by-type.md`. That file records observed public UI output. A field should only be added after we call the website for the captured URN and confirm that the label renders on the public Details tab.

The better workflow is:

1. Use the full extract and field/type mapping to find candidate gaps.
2. Capture one or more URNs where the field has a real value.
3. Call the public Details page only for those URNs.
4. Update `establishment-details-tab-fields-by-type.md` only when the field is confirmed in rendered public UI.

This keeps the web-check volume low while reducing the risk that a single unrepresentative sample defines the field surface for an entire establishment type.

Rows marked `Not a Details-tab gap` should remain in this analysis as evidence that extract population and field/type mapping are not sufficient on their own to update the observed public Details-tab catalogue.
