# Independent review: establishment groups logical model

Reviewed: 25 September 2026.
Status: review findings with remediation status, not approved model changes.
Scope: [BAU group types white paper](bau-group-types-white-paper.md) and [logical-model recommendation](establishment-groups-logical-model-recommendation.md).
The original review did not edit the two source documents. Subsequent changes made in response to findings are recorded against the relevant finding.

The proposed separation of legal entities, responsibilities and organisation groups is a useful basis for the next modelling iteration. However, the migration rules do not yet consistently implement that separation. The most consequential issues concern identity resolution, preserving identifiers for all target kinds, and handling records that violate mandatory rules.

## Methodology

This review reassessed the current files against their own examples, the local group and link CSV extracts, the referenced BAU ERD, EDM transcriptions, governance logical model, and the ontology and SHACL files at the paths cited by the recommendation. The earlier conversational review was visible, so this is an independent reassessment of the evidence, not a blind second review.

Checks included:

- Reading both documents and tracing their definitions, cardinalities, dates, examples, migration mappings and decisions against one another.
- Parsing the 30 June 2026 group and link CSVs with PowerShell. Confirmed 7,172 groups, 24,369 links, per-type group counts and Companies House-number coverage, and inspected specific identity and membership examples.
- Checking all relative file destinations in both documents. Seven broken link occurrences remain in the recommendation; the white paper's relative file destinations resolve.
- Inspecting the referenced ontology and SHACL declarations and relevant governance interfaces.
- Retrieving selected primary public guidance, including DfE's September 2026 independent-school registration guidance and the Charity Commission's withdrawn umbrella-trust guidance.

Limitations: this was not a full reproduction of every statistic or a complete legal audit. The two establishment and group extracts have different snapshot dates. The 12 Companies House sample matches were not independently re-established. Some legislation pages could not be retrieved because of rate limiting or unsupported responses; those failures are not treated as evidence that a link is broken. External URLs and heading anchors were not exhaustively validated. No live production database, missing archived relationships, or complete migration was tested.

Locations below refer to the reviewed files' line numbers. R means the recommendation; W means the white paper. Links lead to the relevant section; exact lines identify the passages.

Severity: **High** means a rule could produce incorrect identities, lose required information, or prevent a stated use case. **Medium** means an ambiguity or unsupported claim needs resolution before implementation. **Low** means an evidence-navigation or editorial defect. No critical finding was identified.

## High-severity findings

### H1. The automatic sponsor identity rule accepts empty evidence

**Status: addressed in the recommendation on 25 September 2026.** The document now treats membership equality as corroborating evidence, excludes empty sets from automatic merging, requires one unambiguous candidate with no identifier conflict, records decision provenance in the migration crosswalk, and adds T32 for the Adelaide empty-set case.

**Location:** R line 350, [recommendation and reasons](establishment-groups-logical-model-recommendation.md#recommendation-and-reasons); R lines 774 and 785, [mapping and identity-resolution rules](establishment-groups-logical-model-recommendation.md#mapping).

The recommendation treats a matching normalised name plus identical linked establishments as deterministic evidence for automatic merger. It does not exclude empty membership sets or require one unambiguous candidate.

The extract contains sponsor UID 2077, The Adelaide Academy Trust, and SAT UID 2076, THE ADELAIDE ACADEMY TRUST. Both have zero links and no Companies House number. They satisfy the stated automatic rule, but equality of two empty sets adds no identity evidence. This case effectively becomes a name-only merge, which M2 explicitly prohibits. This does not establish that these particular records are different entities; it establishes that the proposed proof is insufficient.

**Consequence:** records can be collapsed without the evidence that the document says is mandatory.

**Recommendation:** specify an identity-resolution decision table, including candidate uniqueness, identifier conflicts, empty sets, and provenance. Route empty-set matches to review. Treat non-empty membership equality as corroboration rather than a universal proof of legal identity.

### H2. The sponsor mapping creates duplicates for examples that the paper says must merge

**Status: addressed in the recommendation on 25 September 2026.** The type-05 mapping now leaves unresolved identities in review rather than creating parties by default. The ordered identity rules give authoritative identifiers, verified former names and documented reviewer decisions precedence. The Co-operative Academies Trust partial-set case is explicitly a reviewed merge, while the Trust in Learning former-name evidence resolves automatically. T1 and T11 therefore produce one legal entity without weakening the conflict and ambiguity safeguards added for H1.

**Location:** R line 774, [BAU to target](establishment-groups-logical-model-recommendation.md#bau-to-target); R lines 161, 194 and 221, [test cases](establishment-groups-logical-model-recommendation.md#test-cases); R lines 787–805, [identity-resolution and migration rules](establishment-groups-logical-model-recommendation.md#identity-resolution-rules).

The mapping says a same-named sponsor with exactly matching establishments resolves to the trust; otherwise it becomes a new legal entity or person.

That fallback fails two supplied acceptance cases:

- Co-operative Academies Trust: the trust UID 2777 has 38 links, while sponsor UID 4949 has 37. The mapping's equality test fails, although T1 explicitly requires one legal entity.
- Trust in Learning (Academies), UID 5121, and AMPLIFY EDUCATION, UID 5122: both have 21 links but different names. T11 requires one identity after checking former names.

These link counts were confirmed in the CSVs. The narrative review queue in the costs section does not override the unconditional fallback in the mapping table.

**Consequence:** implementing the mapping literally recreates the duplication that Option 4 is intended to remove.

**Recommendation:** change the fallback to unresolved identity and review, with new-entity creation only after resolution. State the precedence of M2, former-name evidence and manual decisions over the simplified mapping.

### H3. Legacy identifiers cannot be preserved for every supported target

**Location:** R lines 562–579, [organisation identifier](establishment-groups-logical-model-recommendation.md#organisation-identifier); R lines 643–650, [organisation group](establishment-groups-logical-model-recommendation.md#organisation-group); R line 682, [derived views](establishment-groups-logical-model-recommendation.md#derived-views). W line 323, [federation](bau-group-types-white-paper.md#federation-01).

The compatibility view promises resolution through any current or legacy GIAS Group UID or Group ID. However:

- Organisation identifiers require a legal-entity owner. Individual sponsors have a person target and no place for their source UID and SP ID. The extract includes Jack Petchey, UID 3549/SP00285, and Sir John Madejski, UID 4535/SP00288.
- Organisation groups retain only a UID. The extract has ten federations with populated Group IDs, which W explicitly reports.
- Uniqueness of legacy identifier values is not generally specified: line 570 restricts uniqueness to current values, while rule 13 separately covers UIDs but not legacy Group IDs.

**Consequence:** the promised compatibility view cannot be produced completely from the proposed entities, and some redirects can be missing or ambiguous.

**Recommendation:** define the migration crosswalk as a durable, queryable part of the solution, with source record UID, original type and identifiers, target kind and key, resolution status, and collision rules. Alternatively extend identifier ownership explicitly to persons and groups. Preserve source record identity separately from resolved legal identity.

### H4. Unresolved migration records are required both to pass and to violate hard constraints

**Location:** R lines 188 and 209, [edge cases](establishment-groups-logical-model-recommendation.md#edge-cases); R line 700, [integrity rules](establishment-groups-logical-model-recommendation.md#integrity-rules); R line 790, [migration rules](establishment-groups-logical-model-recommendation.md#migration-rules-from-the-edge-cases); R lines 848, 851–852, [open decisions](establishment-groups-logical-model-recommendation.md#open-decisions).

Rule 9 requires every open federation to have at least two members. T21, M6 and D13 nevertheless allow an unresolved single-school federation to migrate with a warning, while insisting that the rule is not relaxed. No staging, quarantine or publication state distinguishes such a record from a conforming target record.

D9 also prohibits empty open groups from migrating as open, while D12 explicitly permits empty open academy trusts when their company is active. If D9 is intended only for target organisation groups, its reference to F8 and generic wording need narrowing.

**Consequence:** there is no implementable acceptance rule for unresolved records, and different migration teams can silently close, reject or publish the same source record.

**Recommendation:** distinguish retained source/staging records from validated target records. Specify which rules block publication, which produce warnings, and which target records can remain unresolved. Explicitly scope D9 by target kind.

### H5. Proprietor is defined as an owner, which can identify the wrong party

**Location:** R line 47, [source-record meanings](establishment-groups-logical-model-recommendation.md#what-gias-group-and-proprietor-records-really-are); R lines 604–629, [establishment responsibility](establishment-groups-logical-model-recommendation.md#establishment-responsibility).

The proprietor definition combines ownership, running the school and accountability. DfE's September 2026 guidance defines a proprietor by responsibility for managing the school; it does not make asset ownership the identity test. See page 6 of [Registration of independent schools](https://assets.publishing.service.gov.uk/media/6aaa9c8cf1f8d2a39605f8c9/Registration_of_independent_schools.pdf).

A school operator, a property-owning company and a parent company can be different parties. The proposed wording could cause researchers to resolve a typed proprietor name to the owner of the premises or corporate group instead of the registered responsible party.

**Recommendation:** define proprietor using the regulatory responsibility. Treat ownership as a separate fact if it becomes required. Clarify that combining operation and accountability is a bounded modelling decision, not evidence that ownership is identical.

## Medium-severity findings

### M1. Unknown dates make the promised historical queries and cardinalities ambiguous

**Location:** R lines 621–622, [responsibility attributes](establishment-groups-logical-model-recommendation.md#establishment-responsibility); R lines 670–671, [membership attributes](establishment-groups-logical-model-recommendation.md#organisation-group-member); R lines 678–701, [views and rules](establishment-groups-logical-model-recommendation.md#derived-views).

A null start means unknown, explicitly not “since the beginning”. Nevertheless, views and uniqueness rules depend on whether a relationship was in effect on any requested date. For a current proprietor with no known start, the schema cannot distinguish “known current at extraction” from “known to apply on a historical date”.

Similarly, an archived source relationship whose end date is unknown cannot use null end without being interpreted as current. Merely leaving archive handling for investigation does not define the target state required by the outcome.

**Consequence:** consumers may either exclude legitimate current relationships or invent historical coverage. Temporal overlap checks will differ between implementations.

**Recommendation:** define current observation separately from known effective dates, and specify how uncertain intervals behave in historical queries and validation. An observation date, date-quality status, or equivalent source assertion could provide this without inventing dates.

### M2. Relationship validity is not tied to the lifecycle of the responsible entity or group

**Location:** R lines 687–704, [integrity rules](establishment-groups-logical-model-recommendation.md#integrity-rules); R lines 784–790, [migration rules](establishment-groups-logical-model-recommendation.md#migration-rules-from-the-edge-cases).

Rule 4 requires an academy-trust record to exist, but does not require its status to cover the responsibility period. Membership rules similarly do not say whether a membership may remain current after its group closes. Derived views select relationship periods without defining how parent closure affects them.

M1 closes relationships when the establishment closes; it does not address a closed trust or group linked to a still-open establishment.

**Consequence:** a dissolved company, former academy trust or closed group can remain a current endpoint in the derived views.

**Recommendation:** define lifecycle compatibility and the handling of conflicts or unknown dates. Use authoritative transfer/end evidence when available; do not infer a precise end date solely to satisfy the rule.

### M3. Closure dates are converted into exact half-open endpoints without a source-semantics check

**Location:** R lines 206–208, [lifecycle cases](establishment-groups-logical-model-recommendation.md#lifecycle-stale-or-odd-status); R line 708, [date convention](establishment-groups-logical-model-recommendation.md#date-convention); R line 784, [M1](establishment-groups-logical-model-recommendation.md#migration-rules-from-the-edge-cases).

M1 copies a school's closure date into the first day a responsibility no longer applies. For the example closure of 31 August 2016, that excludes the whole of 31 August. The papers do not establish whether the BAU closure field means the final day of existence or the first day after closure.

A stale link surviving until school closure also does not prove that its actual relationship ended on that exact date; it may have ended earlier.

**Recommendation:** document source-to-target date semantics and distinguish evidenced end dates from inferred bounds. Do not universally add a day or copy the date until the source convention is confirmed. Add boundary tests around closure and transfer dates.

### M4. Completed ontology changes are not present at the referenced paths

**Location:** R line 363, [costs accepted](establishment-groups-logical-model-recommendation.md#recommendation-and-reasons); R lines 826–827, [ontology implications](establishment-groups-logical-model-recommendation.md#implications-for-the-ontology-and-adjacent-slices).

These passages mark sponsorship changes as done in ontology v1.19 and SHACL v0.10. The files cited in the methodology currently declare:

- [Establishment ontology](../../../../../education-provider-registry-docs/models/establishment/establishment-ontology.ttl), line 41: version 1.18. It still contains SponsoredAcademy and Sponsor, including the former at line 2277.
- [Establishment SHACL](../../../../../education-provider-registry-docs/models/establishment/establishment-shacl.ttl), line 38: version 0.9. Its membership-role enumeration still includes all three values at line 2576.

**Consequence:** reviewers could assume the person-capable dated sponsorship shape already exists and omit necessary implementation work.

**Recommendation:** either cite the actual changed artifact/commit if it exists elsewhere or mark the work as proposed. No conclusion is made about another branch or repository copy.

### M5. Foundation-trust conclusions exceed the documented sampling scope and conflict with the white paper's mapping

**Location:** R lines 74–85 and 92, [F12 and method](establishment-groups-logical-model-recommendation.md#detailed-findings); R line 226, [T28](establishment-groups-logical-model-recommendation.md#parties-and-legal-form). W lines 225–227, 250 and 259, [foundation trust](bau-group-types-white-paper.md#trust-foundation-trust-02).

The sample is drawn from open trusts **with linked schools**, whereas the population claim covers foundation trusts generally. Of 449 open records, 254 have no links and are excluded from that sampling frame. The 12 matches are described as probable; their complete UID-to-company evidence is not included.

The white paper then specifies company or Royal Charter legal form and exempt charity status as the target mapping for foundation trusts. That contradicts its own older-foundation qualification and its Nord Anglia non-charity example, which R T28 also preserves.

**Recommendation:** state the sample population and uncertainty precisely and retain a compact evidence table for the 12 matches. Make legal form and charity status record-specific, with the s.23A qualification carried into W's target mapping. Absence from four web-search results is corroborative only, not a determination of exempt status.

### M6. “Different name” is incorrectly promoted to “different legal sponsor”

**Location:** R lines 17 and 58, [headlines and F3](establishment-groups-logical-model-recommendation.md#what-the-data-tells-us); R line 194, [T11](establishment-groups-logical-model-recommendation.md#identity-which-records-are-the-same-legal-entity). W lines 190–191, [sponsor profile](bau-group-types-white-paper.md#school-sponsor-05).

F3 classifies the 1,675 non-name-matching links as real, different sponsors. However, T11 explicitly supplies an old-name sponsor and renamed trust that represent the same company. The methodology also acknowledges that near-variants count as different.

**Consequence:** the 18% is presented as a confirmed external-sponsor population, although it contains unresolved identities and known naming variants. This distorts the evidence behind the model and expected migration workload.

**Recommendation:** label it “links not matched to the trust by this name rule”. Separate confirmed external sponsors from unresolved matches, and reserve identity percentages for resolved records.

### M7. Some identity examples require evidence absent from the extracts

**Location:** R line 227, [T29](establishment-groups-logical-model-recommendation.md#parties-and-legal-form); R line 723, [T3 worked example](establishment-groups-logical-model-recommendation.md#worked-examples). W lines 123–125, [Balcarras example](bau-group-types-white-paper.md#single-academy-trust-10).

T29 says to merge Zaytouna's SAT and MAT using incorporation date and Companies House number. In the actual group CSV, SAT UID 2120 has neither a Companies House number nor UKPRN; MAT UID 17003 holds them. The proposed number comparison cannot be performed on these source rows alone.

Similarly, W's Balcarras wording implies a company number shared across SAT and MAT records, but SAT UID 2224 has a blank company-number field. R F4 correctly says the number moves to the MAT. T3 also refers to a predecessor/successor link even though the stated public evidence excludes GroupRelationsLink rows.

**Recommendation:** distinguish source fields, inferred identity and separately verified history. Identify the additional evidence required for each merge and leave it unresolved until that evidence is available.

### M8. The lead-centre flag fabricates certainty and lacks an explicit change-history rule

**Location:** R line 93, [extract limits](establishment-groups-logical-model-recommendation.md#how-the-numbers-were-produced); R line 217, [T24](establishment-groups-logical-model-recommendation.md#structure-and-cardinality); R lines 670–672, [membership attributes](establishment-groups-logical-model-recommendation.md#organisation-group-member); R line 739, [T5](establishment-groups-logical-model-recommendation.md#worked-examples).

The extract has no lead flag, yet T24 says the only linked centre is marked as lead. A single visible member is not evidence of its lead designation, especially when the case itself allows missing members. T5 also requires a true flag without identifying which member.

A required boolean has no representation for “designation not available in this source”. In addition, changing lead centre while membership continues either overwrites history or requires splitting membership intervals, for which the document supplies no convention.

**Recommendation:** source the flag from BAU before asserting it and define unknown handling. Specify whether lead assignment has its own dated relationship or whether membership rows are state periods with rules preserving the original joining event.

## Low-severity findings

### L1. Seven relative links to archived papers are broken

**Location:** R lines 5, 121 (two links), 161, 164, 281 and 807.

The links still use the former same-directory paths. Both files now exist under archive:

- [First attempt](archive/establishment-groups-organisations-and-roles.md).
- [Worked examples and EDM questions](archive/provider-registry-worked-examples-and-questions.md).

This also makes R line 153's statement that the links were checked inaccurate for the current file locations.

**Recommendation:** update those seven destinations and check their heading fragments. No missing analysis-script link is reported here: those references were intentionally removed before this review.

### L2. Identifier summaries contradict the confirmed foundation-trust exception

**Location:** R lines 52–53, [F1](establishment-groups-logical-model-recommendation.md#detailed-findings); W line 428, [across all types](bau-group-types-white-paper.md#across-all-types).

Both passages say only academy trusts hold Companies House numbers and UKPRNs. The documents' tables and the group CSV identify one foundation trust with a Companies House number: The Pioneer Co-Operative Trust, UID 1028, number 06893415.

**Recommendation:** distinguish the schemes: UKPRNs are confined to academy trusts in this extract; Companies House numbers are overwhelmingly on academy trusts, with one foundation-trust exception.

## Scope decisions and non-findings

The following should not be treated as defects merely because they differ from another possible design:

- **SAT/MAT classification history is explicitly deferred**, at R lines 379 and 590. Preserving continuous legal identity and responsibility history does not require implementing classification history in this slice. Historical outputs must make that limitation clear.
- **The exclusive party rule is already stated**, at R lines 611 and 688. A logical model can express constraints in prose; absence of executable SQL or a Mermaid XOR symbol is not itself a missing logical rule.
- **Numeric GIAS UIDs and textual identifier values are not inherently contradictory.** The source UID is numeric; general identifier values must support schemes with leading zeros and letters.
- **Sponsorship policy is openly unresolved**, through D3 and D4. Preserving the source assertion while seeking policy clarification is defensible. It should not be converted into a claim that legal sponsorship and BAU sponsor links are already proven equivalent.
- **Using the EDM's broad legal-entity category is an explicit choice.** The recommendation acknowledges unincorporated bodies. Care is still needed when describing legal personality, but that qualification is not absent.
- **No conclusion about every historical transfer can be drawn from current links.** The dated target can support future history even where the migration evidence cannot reconstruct past periods.

## Suggested resolution order

1. Resolve H1–H4: identity rules, mapping precedence, complete legacy crosswalk and the boundary between unresolved source records and validated target data.
2. Correct the proprietor definition and define uncertain-date, closure-date and lifecycle semantics.
3. Reconcile the evidence claims, target mappings and ontology implementation status.
4. Repair archived-paper links and factual summary wording.
5. Turn the resulting rules into acceptance cases, including an empty-set name match, Co-op's unequal membership sets, a renamed trust, an individual sponsor redirect, a federation Group ID, an unresolved one-member federation, an unknown-start relationship and a lead-centre change.

## Reviewed file fingerprints

SHA-256 values captured during review:

| File | SHA-256 |
| --- | --- |
| bau-group-types-white-paper.md | 4279194BA90D0DCAEEC37942C0B7B6EE0334A718E8A34C49BF933C6D28289D97 |
| establishment-groups-logical-model-recommendation.md | CB03D1CE9C46189E73F1E75E939429A5BE028EF7FD8033FBF55BB9BA626A3254 |

