# Reviewed proprietor decisions

Stage 4 supports `mode: reviewed-legal-entity` in both proprietor loaders. Existing T9, T10, T13 and T21 decisions retain their established contracts. New decisions require explicit review before target facts are loaded. A pending decision is retained in `migration.proprietor_review` without allocating a target identity.

| Field | Meaning |
| --- | --- |
| `decisionId`, `reviewStatus`, `reviewEvidence` | Stable decision key, accepted or pending status, and the actual review evidence. An accepted payload is immutable; changed accepted inputs require correction rather than silent replacement. |
| `legalEntityId`, `name`, `legalEntityTypeId` | Reviewed target UUID, selected name and legal form. IDs are reused across schools. Name collisions and changed forms are rejected. |
| `proprietorKind` | `Individual`, `Body` or `Partnership`. Individual means Sole trader (11); Partnership means Traditional partnership (12). LLPs use Body (5). |
| `individualIdentityKey`, `acceptedNameKind` | For an individual, a reviewed identity key and the evidenced choice of `trading_name` or `personal_name`. These are not anonymous person records. |
| `source` | Source `system`, optional `database`, `table`, `key`, optional known `observedDate`, and `observedValues`. Preserve observed strings separately from accepted names and classification. Unknown observation dates remain unknown. |
| `schools` | Each assertion supplies `urn`, stable `responsibilityId`, explicit `isCurrent` and any known `startDate` and `endDate`. A closed school cannot gain a current proprietor. Current school types must be eligible for a proprietor. |
| `expectedLocalContext` | Exact captured context rows, in URN order, using the chosen loader's transform column names. Obfuscated BAU context is checked and retained as context; it is not promoted to identity evidence. |
| `addresses` | Each block has `factKey`, its own `source`, explicit reviewed `purpose`, `reviewEvidence`, stable `addressId` and `linkId`, and known address components. Unknown purposes remain staged; they do not become registered offices by default. |
| `identifiers` | Explicit type and value, `verified`, `verificationEvidence` and its own `source`. Unverified values remain staged. Verified LLP company numbers retain the OC, SO or NC prefix supplied by registration evidence. |
| `contactObservations` | Preserved as source evidence with a pending target association until the legal-entity contact slice. |

Controlled BAU automation also checks each school's public-extract `name`, `propsName`, `sourceEstablishmentType` and `sourceStatus`. The full source record and accepted decision support the identity, responsibility and selected facts through `proprietor_fact_evidence` and the existing migration evidence structures.

No loader creates people, trader-person links or partner-person links. A sole trader can hold its proprietor responsibility and reviewed business address with no known person link. Traditional partnerships may have no evidenced partner links; the validator reports fewer than two distinct current partners as a warning. Additional-proprietor slots and contacts do not establish partner identity. Unincorporated trusts remain legal entities; trustees and unsupported partnership jurisdictions require later work.

The four LLP source cases are explicitly pending in [the review seed](../seed/seed-stage-4-proprietor-review.sql). Their names do not supply verified company numbers. The closed Castles case remains closed in the review input. No operational target identity is invented to make this queue empty.
