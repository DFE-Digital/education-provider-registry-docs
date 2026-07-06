# Establishment Subtype Attribute Matrix

[Download the establishment subtype attribute matrix (CSV)](./establishment-subtype-attribute-matrix.csv)

## Purpose

The establishment subtype attribute matrix describes how establishment attributes vary across broad establishment subtypes.

It answers:

> For each establishment subtype, is this attribute required, optional, not applicable, or not yet explicitly classified?

The matrix is a modelling artefact, not a direct database export or physical database design.

## What It Contains

The matrix contains:

- One row for each of the 41 establishment attributes being assessed, such as URN, open date and local authority.
- One column for each of the 41 active establishment types, labelled with its GIAS type code and name.
- A value at each intersection showing whether that attribute is required, optional or not applicable for that establishment type. A blank means that no rule has yet been confirmed.

The matrix is intentionally flat. Structural concepts that only group other fields, such as `Capacity and pupil measures`, `Establishment identity` and `SEN and resourced provision`, are defined in the vocabulary and ontology but are not repeated as matrix rows.

Each active establishment type has its own column, labelled with its GIAS type code and name. Types that currently share the same attribute rules still appear separately, making the matrix directly usable without first resolving a type to a broader rule profile.

## Cell Meanings

| Value | Meaning |
| --- | --- |
| `required` | The attribute is expected for that subtype under the current proposed rule set. A future validation design would normally require a value or relationship, subject to lifecycle and data-quality exceptions. |
| `optional` | The attribute applies to the subtype, but a value is not expected for every establishment. |
| `not applicable` | The attribute does not apply to that subtype under the current proposed model. This is different from an applicable value being missing. |
| Blank | No explicit subtype rule is asserted. A blank must not be interpreted automatically as optional or not applicable. The universal rule may apply, evidence may be insufficient, or the attribute may still require review. |

Every type column contains the effective rule after applying the universal baseline and the relevant broader and specialist rule profiles. Blank cells therefore mean that no explicit rule was asserted at any applicable level.

## Methodology

The matrix was produced by:

1. Analysing current GIAS establishment data and establishment types.
2. Sampling representative establishments across populated types.
3. Observing the fields displayed on current public establishment pages.
4. Cross-checking those observations against backend field-to-type configuration and display-policy behaviour.
5. Normalising legacy fields and UI labels into business attributes.
6. Defining shared rule profiles for establishment types with materially similar attribute patterns.
7. Applying the universal, broader and specialist profiles to each numbered establishment type.
8. Recording the resulting effective rule as `required`, `optional` or `not applicable`.
9. Leaving cells blank where no explicit rule was supported at any applicable level.

## Interpretation

The matrix supports data modelling, validation design, API design and business review.

It does not prove that:

- Every required value is populated in current GIAS.
- Every optional attribute is editable by every user.
- A blank means optional.
- Public visibility, editability and applicability are the same rule.
- The shared rule profiles should become physical database entities.

The matrix is iterative and should be refined as business decisions, user-centred design and validation rules mature.
