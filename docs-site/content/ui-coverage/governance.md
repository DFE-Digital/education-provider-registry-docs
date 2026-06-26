# Governance tab field coverage

This page is generated from `models/provider-field-coverage.ttl` — do not edit directly.

Source: <https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/provider-field-coverage.ttl>

Tick (✓) indicates the field is displayed for that establishment type. Blank = not shown.

---

| Field | 01 | 02 | 03 | 05 | 06 | 07 | 12 | 14 | 15 | 28 | 33 | 34 | 35 | 36 | 38 | 39 | 40 | 41 | 42 | 43 | 44 | 45 | 46 | `epr:` concept |
| --- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | --- |
| Appointed by | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `epr:GovernanceAppointingBody` |
| Date appointment ended | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `epr:GovernanceTermEndDate` |
| Date of appointment | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `epr:GovernanceAppointmentDate` |
| Governance role | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `epr:GovernanceRoleType` |
| Governance role identifier (GID) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `epr:GovernanceIdentifier` |
| Name | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | `epr:GovernancePerson` |
| Shared with |  |  |  |  |  |  |  |  |  |  | ✓ | ✓ | ✓ |  |  |  |  |  |  |  |  |  | ✓ | `epr:GovernanceAppointment` |

---

## Establishment type key

| Code | Establishment type |
| --- | --- |
| 01 | Community school |
| 02 | Voluntary aided school |
| 03 | Voluntary controlled school |
| 05 | Foundation school |
| 06 | City technology college |
| 07 | Community special school |
| 12 | Foundation special school |
| 14 | Pupil referral unit |
| 15 | Local authority nursery school |
| 28 | Academy sponsor led |
| 33 | Academy special sponsor led |
| 34 | Academy converter |
| 35 | Free schools |
| 36 | Free schools special |
| 38 | Free schools alternative provision |
| 39 | Free schools 16 to 19 |
| 40 | University technical college |
| 41 | Studio schools |
| 42 | Academy AP converter |
| 43 | Academy AP sponsor led |
| 44 | Academy special converter |
| 45 | Academy 16-19 converter |
| 46 | Academy 16 to 19 sponsor led |

## Notes

- Evidence source: observed GIAS public page rendering, June 2026.
  One representative establishment per type.
- Types 09, 17, 22, 23 and 98 are excluded: no sample rows in the June 2026 extracts.
- Re-generate by running `scripts/generate-ui-coverage-pages.ps1`.

[Back to UI coverage index](../)
