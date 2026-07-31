# Data Model Artefacts

This section indexes the formal artefacts that define and validate the Education Provider Registry data model.

The model is split into two subdomains, each following the same pattern: a vocabulary and taxonomy defining terms and classifications, an ontology defining structure and relationships, and (for establishment) SHACL shapes expressing what valid data must look like.

## Artefacts

| Artefact | Format | What it does |
| --- | --- | --- |
| [Establishment](./establishment/) | SKOS/OWL/SHACL | Establishment subdomain index, including vocabulary, taxonomy, ontology and worked examples |
| [Governance](./governance/) | SKOS/OWL/SHACL | Governance subdomain index, including vocabulary, taxonomy, ontology and worked examples |
| [Provider registry questions and answers](./provider-registry-questions-and-answers/) | Markdown | Questions raised about the EPR data model and ontology, with answers drawn from the model artefacts. |
| [EPR model divergence from GIAS](./epr-gias-model-divergence/) | Markdown | Where the EPR target ontology deliberately diverges from the legacy GIAS 1.0 data model, with reasons for each decision. |

## Source files

The Turtle source files are in `models/establishment/` and `models/governance/` in the repository. The vocabulary, taxonomy and field-rules pages on this site are generated or copied from those files during the build.
