# Reviewed council reorganisations

Stage 5 applies an accepted event atomically, retaining council and maintenance history. The [event SQL](council-reorganisation.sql) owns the ledger and transition. The PowerShell entry point is `automation/apply-reviewed-council-reorganisation.ps1 -DecisionFile <reviewed-json-path>`, run against the guarded local target.

| Payload field | Requirement |
| --- | --- |
| `eventId` | Stable event key. The same key and canonical JSON payload is a no-op after application. A different payload using that key fails. |
| `reviewStatus`, `evidence` | Explicit `accepted` status and the actual decision/source evidence. Unaccepted events are retained for review. |
| `effectiveDate` | Evidenced vesting date. A future event remains pending; resubmit the same payload once effective. Out-of-order or history-rewriting changes remain for explicit correction. |
| `source` | `system`, optional `database`, `table`, `key`, known `observedDate` and `observedValues`. Observation and business effect are separate dates. |
| `oldPeriods` | Previous `periodId` and `expectedCouncilId` for each affected area. They must resolve to the expected current periods. |
| `successors` | Explicit new `periodId`, `areaId` and `councilId`. One current successor per area. |
| `newCouncils` | Where required, reviewed `legalEntityId`, `name` and any known `incorporationDate` or `dissolutionDate`. An existing council is reused; the event cannot rename it or change its legal form. |
| `newAreas` | For new DfE codes, explicit `areaId`, `code`, `name` and `jurisdictionId`. Unknown additional geography stays unknown. Every supplied council and area must participate in a successor mapping. |
| `schoolMappings` | For splits or mergers, one `urn` and new `areaId` for every establishment in the affected source areas. Missing, duplicated or unrelated allocations fail. Retained-code events use the unique same-area successor. |

Example payload structure, using placeholder UUIDs that must be replaced with the reviewed target identities:

```json
{
  "eventId": "reviewed-event-reference",
  "reviewStatus": "pending",
  "effectiveDate": "2027-04-01",
  "evidence": "Replace with the source and accepted decision",
  "source": {
    "system": "Reviewed source",
    "table": "Decision or statutory source",
    "key": "Source reference",
    "observedDate": "2026-11-02",
    "observedValues": { "effectiveDate": "2027-04-01" }
  },
  "oldPeriods": [{
    "periodId": "00000000-0000-0000-0000-000000000001",
    "expectedCouncilId": "00000000-0000-0000-0000-000000000002"
  }],
  "successors": [{
    "periodId": "00000000-0000-0000-0000-000000000003",
    "areaId": "00000000-0000-0000-0000-000000000004",
    "councilId": "00000000-0000-0000-0000-000000000005"
  }]
}
```

The operation serializes with maintenance derivation using the same transaction lock, then locks affected areas, council identities and establishments in consistent order. It ends current old council periods, creates successor periods, applies reviewed geography and transfers active English maintenance on vesting day. Old maintenance receives an evidenced end; observation dates and source evidence are retained. Academies, independent schools, Welsh-coded schools and schools already closed on that date receive no new maintenance. A backdated change intersecting later or unresolved historical assertions is staged for explicit correction. Cross-jurisdiction changes require separate policy review.

`council_reorganisation` stores the canonical payload hash, evidence, dates and application status. `council_reorganisation_lineage` records the old and resulting rows, including generated responsibility identities. A failed operation rolls back both ledger and business changes. Pending and review events have no resulting business lineage.

Ordinary establishment and maintenance loads consult the ledger. Older or equally dated observations cannot move geography back or reopen old maintenance. Conflicting newer observations remain in `council_replay_observation` for review. Matching newer maintenance observations can supply an earlier supporting observation without duplicating the reviewed transition. Council-seed replay accepts only changes explained by applied event lineage and leaves those periods intact. Population validators include areas, councils and periods introduced by those events.

The destructive rebuild preflight rejects a nonempty event ledger. Preserve/export the ledger and use additive replay rather than resetting reviewed history. A fresh initial build with no event ledger remains supported. This work supplies no automatic scheduler or invented live reorganisation event.

Run [the read-only Stage 5 validator](validate-scripts/validate-council-reorganisations-stage-5.sql), together with the maintenance and area/council checks, after application. The [rollback regressions](validate-scripts/validate-council-reorganisation-regressions.sql) cover retained codes, reviewed splits, exclusions, event identity, chronology, atomic rollback, older and newer source replay and earliest supporting observations.
