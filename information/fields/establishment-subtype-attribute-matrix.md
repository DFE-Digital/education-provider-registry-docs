# Establishment Subtype Attribute Matrix

[Download the establishment subtype attribute matrix (CSV)](./establishment-subtype-attribute-matrix.csv)

## Purpose

The establishment subtype attribute matrix describes how establishment attributes vary across broad establishment subtypes.

It answers:

> For each establishment subtype, is this attribute required, optional, not applicable, or not yet explicitly classified?

The matrix is a modelling artefact, not a direct database export or physical database design.

## What It Contains

The matrix contains:

- 58 attributes.
- A universal establishment baseline.
- 28 subtype or subtype-group columns.
- Individual attributes, relationships and grouped business concepts.

The subtype columns consolidate establishment types that have similar attribute requirements. Specialist subtypes remain separate where their requirements differ materially.

## Cell Meanings

| Value | Meaning |
| --- | --- |
| `required` | The attribute is expected for that subtype under the current proposed rule set. A future validation design would normally require a value or relationship, subject to lifecycle and data-quality exceptions. |
| `optional` | The attribute applies to the subtype, but a value is not expected for every establishment. |
| `not applicable` | The attribute does not apply to that subtype under the current proposed model. This is different from an applicable value being missing. |
| Blank | No explicit subtype rule is asserted. A blank must not be interpreted automatically as optional or not applicable. The universal rule may apply, evidence may be insufficient, or the attribute may still require review. |

The `Universal establishment` column is the baseline. Subtype columns add or refine rules where an attribute varies by subtype.

## Methodology

The matrix was produced by:

1. Analysing current GIAS establishment data and establishment types.
2. Sampling representative establishments across populated types.
3. Observing the fields displayed on current public establishment pages.
4. Cross-checking those observations against backend field-to-type configuration and display-policy behaviour.
5. Normalising legacy fields and UI labels into business attributes.
6. Grouping establishment types with materially similar attribute patterns.
7. Recording explicit applicability rules as `required`, `optional` or `not applicable`.
8. Leaving cells blank where no explicit rule was supported.

## Interpretation

The matrix supports data modelling, validation design, API design and business review.

It does not prove that:

- Every required value is populated in current GIAS.
- Every optional attribute is editable by every user.
- A blank means optional.
- Public visibility, editability and applicability are the same rule.
- The subtype groups should become physical database entities.

The matrix is iterative and should be refined as business decisions, user-centred design and validation rules mature.
