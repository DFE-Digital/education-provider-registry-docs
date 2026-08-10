# Governance person identifier

[Back to vocabulary index](../)

| Property | Value |
| --- | --- |
| Canonical URI | <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/GovernancePersonIdentifier/> |
| Compact identifier | `epr:GovernancePersonIdentifier` |
| Preferred label | Governance person identifier |
| Alternative labels |  |
| Legacy GIAS label |  |
| Status | Provisional |
| Broader concepts | [Governance appointments](../GovernanceAppointments/) |
| Related concepts |  |
| Defined by |  |
| Legislation |  |
| References | [See evidence for Governance person identifier](https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/references/#governance-person-identifier-hash) |

## Definition

A pseudonymous identifier for a GovernancePerson, derived by hashing normalised date of birth, surname and forename1. Deterministic - the same person's details always produce the same hash - but the raw date of birth is not recoverable from the hash.

## Scope Notes

- Where a governance person's surname has changed, a previous-surname alias hash enables continuity across appointments. This identifier is pseudonymous, not anonymous. It can be re-linked to the source GIAS record and must be treated as personal data under UK GDPR.

## Source

Source TTL: [models/education-provider-vocabulary.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl)
