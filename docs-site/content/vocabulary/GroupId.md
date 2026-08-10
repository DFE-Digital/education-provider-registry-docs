# Group identifier

[Back to vocabulary index](../)

| Property | Value |
| --- | --- |
| Canonical URI | <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/GroupId/> |
| Compact identifier | `epr:GroupId` |
| Preferred label | Group identifier |
| Alternative labels |  |
| Legacy GIAS label |  |
| Status | Provisional |
| Broader concepts | [Establishment group membership](../EstablishmentGroupMembership/) |
| Related concepts |  |
| Defined by |  |
| Legislation |  |
| References | [See evidence for Group identifier](https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/references/#group-id-tr-sp-prefix) |

## Definition

The business-facing GIAS group identifier assigned to an establishment group. Distinct from the internal surrogate key used in the GIAS database.

## Scope Notes

- Group ID is conditionally populated by group type. School sponsors use an SP-prefixed identifier (e.g. SP01153). Multi-academy trusts and single-academy trusts use a TR-prefixed identifier (e.g. TR00261). Group ID is absent for secure single-academy trusts, federations, trust (code 02), children's centre groups and children's centre collaborations.

## Source

Source TTL: [models/education-provider-vocabulary.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl)
