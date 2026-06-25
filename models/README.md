# Models

This folder contains machine-readable semantic model files for the Education Provider Registry data prototype.

## Files

- `education-provider-vocabulary.ttl` - a SKOS vocabulary for Education Provider Registry concepts, including preferred labels, alternative labels, definitions, relationships, statuses and source notes.
- `education-provider-taxonomy.ttl` - a SKOS taxonomy for Education Provider Registry classifications, expressed as facets and narrower taxons evidenced by the current modelling work.
- `education-provider-ontology.ttl` - an OWL 2 ontology defining the classes, properties and named individuals for the Education Provider Registry model. WIDOCO generates browsable documentation and a WebVOWL graph from this file.

## SKOS

SKOS, the Simple Knowledge Organization System, is a W3C standard for representing vocabularies, thesauri, taxonomies and concept schemes using RDF. These `.ttl` files use Turtle syntax to make the concepts readable by both people and RDF tooling.

See more: <https://www.w3.org/TR/skos-reference/>

## Canonical Identifiers

The canonical identifier for a concept is its expanded RDF IRI, not its GitHub line link.

For example, in the TTL file:

```ttl
@prefix epr: <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/> .

epr:EstablishmentLifecycle
    a skos:Concept ;
    skos:prefLabel "Establishment lifecycle"@en .
```

The persistent concept identifier is:

```text
https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/EstablishmentLifecycle/
```

The GitHub link to a line in `education-provider-vocabulary.ttl` is useful for review and navigation, but it should not be treated as the canonical identifier because line numbers can change as the file evolves.

The taxonomy file uses `skos:relatedMatch` to link taxonomy concepts to vocabulary concepts when there is a matching published vocabulary concept. Not every taxon has a vocabulary concept, so absence of a link is intentional rather than a publication error.

## Published Model Pages

The generated technical documentation site publishes the vocabulary and taxonomy as navigable pages:

- Vocabulary: <https://dfe-digital.github.io/education-provider-registry-docs/vocabulary/>
- Taxonomy: <https://dfe-digital.github.io/education-provider-registry-docs/taxonomy/>


