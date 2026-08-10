# LAESTAB

[Back to vocabulary index](../)

| Property | Value |
| --- | --- |
| Canonical URI | <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/Laestab/> |
| Compact identifier | `epr:Laestab` |
| Preferred label | LAESTAB |
| Alternative labels | Local authority establishment |
| Legacy GIAS label |  |
| Status | Provisional |
| Broader concepts | [Establishment identity](../EstablishmentIdentity/) |
| Related concepts | [DfE number](../DfeNumber/) |
| Defined by | [https://get-information-schools.service.gov.uk/glossary](https://get-information-schools.service.gov.uk/glossary) |
| Legislation |  |
| References | [See evidence for LAESTAB](https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/references/#laestab-dfe-number) |

## Definition

An alternative rendering of the DfE number in which the LA number and establishment number are concatenated without a separator to produce a seven-digit string (e.g. "1234567"). Encountered in payroll systems, some data returns and legacy DfE publications.

## Scope Notes

- LAESTAB represents the same composite identifier as DfE number but uses a different format convention. It is not a physical database column and DfeNumber is the preferred target concept. Although LAESTAB is not the preferred concept, it remains a live user-facing search and display identifier in GIAS and should not be treated as obsolete.

## Source

Source TTL: [models/education-provider-vocabulary.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl)
