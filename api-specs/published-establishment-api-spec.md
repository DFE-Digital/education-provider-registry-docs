# Published Establishment API specification

Contract version: `1.0.0`  
Service lifecycle: `beta`  
[OpenAPI 2.0 contract](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/api-specs/published-establishment-api.openapi.json)

## Endpoints

### Establishment detail

```http
GET /v1/establishments/{URN}
```

| Item | Contract |
| --- | --- |
| Origin | Environment-specific HTTPS origin. |
| Authentication | None. |
| Path | Lowercase fixed segments; no trailing slash. |
| `URN` | Required decimal string. Range: 1–999999. No leading zeroes, signs, whitespace or separators. |
| Query parameters | Not specified. |
| Request body | None. Non-empty body: `400 unexpected-request-body`. |
| Other methods | `405 method-not-allowed`; `Allow: GET`. |
| Unmatched path | `404`, including a trailing slash or missing path segment. |

Validate a matched URN before lookup. `/v1/establishments/ABC` returns `400 invalid-urn`. A valid URN without a published record returns `404 establishment-not-found`.

```http
GET /v1/establishments/137603 HTTP/1.1
Accept: application/json
Accept-Encoding: gzip
```

### Establishment collection

```http
GET /v1/establishments
GET /v1/establishments?status=open
GET /v1/establishments?status=closed
```

| Item | Contract |
| --- | --- |
| Authentication | None. |
| Path | `/v1/establishments`; no trailing slash. |
| `status` | Optional query string. One lowercase value: `open` or `closed`. |
| No `status` filter | Return both Open and Closed published establishments. |
| `status=open` | Return published establishments with `providerStatus.code` equal to `1` (Open). |
| `status=closed` | Return published establishments with `providerStatus.code` equal to `2` (Closed). |
| Invalid `status` | Empty, repeated or unsupported values: `400 invalid-status-filter`. Values are case-sensitive; do not trim whitespace. |
| Other query parameters | `400 unsupported-query-parameter`. |
| Request body | None. Non-empty body: `400 unexpected-request-body`. |
| Other methods | `405 method-not-allowed`; `Allow: GET`. |
| Success body | JSON array of complete `Establishment` objects, with the same fields as the detail endpoint for the same published data version. |
| No matches | `200` with `[]`. |
| Ordering | URN ascending, compared numerically. One item per URN. |
| Delivery | Return all matches in one response; no pagination or collection wrapper. |
| Publication | Read one consistent public projection. Exclude unpublished records and statuses other than Open and Closed. Missing required facts on a matching record: `503 publication-incomplete`; do not return a partial collection. |

Shared request headers, response headers, errors and conditional retrieval apply to both endpoints. A collection ETag covers the complete selected array after content coding.

```http
GET /v1/establishments HTTP/1.1
Accept: application/json
Accept-Encoding: gzip
```

Abbreviated response body; comments mark omitted fields and records. See [Payload examples](#payload-examples) for the complete establishment payloads.

```jsonc
[
  {
    "urn": "106789",
    "providerName": "Ridgewood School",
    "providerStatus": {"code": "2", "name": "Closed"}
    // ... the rest of the establishment payload
  },
  {
    "urn": "136286",
    "providerName": "Westlands School",
    "providerStatus": {"code": "1", "name": "Open"}
    // ... the rest of the establishment payload
  },
  {
    "urn": "137603",
    "providerName": "Ridgewood School",
    "providerStatus": {"code": "1", "name": "Open"}
    // ... the rest of the establishment payload
  }
  // ... further establishments
]
```

## Request headers

| Header | Required | Behaviour |
| --- | --- | --- |
| `Accept` | No | Negotiate `application/json` using media ranges and quality values. Absent: JSON acceptable. No acceptable success representation: `406`. |
| `Accept-Encoding` | No | Support `gzip` and identity using standard quality-value rules. No acceptable available coding: `406`. |
| `If-None-Match` | No | Entity-tag list or `*`. Apply standard weak comparison after validation and publication checks. |

## Response headers

| Header | Applies to | Value / rule |
| --- | --- | --- |
| `Content-Type` | 200 | application/json; UTF-8. |
| `Content-Type` | Errors | application/problem+json; UTF-8. |
| `API-Version` | Every response | Full deployed semantic API version; for example 1.0.0. |
| `API-Status` | Every response | `beta`. |
| `X-Request-ID` | Every response | Server-generated request UUID. |
| `Date` | Every response | HTTP response-generation date. |
| `Data-Last-Refreshed-At` | When a projection exists | Required when a public projection exists. Latest successful projection refresh, as RFC 3339 UTC with Z suffix; omit if none has ever loaded. |
| `ETag` | 200, 304 | Quoted SHA-256 of exact representation bytes after UTF-8 serialisation and content coding; Base64url without padding, no weak prefix. |
| `Cache-Control` | 200, 304 | public, no-cache |
| `Cache-Control` | Errors | no-store |
| `Vary` | 200, 304 | Accept, Accept-Encoding |
| `Content-Encoding` | Gzip 200 only | gzip; omit for identity and 304. |
| `Allow` | 405 | GET. |
| `Retry-After` | 429; 503 when known | Positive integer delay in seconds. |

Omit `Content-Type` and `Content-Encoding` on `304`. Do not emit `Last-Modified`. If no public projection has ever loaded, return `503 publication-unavailable` and omit `Data-Last-Refreshed-At`.

## Representation rules

- Detail responses return one UTF-8 JSON object. Collection responses return a UTF-8 JSON array of establishment objects. Neither response uses a wrapper or pagination metadata.
- Use lower camel case property names.
- Identifiers and published codes are strings. Counts are integers; percentages are numbers; truth values are booleans.
- Dates: `YYYY-MM-DD`. Timestamps: RFC 3339 UTC with a `Z` suffix. Preserve date-only precision.
- **Required:** present in every establishment object in a `200` response. Missing required publication facts: `503 publication-incomplete`.
- **Conditional:** present when applicable, known and published.
- Omit nulls, empty strings, empty objects, empty nested arrays and placeholder values. An empty collection response is `[]`.
- Preserve `0`, `false` and meaningful classifications such as `None` or `No sixth form`.
- Publish matching code/name pairs. Preserve code spelling and leading zeroes. Exclude internal surrogate identifiers.
- Clients must tolerate additional properties and future published code values.
- Published closed establishments return `200` with their published status and available facts.
- Apply optional-field rules per fact and detailed type. SEN and alternative-provision fields are not restricted solely by the category name.
- Return available published facts from one consistent public projection.
- No standalone current `providerNumber`, `laestab`, academy-route, vocabulary-concept or generic responsibility property.

## Payload fields

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `urn` | Required | `string` | Decimal string from 1 to 999999, without leading zeroes. In a detail response, must match the requested URN. |
| `providerName` | Required | `string` | Published establishment name. Non-empty. |
| `dfeNumber` | Conditional | `string` | Three-digit DfE LA number, a slash and four-digit establishment number; include only when both components and the numbering-authority relationship are established. |
| `ukprn` | Conditional | `string` | Eight-digit UK Provider Reference Number. |
| `providerType` | Required | `CodedValue` | Detailed establishment type. Code and name must match the published type mapping. |
| `providerTypeGroup` | Required | `CodedValue` | Published type-group code and matching category name; see classification mappings. |
| `educationPhase` | Conditional | `CodedValue` | — |
| `providerStatus` | Required | `CodedValue` | Published establishment status. Published closed establishments remain retrievable. A proposed closure date alone does not change status to Closed. |
| `openDate` | Conditional | `string (date)` | — |
| `closedDate` | Conditional | `string (date)` | — |
| `reasonProviderOpened` | Conditional | `CodedValue` | — |
| `reasonProviderClosed` | Conditional | `CodedValue` | — |
| `dateLastChangedOrConfirmed` | Required | `string (date)` | Source record date; distinct from response-generation and projection-refresh timestamps. |
| `establishmentLocationAndContact` | Conditional | `LocationAndContact` | — |
| `administrativeGeography` | Conditional | `AdministrativeGeography` | — |
| `establishmentLeadership` | Conditional | `Leadership` | — |
| `educationAdmissionsAndProvision` | Conditional | `EducationAdmissionsAndProvision` | — |
| `capacityAndPupilMeasures` | Conditional | `CapacityAndPupilMeasures` | — |
| `faithContext` | Conditional | `FaithContext` | — |
| `senAndResourcedProvision` | Conditional | `SenAndResourcedProvision` | — |
| `alternativeProvisionCharacteristics` | Conditional | `AlternativeProvisionCharacteristics` | — |
| `inspectionRecord` | Conditional | `InspectionRecord` | — |
| `academyTrust` | Conditional | `AcademyTrust` | Current operating trust; at most one. Academies category. |
| `sponsor` | Conditional | `Sponsor` | Current sponsor; at most one. Academies category. |
| `maintainingLocalAuthority` | Conditional | `MaintainingLocalAuthority` | Current maintenance relationship. Local authority maintained schools category. |
| `federation` | Conditional | `Federation` | Current federation membership; at most one. Local authority maintained schools category. |
| `foundationTrust` | Conditional | `FoundationTrust` | Current foundation-trust relationship; at most one. Local authority maintained schools category. |
| `history` | Conditional | `History` | — |

## Field structures

All conditional members follow the representation rules. Objects contain at least one meaningful member; arrays contain at least one item.

```json
{"educationPhase": {"code": "4", "name": "Secondary"}, "providerTypeGroup": {"code": "10", "name": "Academies"}}
```

### CodedValue

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `code` | Required | `string` | Published code; preserve spelling and leading zeroes. Internal database identifiers are excluded. Non-empty. |
| `name` | Required | `string` | Published name matching the code. Non-empty. |

### NamedValue

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `name` | Required | `string` | Published classification name. Non-empty. |

### LocalAuthorityValue

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `code` | Required | `string` | Three-digit published DfE local authority code. |
| `name` | Required | `string` | Published local authority lookup label. Non-empty. |

### Address

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `addressLine1` | Conditional | `string` | Non-empty. |
| `addressLine2` | Conditional | `string` | Non-empty. |
| `addressLine3` | Conditional | `string` | Non-empty. |
| `townOrCity` | Conditional | `string` | Non-empty. |
| `county` | Conditional | `string` | Non-empty. |
| `postcode` | Conditional | `string` | Non-empty. |
| `country` | Conditional | `string` | Non-empty. |

### OsGridReference

British National Grid, EPSG:27700. Publish only for the site to which the coordinates apply.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `easting` | Required | `integer` | — |
| `northing` | Required | `integer` | — |

### Site

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `siteId` | Required | `string (uuid)` | Stable published site UUID. |
| `isMainSite` | Required | `boolean` | At most one site per establishment has this value set to true. |
| `siteName` | Conditional | `string` | Non-empty. |
| `uniquePropertyReferenceNumber` | Conditional | `string` | Published UPRN as a non-empty decimal string. |
| `address` | Conditional | `Address` | — |
| `osGridReference` | Conditional | `OsGridReference` | — |

### LocationAndContact

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `website` | Conditional | `string` | Published website string; a scheme is not required. Non-empty. |
| `phoneNumber` | Conditional | `string` | Published telephone number; preserve meaningful formatting. Non-empty. |
| `sites` | Conditional | `Site[]` | Main site first; remaining sites ordered by siteId. Non-empty array. |

### AdministrativeGeography

Geographic classifications. localAuthorityArea identifies the DfE LA-code area.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `localAuthorityArea` | Conditional | `LocalAuthorityValue` | — |
| `governmentOfficeRegion` | Conditional | `CodedValue` | — |
| `districtAdministrative` | Conditional | `CodedValue` | — |
| `administrativeWard` | Conditional | `CodedValue` | — |
| `parliamentaryConstituency` | Conditional | `CodedValue` | — |
| `urbanRuralClassification` | Conditional | `CodedValue` | — |
| `lowerSuperOutputArea` | Conditional | `CodedValue` | — |
| `middleSuperOutputArea` | Conditional | `CodedValue` | — |
| `governmentStatisticalServiceLocalAuthorityCode` | Conditional | `string` | Published GSS local authority code. Non-empty. |

### HeadteacherOrPrincipal

Include at least one meaningful published member.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `headTitle` | Conditional | `string` | Non-empty. |
| `headFirstName` | Conditional | `string` | Non-empty. |
| `headLastName` | Conditional | `string` | Non-empty. |
| `jobTitle` | Conditional | `string` | Non-empty. |

### Leadership

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `headteacherOrPrincipal` | Conditional | `HeadteacherOrPrincipal` | — |

### StatutoryAgeRange

statutoryLowAge must be less than or equal to statutoryHighAge.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `statutoryLowAge` | Required | `integer` | Minimum: 0. Maximum: 19. |
| `statutoryHighAge` | Required | `integer` | Minimum: 0. Maximum: 25. |

### EducationAdmissionsAndProvision

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `statutoryAgeRange` | Conditional | `StatutoryAgeRange` | — |
| `genderOfEntry` | Conditional | `CodedValue` | — |
| `admissionsPolicy` | Conditional | `CodedValue` | — |
| `boardingProvision` | Conditional | `CodedValue` | — |
| `nurseryProvision` | Conditional | `NamedValue` | — |
| `sixthFormProvision` | Conditional | `CodedValue` | — |
| `specialClassProvision` | Conditional | `boolean` | — |
| `section41Approval` | Conditional | `NamedValue` | Include only when applicable and published. |

### CapacityAndPupilMeasures

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `providerCapacity` | Conditional | `integer` | Minimum: 0. |
| `numberOfPupilsStudents` | Conditional | `integer` | Minimum: 0. |
| `censusDate` | Conditional | `string (date)` | — |
| `pupilsEligibleForFreeSchoolMeals` | Conditional | `integer` | Minimum: 0. |
| `percentagePupilsEligibleForFreeSchoolMeals` | Conditional | `number` | Published percentage; retain the supplied value. No common denominator with other counts is implied. Minimum: 0. Maximum: 100. |
| `numberOfMales` | Conditional | `integer` | Pupil-population count. Minimum: 0. |
| `numberOfFemales` | Conditional | `integer` | Pupil-population count. Minimum: 0. |

### FaithContext

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `religiousCharacter` | Conditional | `CodedValue` | — |
| `religiousEthos` | Conditional | `NamedValue` | — |
| `diocese` | Conditional | `CodedValue` | — |

### ResourcedProvisionMeasure

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `resourcedProvisionPupilCount` | Conditional | `integer` | Minimum: 0. |
| `resourcedProvisionCapacity` | Conditional | `integer` | Minimum: 0. |

### SenUnitMeasure

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `senUnitPupilCount` | Conditional | `integer` | Minimum: 0. |
| `senUnitCapacity` | Conditional | `integer` | Minimum: 0. |

### SenAndResourcedProvision

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `typeOfSenProvision` | Conditional | `NamedValue[]` | Unique published SEN-need names, sorted by name using ordinal comparison. Non-empty array. Unique items. |
| `typeOfResourcedProvision` | Conditional | `NamedValue` | — |
| `resourcedProvisionMeasure` | Conditional | `ResourcedProvisionMeasure` | — |
| `senUnitMeasure` | Conditional | `SenUnitMeasure` | — |

### AlternativeProvisionCharacteristics

Include applicable published facts; these fields are not restricted to the pupil referral unit type.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `teenMothersProvision` | Conditional | `boolean` | — |
| `childcareFacilitiesProvision` | Conditional | `boolean` | — |
| `senPupilReferralUnit` | Conditional | `boolean` | — |
| `emotionalBehaviouralDifficultiesProvision` | Conditional | `boolean` | — |
| `fullTimeProvision` | Conditional | `boolean` | — |
| `pupilsEducatedByOtherProviders` | Conditional | `boolean` | — |
| `teenMothersCapacity` | Conditional | `integer` | Minimum: 0. |
| `pupilReferralUnitCapacity` | Conditional | `integer` | Minimum: 0. |

### InspectionRecord

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `inspectorateName` | Conditional | `NamedValue` | — |
| `inspectorateReport` | Conditional | `string (uri)` | Published inspection-report URI. Non-empty. |
| `dateOfLastInspectionVisit` | Conditional | `string (date)` | — |
| `dateOfNextInspectionVisit` | Conditional | `string (date)` | — |

### AcademyTrust

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `name` | Required | `string` | Published party or group name. Non-empty. |
| `groupUid` | Conditional | `string` | Published Group UID for this role as a non-empty decimal string. |
| `groupId` | Conditional | `string` | Published Group ID; preserve prefix and leading zeroes. Non-empty. |
| `companiesHouseNumber` | Conditional | `string` | Published Companies House number; preserve leading zeroes. Non-empty. |
| `academyTrustType` | Required | `NamedValue` | Single-academy trust, Multi-academy trust or Secure single-academy trust. Historical entries retain the type recorded for that relationship. |
| `startDate` | Conditional | `string (date)` | Relationship start, inclusive. |
| `endDate` | Conditional | `string (date)` | Relationship end, exclusive; may be future-dated for a current relationship. |

### Sponsor

A sponsor may be an organisation or an individual. academyTrustType is absent. personId and companiesHouseNumber must not be published together.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `name` | Required | `string` | Published party or group name. Non-empty. |
| `groupUid` | Conditional | `string` | Published Group UID for this role as a non-empty decimal string. |
| `groupId` | Conditional | `string` | Published Group ID; preserve prefix and leading zeroes. Non-empty. |
| `companiesHouseNumber` | Conditional | `string` | Organisations only; published company number. Non-empty. |
| `personId` | Conditional | `string (uuid)` | Individual sponsors only; stable published person UUID. |
| `startDate` | Conditional | `string (date)` | Relationship start, inclusive. |
| `endDate` | Conditional | `string (date)` | Relationship end, exclusive; may be future-dated for a current relationship. |

### MaintainingLocalAuthority

The council maintaining the school; distinct from administrativeGeography.localAuthorityArea.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `code` | Conditional | `string` | Three-digit published DfE LA code evidenced for this relationship and period. |
| `name` | Required | `string` | Published council legal-entity name. Non-empty. |
| `startDate` | Conditional | `string (date)` | Relationship start, inclusive. |
| `endDate` | Conditional | `string (date)` | Relationship end, exclusive; may be future-dated for a current relationship. |

### Federation

Dates describe membership of the federation.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `name` | Required | `string` | Published party or group name. Non-empty. |
| `groupUid` | Conditional | `string` | Published Group UID for this role as a non-empty decimal string. |
| `groupId` | Conditional | `string` | Published Group ID; preserve prefix and leading zeroes. Non-empty. |
| `startDate` | Conditional | `string (date)` | Relationship start, inclusive. |
| `endDate` | Conditional | `string (date)` | Relationship end, exclusive; may be future-dated for a current relationship. |

### FoundationTrust

Published foundation-trust support relationship.

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `name` | Required | `string` | Published party or group name. Non-empty. |
| `groupUid` | Conditional | `string` | Published Group UID for this role as a non-empty decimal string. |
| `groupId` | Conditional | `string` | Published Group ID; preserve prefix and leading zeroes. Non-empty. |
| `companiesHouseNumber` | Conditional | `string` | Published company number. Non-empty. |
| `startDate` | Conditional | `string (date)` | Relationship start, inclusive. |
| `endDate` | Conditional | `string (date)` | Relationship end, exclusive; may be future-dated for a current relationship. |

### Predecessor

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `urn` | Required | `string` | Predecessor establishment URN as a decimal string from 1 to 999999, without leading zeroes. |
| `providerName` | Required | `string` | Published predecessor name. Non-empty. |
| `dateLinked` | Conditional | `string (date)` | Recorded establishment-link date. |
| `url` | Required | `string` | Root-relative resource URL: `/v1/establishments/{URN}`. Its URN must match this item's urn. |

### History

| Property | Presence | Type | Constraint |
| --- | --- | --- | --- |
| `previousLA` | Conditional | `LocalAuthorityValue` | Previous published DfE local authority reference; omit placeholder code 999. This is not a dated maintenance relationship. |
| `predecessors` | Conditional | `Predecessor[]` | Direct links only. De-duplicate identical URN/date pairs; sort by URN numerically, then dateLinked ascending, unknown dates last. Non-empty array. |
| `previousAcademyTrusts` | Conditional | `AcademyTrust[]` | Sort by startDate ascending, unknown dates last, then name using ordinal comparison, then groupUid and groupId. Historical operators. Non-empty array. |
| `previousSponsors` | Conditional | `Sponsor[]` | Sort by startDate ascending, unknown dates last, then name using ordinal comparison, then groupUid and groupId. Historical sponsors. Non-empty array. |
| `previousMaintainingLocalAuthorities` | Conditional | `MaintainingLocalAuthority[]` | Sort by startDate ascending, unknown dates last, then name using ordinal comparison. Historical maintenance relationships. Non-empty array. |
| `previousFederations` | Conditional | `Federation[]` | Sort by startDate ascending, unknown dates last, then name using ordinal comparison. Historical federation memberships. Non-empty array. |
| `previousFoundationTrusts` | Conditional | `FoundationTrust[]` | Sort by startDate ascending, unknown dates last, then name using ordinal comparison. Historical foundation-trust relationships. Non-empty array. |

## Classification mappings

### Academies

`providerTypeGroup` = `{"code": "10", "name": "Academies"}`.

| `providerType.code` | `providerType.name` |
| --- | --- |
| `34` | Academy converter |
| `28` | Academy sponsor led |
| `44` | Academy special converter |
| `33` | Academy special sponsor led |
| `42` | Academy alternative provision converter |
| `43` | Academy alternative provision sponsor led |
| `45` | Academy 16-19 converter |
| `46` | Academy 16 to 19 sponsor led |
| `57` | Academy secure 16 to 19 |

### Local authority maintained schools

`providerTypeGroup` = `{"code": "4", "name": "Local authority maintained schools"}`.

| `providerType.code` | `providerType.name` |
| --- | --- |
| `01` | Community school |
| `02` | Voluntary aided school |
| `03` | Voluntary controlled school |
| `05` | Foundation school |
| `14` | Pupil referral unit |
| `15` | Maintained nursery school |

Types `07` and `12` use the `Special schools` category. Free schools, university technical colleges and studio schools use `Free Schools`. Other published categories use this endpoint; an undescribed category is not grounds for `404`.

## Relationship rules

| Category | Current properties | Historical properties within `history` |
| --- | --- | --- |
| Academies | `academyTrust`, `sponsor` | `previousAcademyTrusts`, `previousSponsors` |
| Local authority maintained schools | `maintainingLocalAuthority`, `federation`, `foundationTrust` | `previousMaintainingLocalAuthorities`, `previousFederations`, `previousFoundationTrusts` |

- An establishment has at most one current `sponsor`, one current `federation` and one current `foundationTrust`. Omit absent relationships. Historical relationships remain arrays.
- Select current and historical relationships using explicit current state. An absent end date does not establish current state.
- Relationship periods use inclusive starts and exclusive ends. Omit unknown dates. A current relationship may have a known future end date.
- Current and historical entries use the same item structures. Historical trusts retain the recorded trust type and period-specific identifiers.
- Use identifiers for the relevant party role. Preserve identity across trust-type changes unless a distinct party is established.
- De-duplicate identical party/relationship-period records without merging distinct parties. Names alone do not establish identity.
- Do not infer sponsors from provider type or operating trust, or foundation-trust support from religious character or diocese.
- `academyTrust` has at most one current operator. `academyTrustType` is absent from sponsor objects.
- `personId` applies to individual sponsors; `companiesHouseNumber` applies to organisations. Do not publish both on one sponsor.
- `maintainingLocalAuthority` identifies the maintaining council. `administrativeGeography.localAuthorityArea` identifies the geographic LA-code area.
- `history.previousLA` is a previous LA reference; it does not establish a predecessor or a dated maintenance relationship.
- Predecessor `url` values start with a single `/`, contain no scheme or hostname, and use the same URN as their item. Do not recursively expand predecessors.

## Conditional retrieval

1. Validate the request and resolve publication eligibility.
2. Select the negotiated representation and content coding.
3. Serialise deterministically to UTF-8 JSON; use deterministic gzip output when selected.
4. Calculate SHA-256 over the exact representation bytes after content coding. Exclude HTTP transfer framing.
5. Encode the 32 digest bytes directly as Base64url without padding. Enclose the 43-character value in double quotes; no `W/` prefix.
6. Evaluate `If-None-Match` using standard weak comparison and wildcard handling.
7. Match: `304` with no body. Otherwise: `200` with the selected representation.

ETags cover joined public facts. Gzip and identity have different tags. Header changes and refresh-only changes do not change the tag when body bytes are unchanged. An unpublished detail record returns `404` even if a supplied tag previously matched. Collection ETags cover all selected records in numeric URN order, including the empty array. Evaluate conditions after validating the filter and resolving publication eligibility.

```http
GET /v1/establishments/137603 HTTP/1.1
Accept: application/json
If-None-Match: "dQq3Uqlgg_LtDYp4JkAV6D2wxEKpqeaSoOBIo8H9sNQ"
```

```http
HTTP/1.1 304 Not Modified
API-Version: 1.0.0
API-Status: beta
X-Request-ID: 3210b66e-4af3-4f7d-a2d0-a5f1c83bbbf5
Date: Wed, 11 Nov 2026 09:00:00 GMT
Data-Last-Refreshed-At: 2026-11-11T08:00:00Z
ETag: "dQq3Uqlgg_LtDYp4JkAV6D2wxEKpqeaSoOBIo8H9sNQ"
Cache-Control: public, no-cache
Vary: Accept, Accept-Encoding
```

## Status codes

| HTTP status | Error code | Response |
| --- | --- | --- |
| 200 OK | — | Detail: `Establishment`. Collection: `Establishment[]`, including `[]` when no records match. Content type: `application/json`. |
| 304 Not Modified | — | No body. |
| 400 Bad Request | `invalid-urn`, `invalid-status-filter`, `unsupported-query-parameter`, `unexpected-request-body` | Invalid matched URN, invalid collection filter, unsupported collection query parameter or non-empty request body. Validation errors include `errors`; filter errors use location `query`. |
| 404 Not Found | `establishment-not-found` | Detail: no published record for a valid URN. Unknown and unpublished records are indistinguishable. Unmatched paths, including a trailing slash, also return 404. A collection with no matches returns `200` and `[]`. |
| 405 Method Not Allowed | `method-not-allowed` | Unsupported method. Allow: GET is required. |
| 406 Not Acceptable | `not-acceptable` | No acceptable success media type or available content coding. Return application/problem+json for this error. |
| 429 Too Many Requests | `rate-limit-exceeded` | Anonymous traffic throttled. Retry-After is required; no numeric threshold is specified. |
| 500 Internal Server Error | `internal-error` | Unexpected failure. Exclude SQL, stack traces and unpublished data. |
| 503 Service Unavailable | `publication-unavailable`, `publication-incomplete` | Public projection unavailable or required publication facts missing. Include Retry-After only when known. If no public projection has ever loaded, omit Data-Last-Refreshed-At. |

## Error payload

Format: [RFC 9457 — Problem Details for HTTP APIs](https://www.rfc-editor.org/rfc/rfc9457.html).

Content type: `application/problem+json`. Required members: `type`, `title`, `status`, `detail`, `instance`, `code`, `requestId`.

| Member | Type | Constraint |
| --- | --- | --- |
| `type` | `string` | Values: `about:blank`. |
| `title` | `string` | Standard HTTP status phrase. Non-empty. |
| `status` | `integer` | Must equal the HTTP response status. Minimum: 400. Maximum: 599. |
| `detail` | `string` | Human-readable detail; exclude internal diagnostics and unpublished data. Non-empty. |
| `instance` | `string (uri)` | Unique occurrence identifier: `urn:uuid:` followed by a UUID. |
| `code` | `string` | Stable API error code; see each response. Non-empty. |
| `requestId` | `string (uuid)` | UUID matching X-Request-ID. |
| `errors` | `ValidationError[]` | Required for validation failures; omitted for other errors. Non-empty array. |

`errors` is present for validation failures and absent for other errors.

| `errors[]` member | Required | Type / value |
| --- | --- | --- |
| `location` | Yes | String: `path`, `query` or `body`. |
| `name` | Yes | Non-empty component name; `body` for a request-body failure. |
| `reason` | Yes | Non-empty validation message. |

```http
HTTP/1.1 400 Bad Request
Content-Type: application/problem+json
API-Version: 1.0.0
API-Status: beta
X-Request-ID: ab71e49d-8d40-47d4-825c-0809c9737dab
Date: Wed, 11 Nov 2026 09:00:00 GMT
Data-Last-Refreshed-At: 2026-11-11T08:00:00Z
Cache-Control: no-store
```

```json
{
  "type": "about:blank",
  "title": "Bad Request",
  "status": 400,
  "detail": "URN must contain 1 to 6 digits, start with a non-zero digit and be between 1 and 999999.",
  "instance": "urn:uuid:ab71e49d-8d40-47d4-825c-0809c9737dab",
  "code": "invalid-urn",
  "requestId": "ab71e49d-8d40-47d4-825c-0809c9737dab",
  "errors": [{"location": "path", "name": "URN", "reason": "Expected a decimal URN without leading zeroes."}]
}
```

## Payload examples

Illustrative payloads; not live responses.

### Academy

#### Ridgewood School  URN 137603

```http
GET /v1/establishments/137603 HTTP/1.1
Accept: application/json
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
API-Version: 1.0.0
API-Status: beta
X-Request-ID: 3210b66e-4af3-4f7d-a2d0-a5f1c83bbbf5
Date: Wed, 11 Nov 2026 09:00:00 GMT
Data-Last-Refreshed-At: 2026-11-11T08:00:00Z
ETag: "dQq3Uqlgg_LtDYp4JkAV6D2wxEKpqeaSoOBIo8H9sNQ"
Cache-Control: public, no-cache
Vary: Accept, Accept-Encoding
```

```json
{
  "urn": "137603",
  "providerName": "Ridgewood School",
  "dfeNumber": "371/4033",
  "ukprn": "10035482",
  "providerType": {"code": "34", "name": "Academy converter"},
  "providerTypeGroup": {"code": "10", "name": "Academies"},
  "educationPhase": {"code": "4", "name": "Secondary"},
  "providerStatus": {"code": "1", "name": "Open"},
  "openDate": "2011-11-01",
  "reasonProviderOpened": {"code": "10", "name": "Academy Converter"},
  "dateLastChangedOrConfirmed": "2026-05-14",
  "establishmentLocationAndContact": {
    "website": "http://www.ridgewoodschool.co.uk",
    "phoneNumber": "01302783939",
    "sites": [
      {
        "siteId": "4615ea27-a8fc-4405-b35c-5e1c14923de4",
        "isMainSite": true,
        "uniquePropertyReferenceNumber": "10006581609",
        "address": {
          "addressLine1": "Barnsley Road",
          "addressLine2": "Scawsby",
          "townOrCity": "Doncaster",
          "county": "South Yorkshire",
          "postcode": "DN5 7UB"
        },
        "osGridReference": {"easting": 454286, "northing": 404965}
      }
    ]
  },
  "administrativeGeography": {
    "localAuthorityArea": {"code": "371", "name": "Doncaster"},
    "governmentOfficeRegion": {"code": "D", "name": "Yorkshire and the Humber"},
    "districtAdministrative": {"code": "E08000017", "name": "Doncaster"},
    "administrativeWard": {"code": "E05010741", "name": "Roman Ridge"},
    "parliamentaryConstituency": {"code": "E14001200", "name": "Doncaster North"},
    "urbanRuralClassification": {"code": "UN1", "name": "Urban: Nearer to a major town or city"},
    "lowerSuperOutputArea": {"code": "E01007588", "name": "Doncaster 016C"},
    "middleSuperOutputArea": {"code": "E02001554", "name": "Doncaster 016"},
    "governmentStatisticalServiceLocalAuthorityCode": "E08000017"
  },
  "establishmentLeadership": {
    "headteacherOrPrincipal": {"headTitle": "Mr", "headFirstName": "Andrew", "headLastName": "Peirson", "jobTitle": "Headteacher"}
  },
  "educationAdmissionsAndProvision": {
    "statutoryAgeRange": {"statutoryLowAge": 11, "statutoryHighAge": 19},
    "genderOfEntry": {"code": "3", "name": "Mixed"},
    "admissionsPolicy": {"code": "4", "name": "Non-selective"},
    "boardingProvision": {"code": "1", "name": "No boarders"},
    "sixthFormProvision": {"code": "1", "name": "Has a sixth form"},
    "specialClassProvision": true
  },
  "capacityAndPupilMeasures": {
    "providerCapacity": 1512,
    "numberOfPupilsStudents": 1453,
    "censusDate": "2025-01-16",
    "pupilsEligibleForFreeSchoolMeals": 249,
    "percentagePupilsEligibleForFreeSchoolMeals": 21,
    "numberOfMales": 674,
    "numberOfFemales": 779
  },
  "academyTrust": {
    "name": "LEGER EDUCATION TRUST",
    "groupUid": "17144",
    "groupId": "TR00381",
    "companiesHouseNumber": "07736364",
    "academyTrustType": {"name": "Multi-academy trust"},
    "startDate": "2023-07-01"
  },
  "sponsor": {"name": "Leger Education Trust", "groupUid": "17252", "groupId": "SP01981", "startDate": "2023-07-01"},
  "history": {
    "predecessors": [
      {
        "urn": "106789",
        "providerName": "Ridgewood School",
        "dateLinked": "2011-11-01",
        "url": "/v1/establishments/106789"
      }
    ]
  }
}
```

#### Westlands School URN 136286

The example `siteId` is illustrative.

```http
GET /v1/establishments/136286 HTTP/1.1
Accept: application/json
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
API-Version: 1.0.0
API-Status: beta
X-Request-ID: ed0d4e4a-ac02-5e3c-acbe-5366cd8b0fab
Date: Wed, 11 Nov 2026 09:00:00 GMT
Data-Last-Refreshed-At: 2026-11-11T08:00:00Z
ETag: "DsG5VSOhiiAGjDKs5iG6spwURWZYrApk4fFf69OuVKs"
Cache-Control: public, no-cache
Vary: Accept, Accept-Encoding
```

```json
{
  "urn": "136286",
  "providerName": "Westlands School",
  "dfeNumber": "886/5434",
  "ukprn": "10031371",
  "providerType": {"code": "34", "name": "Academy converter"},
  "providerTypeGroup": {"code": "10", "name": "Academies"},
  "educationPhase": {"code": "4", "name": "Secondary"},
  "providerStatus": {"code": "1", "name": "Open"},
  "openDate": "2010-09-01",
  "reasonProviderOpened": {"code": "10", "name": "Academy Converter"},
  "dateLastChangedOrConfirmed": "2026-05-19",
  "establishmentLocationAndContact": {
    "website": "http://www.westlands.org.uk/",
    "phoneNumber": "01795477475",
    "sites": [
      {
        "siteId": "ea3d3b2c-1e0a-545c-b87f-55708d9c56d6",
        "isMainSite": true,
        "uniquePropertyReferenceNumber": "100062375039",
        "address": {
          "addressLine1": "Westlands Avenue",
          "townOrCity": "Sittingbourne",
          "county": "Kent",
          "postcode": "ME10 1PF"
        },
        "osGridReference": {"easting": 588904, "northing": 163864}
      }
    ]
  },
  "administrativeGeography": {
    "localAuthorityArea": {"code": "886", "name": "Kent"},
    "governmentOfficeRegion": {"code": "J", "name": "South East"},
    "districtAdministrative": {"code": "E07000113", "name": "Swale"},
    "administrativeWard": {"code": "E05009546", "name": "Borden and Grove Park"},
    "parliamentaryConstituency": {"code": "E14001474", "name": "Sittingbourne and Sheppey"},
    "urbanRuralClassification": {"code": "UN1", "name": "Urban: Nearer to a major town or city"},
    "lowerSuperOutputArea": {"code": "E01024569", "name": "Swale 012C"},
    "middleSuperOutputArea": {"code": "E02005126", "name": "Swale 012"},
    "governmentStatisticalServiceLocalAuthorityCode": "E10000016"
  },
  "establishmentLeadership": {
    "headteacherOrPrincipal": {"headTitle": "Miss", "headFirstName": "Christina", "headLastName": "Honess", "jobTitle": "Headteacher"}
  },
  "educationAdmissionsAndProvision": {
    "statutoryAgeRange": {"statutoryLowAge": 11, "statutoryHighAge": 18},
    "genderOfEntry": {"code": "3", "name": "Mixed"},
    "admissionsPolicy": {"code": "4", "name": "Non-selective"},
    "boardingProvision": {"code": "1", "name": "No boarders"},
    "sixthFormProvision": {"code": "1", "name": "Has a sixth form"},
    "specialClassProvision": true
  },
  "capacityAndPupilMeasures": {
    "providerCapacity": 1604,
    "numberOfPupilsStudents": 1746,
    "censusDate": "2025-01-16",
    "pupilsEligibleForFreeSchoolMeals": 434,
    "percentagePupilsEligibleForFreeSchoolMeals": 28.2,
    "numberOfMales": 911,
    "numberOfFemales": 835
  },
  "faithContext": {"religiousCharacter": {"code": "06", "name": "None"}},
  "senAndResourcedProvision": {
    "typeOfSenProvision": [{"name": "PD - Physical Disability"}, {"name": "SpLD - Specific Learning Difficulty"}],
    "typeOfResourcedProvision": {"name": "Resourced provision and SEN unit"},
    "resourcedProvisionMeasure": {"resourcedProvisionPupilCount": 10, "resourcedProvisionCapacity": 10},
    "senUnitMeasure": {"senUnitPupilCount": 28, "senUnitCapacity": 32}
  },
  "academyTrust": {
    "name": "SWALE ACADEMIES TRUST",
    "groupUid": "4885",
    "groupId": "TR02230",
    "companiesHouseNumber": "07344732",
    "academyTrustType": {"name": "Multi-academy trust"},
    "startDate": "2010-09-01"
  },
  "sponsor": {"name": "Swale Academies Trust", "groupUid": "4886", "groupId": "SP00571", "startDate": "2010-10-01"},
  "history": {"previousLA": {"code": "922", "name": "Pre LGR (1998) Kent"}}
}
```

### Local authority maintained school

```http
GET /v1/establishments/109613 HTTP/1.1
Accept: application/json
```

```http
HTTP/1.1 200 OK
Content-Type: application/json
API-Version: 1.0.0
API-Status: beta
X-Request-ID: bfae629b-0a60-4b45-87ac-c0525fdc578a
Date: Wed, 11 Nov 2026 09:00:00 GMT
Data-Last-Refreshed-At: 2026-11-11T08:00:00Z
ETag: "-EiHrZZFQqGvpfYmm0dFCXevocRK0Jtqzs8iBcZBOyA"
Cache-Control: public, no-cache
Vary: Accept, Accept-Encoding
```

```json
{
  "urn": "109613",
  "providerName": "Milton Ernest CofE Primary School",
  "dfeNumber": "822/3023",
  "ukprn": "10075753",
  "providerType": {"code": "03", "name": "Voluntary controlled school"},
  "providerTypeGroup": {"code": "4", "name": "Local authority maintained schools"},
  "educationPhase": {"code": "2", "name": "Primary"},
  "providerStatus": {"code": "1", "name": "Open"},
  "dateLastChangedOrConfirmed": "2026-06-03",
  "establishmentLocationAndContact": {
    "website": "www.ewmeschools.org.uk",
    "phoneNumber": "01234822079",
    "sites": [
      {
        "siteId": "3ce35ac4-8250-4546-9bd2-ef33a5a39726",
        "isMainSite": true,
        "uniquePropertyReferenceNumber": "100081212588",
        "address": {
          "addressLine1": "Thurleigh Road",
          "addressLine2": "Milton Ernest",
          "townOrCity": "Bedford",
          "county": "Bedfordshire",
          "postcode": "MK44 1RF"
        },
        "osGridReference": {"easting": 501906, "northing": 256038}
      }
    ]
  },
  "administrativeGeography": {
    "localAuthorityArea": {"code": "822", "name": "Bedford"},
    "governmentOfficeRegion": {"code": "G", "name": "East of England"},
    "districtAdministrative": {"code": "E06000055", "name": "Bedford"},
    "administrativeWard": {"code": "E05014512", "name": "Riseley"},
    "parliamentaryConstituency": {"code": "E14001384", "name": "North Bedfordshire"},
    "urbanRuralClassification": {"code": "RSN1", "name": "Smaller rural: Nearer to a major town or city"},
    "lowerSuperOutputArea": {"code": "E01017478", "name": "Bedford 003A"},
    "middleSuperOutputArea": {"code": "E02003618", "name": "Bedford 003"},
    "governmentStatisticalServiceLocalAuthorityCode": "E06000055"
  },
  "establishmentLeadership": {
    "headteacherOrPrincipal": {"headTitle": "Mrs", "headFirstName": "Lisa", "headLastName": "Virnuls", "jobTitle": "Headteacher"}
  },
  "educationAdmissionsAndProvision": {
    "statutoryAgeRange": {"statutoryLowAge": 4, "statutoryHighAge": 11},
    "genderOfEntry": {"code": "3", "name": "Mixed"},
    "boardingProvision": {"code": "1", "name": "No boarders"},
    "nurseryProvision": {"name": "No Nursery Classes"},
    "sixthFormProvision": {"code": "2", "name": "Does not have a sixth form"},
    "specialClassProvision": false
  },
  "capacityAndPupilMeasures": {
    "providerCapacity": 84,
    "numberOfPupilsStudents": 63,
    "censusDate": "2025-01-16",
    "pupilsEligibleForFreeSchoolMeals": 6,
    "percentagePupilsEligibleForFreeSchoolMeals": 9.5,
    "numberOfMales": 35,
    "numberOfFemales": 28
  },
  "faithContext": {
    "religiousCharacter": {"code": "02", "name": "Church of England"},
    "diocese": {"code": "CE32", "name": "Diocese of St Albans"}
  },
  "maintainingLocalAuthority": {"code": "822", "name": "Bedford Borough Council", "startDate": "2009-04-01"},
  "federation": {
    "name": "Federation of Eileen Wade and Milton Ernest CoE Primary Schools",
    "groupUid": "1809",
    "startDate": "2011-01-13"
  },
  "history": {"previousLA": {"code": "820", "name": "Pre LGR (2009) Bedfordshire"}}
}
```

Example ETags identify the displayed uncompressed JSON as UTF-8 without a byte-order mark, with LF line endings and no final newline.
