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
- `MR009` Valid responsibility source links: create a responsibility only where a valid source group link supplies a non-placeholder effective date.
- `MR010` Closed academy-trust role boundary: when a closed MAT group record and its linked establishment have the same close date, use that group close date as the evidenced end of the academy-trust role and MAT classification. Keep the responsibility end as inferred from the establishment closure, and retain the distinct evidence bases.
- `MR011` Academy-trust charitable company assumption: when a source group is an academy trust (SAT, MAT or secure SAT) and supplies a Companies House number, classify the legal entity as `Charitable company limited by guarantee`. This is an explicit migration assumption because local BAU does not persist verified Charity Commission status; retain the source group type and Companies House number as supporting evidence, and allow a later authoritative charity-status correction.
