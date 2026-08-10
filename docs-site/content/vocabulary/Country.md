# Country

[Back to vocabulary index](../)

| Property | Value |
| --- | --- |
| Canonical URI | <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/Country/> |
| Compact identifier | `epr:Country` |
| Preferred label | Country |
| Alternative labels |  |
| Legacy GIAS label |  |
| Status | Provisional |
| Broader concepts | [Address](../Address/) |
| Related concepts |  |
| Defined by |  |
| Legislation |  |
| References |  |

## Definition

The country of an address. Relevant for British schools overseas and other establishments located outside England.

## Scope Notes

- Distinct from the County text field in the address, which records the county within England. In GIAS this is stored as Establishment.Country_code referencing the Nationality table — a legacy naming mismatch. The target model treats this as country of location. Future iterations should consider migrating to ISO 3166-1 alpha-2 codes to replace the legacy code list and unify handling with EstablishmentGroup.GroupCountry_code.

## Source

Source TTL: [models/education-provider-vocabulary.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl)
