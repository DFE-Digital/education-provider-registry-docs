# 5. Record detailed establishment types and BAU categories

Date: 6 November 2026

Status: Accepted

## Context

Administrative users and downstream consumers need the detailed DfE establishment types and their published codes. Folding academy converter and sponsor-led types into a single stored type loses a distinction required by existing processes.

The conceptual model has five academy types and a separate academy route. Category grouping is business policy. We will retain BAU's existing categorisation while that policy remains undecided, rather than decide new groupings through the data structure.

## Decision

- Each establishment references a detailed `establishment_type` using a UUID.
- Each type has a required unique published DfE `code`, stored as text, and a name. Migration resolves the UUID by code, independently of the source label.
- Each type references one required `establishment_type_category`, using a UUID. Categories follow the eleven BAU `EstablishmentTypeGroup` names and memberships.
- A category contains only its UUID and required unique name. BAU group codes are used during migration; category code, archived status and canonical identifier are not target attributes.
- The detailed type supplies an academy route where applicable. Route contains only its existing integer key and unique name. Category and route are not stored separately on the establishment.
- The conceptual model remains unchanged. Detailed type code determines the conceptual academy type; the broad category Academies does not replace that projection.

All nine detailed academy types belong to Academies. Their eight converter and sponsor-led variants have the specified route; Academy secure 16 to 19 has no route. Special free schools, UTCs and studio schools remain in Free Schools, following BAU.

## Consequences

Detailed administrative classifications and published codes survive migration. UUID keys remain independent of business codes. Search can use the shared BAU category field, while a search spanning special provision needs to consider more than one category.

Changing BAU's categorisation is a future business policy decision. The WIP model is updated by rewriting schemas, seeds and dependent checks and rebuilding the local target. Existing numeric type IDs are not preserved.

See the [logical model](../models/logical/establishment/identity-and-classification.md#establishment-type) and [physical schema](../models/schema/establishment/establishment-schema.sql).
