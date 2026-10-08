# Migration Rule Catalogue

> **Working catalogue, not definitive policy.** These are the migration rules and assumptions identified for the first phase of delivering the physical model. They are not yet the complete or definitive migration rule set and must be reviewed, extended and formally agreed before production migration.

- `MR001` Current academy-trust classification from current academy responsibilities: for each legal entity, the academy-trust type on its current `run_by_academy_trust` responsibilities identifies the `academy_trust_classification` row with `is_current = true`. All current academy responsibilities for the legal entity must have the same academy-trust type. A disagreement is a migration data-quality failure.
- `MR002` Responsibility date from source group link: use `GroupLink.effectiveDate` as `establishment_responsibility.start_date`. Do not use it as an academy-trust classification date.
- `MR003` Unknown role and classification boundaries: where the source does not provide role or classification start and end dates, store null. Do not derive those dates from establishment-responsibility links.
- `MR004` Current responsibility from source link: map an active source group link to `establishment_responsibility.is_current = true` and an archived source group link to `false`.
- `MR005` Academy-trust type from source group type: map SAT, MAT and secure-SAT source group types to `academy_trust_type_id` on `run_by_academy_trust` responsibilities.
- `MR006` Current group identifiers: retain every migrated Group UID and Group ID. Mark the identifier from the current source group record as current.
- `MR007` Legal-entity identity resolution: resolve academy-trust source records to one legal entity using approved identity evidence, principally Companies House number where supplied.
- `MR008` Missing Companies House number: do not invent a Companies House number for a sponsor or other party when the source does not supply one.
- `MR009` Valid group-derived responsibility source links: create a group-derived responsibility only where a valid source group link supplies a non-placeholder effective date. This does not apply to proprietor assertions, which have no GIAS group link; the controlled T9 mapping follows MR012.
- `MR010` Closed academy-trust role boundary: when a closed MAT group record and its linked establishment have the same close date, use that group close date as the evidenced end of the academy-trust role and MAT classification. Keep the responsibility end as inferred from the establishment closure, and retain the distinct evidence bases.
- `MR011` Academy-trust charitable company assumption: when a source group is an academy trust (SAT, MAT or secure SAT) and supplies a Companies House number, classify the legal entity as `Charitable company limited by guarantee`. This is an explicit migration assumption because local BAU does not persist verified Charity Commission status; retain the source group type and Companies House number as supporting evidence, and allow a later authoritative charity-status correction.
- `MR012` Controlled proprietor identity and provenance (T9): verify the two selected `PropsName` assertions against the 16 June 2026 public extract, then resolve them to the explicitly accepted shared Acorn legal-entity allocation. This is a reviewed fixture assumption, not automatic name matching or verification of registered legal form. Create one current Proprietor responsibility per school with unknown start/end dates; retain 2026-06-16 as the extract observation date in migration evidence. Preserve the local obfuscated proprietor classification separately as context, with its own source snapshot beneath the same rebuild run. Do not create a proprietor party role, group identifiers, registered organisation identifiers or ownership assertions. Reimport retains the accepted party, responsibilities and evidence rather than allocating duplicates.

## Recommended future migration steps

### MR013 — Companies House identity verification and enrichment

**Recommendation; deferred and not implemented.** When Companies House integration is available, add a migration step to verify company identities and enrich legal entities with registered details that BAU does not supply explicitly.

- Look up candidate companies using a supplied company number where available, or search using the source name and other available evidence. A matching name alone must not trigger an automatic match.
- Confirm that the company is the same party as the source proprietor, trust or sponsor before attaching its registered details. Ambiguous matches require review; do not merge parties automatically.
- After an accepted match, retain the existing target `legal_entity_id`, add the Companies House number to `organisation_identifier`, and populate the verified legal form and incorporation date where supported. Do not overwrite conflicting identifiers or legal facts without review.
- Retain the lookup date, register reference, returned evidence and identity-resolution decision in the migration schema. Distinguish verified register facts from BAU assertions and migration assumptions, including MR011.
- Where the lookup is unavailable or inconclusive, keep unverified fields null and record the outstanding enrichment requirement. This need not block an independently accepted proprietor responsibility. People and non-company bodies must not be forced into company records.
- Company incorporation does not establish when a proprietor responsibility began. The match does not establish ownership of a school's business, assets, land or buildings, or establish charity status by itself.

**T9 example:** [ACORN CARE AND EDUCATION LIMITED, company 05019430](https://find-and-update.company-information.service.gov.uk/company/05019430) is the candidate register record identified during review. It supplies a private limited company classification and incorporation date of 19 January 2004. These details have not been applied to T9: the current migration deliberately leaves the registered company identifier, legal form and incorporation date absent until the enrichment and identity-verification step is supported and accepted.

### MR014 - Manual identity review for sponsors and trusts with similar names

**Recommendation; not implemented or formally agreed for production migration.** Where a sponsor and an academy trust have similar names, triage the pair for manual identity review to establish whether the source records represent one entity or separate entities. Name similarity identifies candidates for review; it must not trigger an automatic merge.

- Compare the source Group UIDs, Group IDs, names, Companies House numbers, UKPRNs, available organisation identifiers and establishment link sets. Shared academy links support investigation but do not prove shared legal identity. Missing identifiers are not evidence of either shared or separate identity.
- A reviewer must record one of three outcomes: same entity, separate entities, or unresolved. Record the source records, evidence, rationale, reviewer and decision date. Use authoritative register evidence where available and investigate conflicting identifiers rather than overwriting them.
- Where the decision is same entity, map both source records to one target party while preserving separate Academy trust and School sponsor roles, source group identifiers and establishment responsibilities. Retain the provenance of identifiers supplied by only one source record.
- Where the decision is separate entities, retain separate target parties with independently owned identifiers, roles and responsibilities.
- Where the outcome is unresolved, hold the identity-dependent migration slice pending a decision. Do not default to either merging or creating separate parties.
- Apply accepted decisions through an explicit, repeatable identity mapping so that subsequent runs reuse the same target identity. A test-case assumption does not constitute approval for production migration.

**T11R example:** Sponsor UID 4075 (`Oasis Community Learning`, SP00392) and MAT UID 4076 (`OASIS COMMUNITY LEARNING`, TR01553) have matching names apart from case and the same 47 current linked establishments. Only the MAT supplies company number `05398529` and UKPRN `10058190`; the inspected BAU records contain no explicit shared-identity link. For the test case, they are assumed to represent one legal entity with two roles. Actual migration requires a recorded manual identity decision.
