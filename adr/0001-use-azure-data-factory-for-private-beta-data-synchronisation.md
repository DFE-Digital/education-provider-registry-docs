# ADR 0001: Use Azure Data Factory For Private Beta Data Synchronisation

## Status

Approved

## Date

2026-06-30

## Context

GIAS 2.0 private beta needs data from GIAS BAU so the new service can support read-oriented journeys such as `Find`, `Share`, downloads, authenticated read access and read API access.

The technology plan describes the initial beta data movement position as a controlled projection from the legacy GIAS database into the GIAS 2.0 PostgreSQL read model. It also says data movement must include reconciliation, freshness monitoring and failure handling from the start, and that the implementation should remain replaceable as the service evolves.

The preferred longer-term integration pattern would be a lower-latency change data capture style integration, potentially using Airbyte. However, Airbyte cannot currently be used to connect the CIP environments to the old T1 environments.

Azure Data Factory is already used in BAU to move data between CIP and T1 for data archive purposes. This gives delivery confidence that ADF can operate across the required boundary now, subject to the normal platform, security and operational controls.

The existing S158 Data Factory setup is documented in the GIAS BAU repository: [data-factory-setup.md](https://github.com/DFE-Digital/get-information-about-schools/blob/main/documentation/operations/data-factory-setup.md).

ADF can support a small staleness window through scheduled or incremental movement. It is not expected to reduce data latency enough to satisfy the likely public beta service expectations and SLAs. There is also a high expectation that BAU will be migrated from T1 to CIP by public beta. Once BAU is in CIP, Airbyte or another low-latency CDC-style mechanism may become viable.

## Decision

Use Azure Data Factory to synchronise data from GIAS BAU into the GIAS 2.0 read model for private beta.

This is a tactical private beta integration decision, not the final public beta or live data movement architecture. There are likely review milestones for review if the infrastructure is migrated or the canonical sources of data change.

The ADF implementation must:

- support the private beta read-model load;
- include freshness monitoring, reconciliation and failure visibility;
- avoid exposing the legacy database directly to the GIAS 2.0 frontend, frontend backend API or read API;
- remain replaceable before public beta if the BAU migration into CIP enables a better low-latency integration pattern.

## Options Considered

| Option | Assessment |
| --- | --- |
| Azure Data Factory now | Works with the current T1/CIP constraint and is already proven for BAU archive movement. It can be implemented now and can support private beta. It may not meet future public beta freshness expectations. |
| Airbyte now | Preferred direction for lower-latency CDC-style synchronisation but currently blocked by the shared global scope in the T1 tenancy. |
| Wait for BAU migration into CIP before building synchronisation | Avoids tactical rework, but blocks private beta progress and delays read-model validation. |
| Build a bespoke integration now | Could be tailored to the target model, but would add delivery risk and may duplicate capability that ADF already provides for the current environment constraint. The work would appear to be undifferentiated with little opportunity to return value for being bespoke. |

## Consequences

### Positive

- The team can start private beta data movement now.
- The approach uses a proven data movement capability already operating between CIP and T1 for BAU archive purposes.
- The private beta read model can be populated and tested with realistic source data.
- Reconciliation, freshness monitoring and operational controls can be designed and tested early.
- The decision keeps the integration implementation replaceable rather than making ADF the permanent target architecture.

### Negative

- ADF may need to be replaced before public beta.
- The private beta architecture may carry a known staleness window.
- Read API and frontend users may see data that lags BAU changes unless freshness is made visible and supportable.
- Work invested in ADF mappings, monitoring and support may need to be migrated to Airbyte or another CDC-style mechanism later.
- The portfolio currently has no established ways of working with Azure Data Factories and will need to build infrastructure as code modules for it. There are currently no good ways of managing business continuity for Data Factories shared widely in the Department.

### Mitigations

- Define an explicit private beta freshness target and expose load freshness to support teams.
- Record reconciliation results for each load.
- Keep source-to-target mapping documentation independent of the ADF implementation where practical.
- Review the integration approach before public beta readiness.
- Reassess Airbyte or another CDC-style option once BAU has migrated from T1 into CIP.
