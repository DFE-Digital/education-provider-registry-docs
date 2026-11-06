# Academy establishment types and academy route: options

Decision: Option 3, agreed on 6 November 2026. The conceptual model stays as it is. Only the logical and physical models change.

## Problem

We changed how the registry records academy types. BAU has nine academy establishment types, split by how each academy came about. The registry models have five types plus a separate **academy route** (Converter or Sponsor led).

| BAU code | BAU establishment type | Registry type | Registry route |
| --- | --- | --- | --- |
| 34 | Academy converter | Mainstream academy | Converter |
| 28 | Academy sponsor led | Mainstream academy | Sponsor led |
| 44 | Academy special converter | Academy special school | Converter |
| 33 | Academy special sponsor led | Academy special school | Sponsor led |
| 42 | Academy alternative provision converter | Academy alternative provision | Converter |
| 43 | Academy alternative provision sponsor led | Academy alternative provision | Sponsor led |
| 45 | Academy 16-19 converter | Academy 16 to 19 | Converter |
| 46 | Academy 16 to 19 sponsor led | Academy 16 to 19 | Sponsor led |
| 57 | Academy secure 16 to 19 | Academy secure 16 to 19 | None |

Two groups of users now pull in opposite directions.

**The administrative team needs the full set.** They've told us that losing the nine types would disrupt their internal processes too much. They need every academy type and its BAU type code. This matches the code: BAU validation, notifications and conversion rules branch on the specific type ([code investigation](../../../Investigations/establishment-types/academy-converter-vs-sponsor-led-code-investigation.md)). The codes are also published in the daily CSV, so downstream systems use them too.

**Public users need fewer types.** In website testing, people found the many academy types confusing. They don't care whether a school was a converter or sponsor led. Grouping by route made academies easier to find.

The administrative team's need is a hard constraint. They can't work with the reduced set. The question is how to give them the full set without bringing the confusion back for public users, or losing what we gained by separating route from type.

## What the models hold today

- **Ontology and vocabulary** have the five types and `est:AcademyRoute`, set through `esto:hasAcademyRoute`. The BAU names survive only as `est:legacyGiasLabel` values on the five types.
- **Taxonomy** still lists the nine BAU types under `est:EstablishmentTypeGroupAcademies`, but they aren't defined as concepts anywhere. Those references point at nothing.
- **SHACL** requires a route on four of the five types.
- **Logical model** ([identity-and-classification.md](../../../../education-provider-registry-docs/models/logical/establishment/identity-and-classification.md)) has `establishment_type` with an id and a name. It has no route and no code.
- **Physical schema and seed** have the five types (ids 4 to 8). They have no route column and no BAU code.
- **BAU transform** ([establishment-from-bau.sql](../../../../education-provider-registry-docs/models/schema/establishment/transforms/establishment-from-bau.sql)) folds the nine types into five by matching on names, and throws the route away.

So the route exists only in the conceptual model. Once data is loaded, we can't tell a converter from a sponsor-led academy.

**A bug to fix whatever we decide.** The transform matches 16 to 19 academies on `'Academy 16-19 sponsor led'` and `'Academy 16 to 19 converter'`. The BAU labels are `Academy 16-19 converter` and `Academy 16 to 19 sponsor led`. Neither name matches, so 16 to 19 academies get no type. Matching on the BAU code rather than the name would avoid this kind of error.

## What the options have to satisfy

| Force | What it needs |
| --- | --- |
| Administrative processes | All nine academy types, each with its BAU code, used for recording and editing |
| Public discovery | A small set of academy categories, with no converter or sponsor-led split |
| Downstream consumers | The published BAU type codes keep working |
| Conceptual clarity | Route stays a real concept, not something buried in type labels |
| Data integrity | No way to record a type and a route that contradict each other |
| Coexistence and migration | A simple, reliable mapping from BAU |

## Options

### Option 1: Go back to the nine BAU types and drop route

Record the nine types as establishment types. Remove `est:AcademyRoute`. The public website groups the types for display.

- Meets the administrative need directly. Migration is one to one.
- Loses route as a concept. "Converter" exists only inside type labels, so any question about route means parsing names.
- Every public grouping lives in front-end code, outside the model.
- Undoes a decision without keeping what it got right.

### Option 2: Keep five types and route, and work out the BAU type when needed

Record the type (one of five) and the route as separate values. Map each pair to a BAU type and code for admin screens and extracts.

- Keeps the current conceptual model.
- No information is lost, because each type and route pair maps to exactly one BAU type.
- The administrative team works through a translation in both directions. Every admin edit, validation rule and extract has to map pairs to codes and back.
- Two stored values can contradict each other, such as a secure 16 to 19 academy with a route, or a mainstream academy without one. We'd need constraints to stop that.
- Route still has to be added to the logical and physical models.

### Option 3: Record the detailed type, and work out the category and route from it (agreed)

Record one of the nine academy types, with its BAU code, as the establishment's type. Each detailed type sits under one of five broader **academy categories** and carries its route. The category and route are worked out from the type, never stored separately.

```text
Academy converter (34)          -> category: Mainstream academy,          route: Converter
Academy sponsor led (28)        -> category: Mainstream academy,          route: Sponsor led
Academy special converter (44)  -> category: Academy special school,      route: Converter
...
Academy secure 16 to 19 (57)    -> category: Academy secure 16 to 19,     route: none
```

- **Administrative team:** sees, records and edits the nine types and codes, as they do today. No translation.
- **Public users:** the website and public API filter on category. Converter and sponsor led never need to appear.
- **Downstream consumers:** BAU codes are kept and published unchanged.
- **Conceptual model:** unchanged. Its five types become the logical model's categories, and its route stays as it is. Each detailed type maps to exactly one conceptual type and route.
- **Integrity:** one stored value, so type and route can't contradict each other.
- **Migration:** one to one on the BAU code. It also removes the name-matching bug.

The cost is that a new route would mean new detailed types. But the administrative process already works that way, and new academy types are rare.

### Option 4: Store the BAU type, the category and the route as separate values

- Gives everyone their own field.
- Three values that must agree, with nothing in the structure making them agree. Rejected.

## Comparison

| Force | Option 1 | Option 2 | Option 3 | Option 4 |
| --- | --- | --- | --- | --- |
| Administrative processes | Met | Met through translation | Met | Met |
| Public discovery | Front-end grouping only | Met | Met | Met |
| Downstream codes | Met | Through translation | Met | Met |
| Route as a concept | Lost | Kept | Kept, worked out from type | Kept |
| Integrity | Met | Needs constraints | Met by structure | Weak |
| Migration | Simple | Two-way mapping | Simple | Simple, with checks |

## Decision

**Option 3.** Store what the people who maintain the data work with, and work out what readers need on the read side. The administrative team edits the data, so their nine types are the recorded fact. Public users only read, so the simpler category belongs in the published projection and the public API, where it costs nothing to work out.

**The conceptual model stays as it is.** It already says what an academy is (five types) and how it came about (route). The nine BAU types encode both facts in one administrative code. That's a choice about how we record and process the data, so it belongs in the logical and physical models. Each logical type maps to one conceptual type and one route, so nothing is lost between the layers.

The BAU codes belong in the logical and physical models too, as a code on the reference data. They're a published DfE code that the administrative team and downstream consumers depend on, like the LA code. They aren't migration lineage.

## Plan of changes

### Conceptual model

No change. The ontology, vocabulary, taxonomy and SHACL keep the five types and `est:AcademyRoute`.

Separately, the taxonomy's `est:EstablishmentTypeGroupAcademies` still lists the nine BAU types as narrower concepts that aren't defined anywhere. That's an existing tidy-up, not part of this decision.

### Logical model

[identity-and-classification.md](../../../../education-provider-registry-docs/models/logical/establishment/identity-and-classification.md), establishment type section:

- Add `code` to `establishment_type`: the published DfE establishment type code, required and unique.
- Add `establishment_type_category` as reference data, with a canonical identifier for the conceptual type it stands for, such as `est:MainstreamAcademy`. Each establishment type belongs to one category. A non-academy type sits in a category of its own, so the public site can use categories for every type.
- Add `academy_route` as reference data, with canonical identifiers `est:ConverterRoute` and `est:SponsorLedRoute`. Add an optional `academy_route_id` on `establishment_type`.
- Rule: an establishment references a detailed type. Category and route are reached through the type and never stored on the establishment.
- Add a table showing how each academy type maps to its conceptual type and route.
- Update the ERD.

### Physical model

| File | Change |
| --- | --- |
| [establishment-schema.sql](../../../../education-provider-registry-docs/models/schema/establishment/establishment-schema.sql) | Add `code`, `establishment_type_category_id` and `academy_route_id` to `establishment.establishment_type`. Add the two new reference tables. |
| [seed-reference-data.sql](../../../../education-provider-registry-docs/models/schema/seed/seed-reference-data.sql) | Replace ids 4 to 7 with the eight detailed types, and add codes for all types. Seed categories and routes. |
| [establishment-from-bau.sql](../../../../education-provider-registry-docs/models/schema/establishment/transforms/establishment-from-bau.sql) | Map on the BAU type code, one to one. Remove the name-based folding, which fixes the 16 to 19 bug. |
| `schema/tests/approval/*.approved.json` and `schema/establishment/cases/*.md` | Re-approve the five academy cases that expect "Mainstream academy" (134314, 135905, 135936, 136102, 137603). |

### Other documents

- Update section 5 of the [model divergence page](../../../../education-provider-registry-docs/docs-site/content/models/epr-gias-model-divergence.md). The conceptual model still has five types and route. The logical and physical models keep the nine BAU types and codes, and map them to the conceptual types and route.
- Record the decision as ADR 0005 in [education-provider-registry-docs/adr](../../../../education-provider-registry-docs/adr/).
- The public API requirements need nothing new. Type comes with its code and label, and filters can use category.

## Open questions

1. Which academy categories should the public site show? Five may still be too many. User research might favour "Academy", with special, alternative provision and 16 to 19 as separate filters.
2. Should free schools, university technical colleges and studio schools fall under the same public categories as academies? Free school is arguably a third route. Option 3 lets us add one later without changing the recorded types.
3. The opening reason "Academy Converter" overlaps with the Converter route. Should one be worked out from the other? This is outside this decision.
4. Does the administrative team need other type groupings kept, beyond the academy types? We should check before we change the seed data.
