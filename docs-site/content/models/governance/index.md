# Governance

This section contains the machine-readable governance subdomain artefacts.

## Artefacts

| Artefact | Format | What it does |
| --- | --- | --- |
| [Vocabulary](./vocabulary/) | SKOS | Defines the provisional governance nouns, preferred labels and working definitions |
| [Taxonomy](./taxonomy/) | SKOS | Defines controlled governance classifications such as participant capacity, appointment type, appointing party, role, lifecycle status and historical provenance |

The governance vocabulary remains flat. Taxonomic classification is held separately in `governance-taxonomy.ttl`, so a concept can occur in more than one facet without implying a single inheritance hierarchy. The source files are [`models/governance/governance-vocabulary.ttl`](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/governance/governance-vocabulary.ttl) and [`models/governance/governance-taxonomy.ttl`](https://github.com/DFE-Digital/education-provider-registry-docs/blob/main/models/governance/governance-taxonomy.ttl).
