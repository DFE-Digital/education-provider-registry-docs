# Migration Rule Catalogue

- `MR001` Current academy-trust classification from current academy responsibilities: for each legal entity, the academy-trust type on its current `run_by_academy_trust` responsibilities identifies the `academy_trust_classification` row with `is_current = true`. All current academy responsibilities for the legal entity must have the same academy-trust type. A disagreement is a migration data-quality failure.
- `MR002` Responsibility date from source group link: use `GroupLink.effectiveDate` as `establishment_responsibility.start_date`. Do not use it as an academy-trust classification date.
- `MR003` Unknown role and classification boundaries: where the source does not provide role or classification start and end dates, store null. Do not derive those dates from establishment-responsibility links.
- `MR004` Current responsibility from source link: map an active source group link to `establishment_responsibility.is_current = true` and an archived source group link to `false`.
- `MR005` Academy-trust type from source group type: map SAT, MAT and secure-SAT source group types to `academy_trust_type_id` on `run_by_academy_trust` responsibilities.
- `MR006` Current group identifiers: retain every migrated Group UID and Group ID. Mark the identifier from the current source group record as current.
- `MR007` Legal-entity identity resolution: resolve academy-trust source records to one legal entity using approved identity evidence, principally Companies House number where supplied.
- `MR008` Missing Companies House number: do not invent a Companies House number for a sponsor or other party when the source does not supply one.
- `MR009` Valid responsibility source links: create a responsibility only where a valid source group link supplies a non-placeholder effective date.
