# Proprietor

[Back to vocabulary index](../)

| Property | Value |
| --- | --- |
| Canonical URI | <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/Proprietor/> |
| Compact identifier | `epr:Proprietor` |
| Preferred label | Proprietor |
| Alternative labels | Proprietor's name |
| Legacy GIAS label |  |
| Status | Preferred |
| Broader concepts | [Establishment accountability](../EstablishmentAccountability/) |
| Related concepts | [Other independent school](../OtherIndependentSchool/)<br>[Organisation](../Organisation/)<br>[Person](../Person/) |
| Defined by |  |
| Legislation |  |
| References |  |

## Definition

The person or body responsible for the conduct of an independent school under the Education Act 2002, s.94. The proprietor is required to be registered with the Secretary of State under s.98 and is the legal entity to whom registration requirements and inspection duties apply.

## Scope Notes

- In the target EPR model the proprietor relationship is expressed via epro:hasProprietor on epr:Establishment, with range epr:Organisation (for a company or charity) or epr:Person (for an individual). The epr:Proprietor OWL class has been removed; the concept is retained here as a vocabulary entry for the GIAS UI field.

## Source

Source TTL: [models/education-provider-vocabulary.ttl](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/education-provider-vocabulary.ttl)
