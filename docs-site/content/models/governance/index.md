# Governance

This section contains the machine-readable governance subdomain artefacts.

## Artefacts

| Artefact | Format | What it does |
| --- | --- | --- |
| [Vocabulary](./vocabulary/) | SKOS | Defines the provisional governance nouns, preferred labels and working definitions |
| [Taxonomy source](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/governance/governance-taxonomy.ttl) | SKOS/Turtle | Organises governance concepts into independent facets such as participant type, appointment type, role and historical status |

The governance vocabulary remains flat. Taxonomic classification is held separately in `governance-taxonomy.ttl`, so a concept can occur in more than one facet without implying a single inheritance hierarchy. The vocabulary source is [`models/governance/governance-vocabulary.ttl`](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/governance/governance-vocabulary.ttl).
