# BAU to EPR data platform design

This document describes the target database infrastructure, repository ownership and data flow for private-beta Find and Share. BAU remains the write authority. Its Establishment and Governance data is synchronised into the new domain models, with permitted data published to a separate Read Projection.

## DB topology

Each environment has two Azure Database for PostgreSQL Flexible Server instances in S189. Each environment has its own instances and databases.

| Instance name | Database name | Schemas |
| --- | --- | --- |
| `<subscription-identifier><env-identifier>-pg-epr-transactional` | `establishment` | `establishment` |
| `<subscription-identifier><env-identifier>-pg-epr-transactional`| `governance` | `governance` |
| `<subscription-identifier><env-identifier>-pg-epr-read` | `read_projection` | `establishment`, `governance` |

Database and schema names are identical across environments. The Read Projection is an independent server receiving logical replication, not an Azure physical read replica. The topology contains two instances, without separate replica instances.

Suggested production names:

```text
Subscription:          s189-teacher-services-cloud-production
Resource group:        s189p01-epr-pd-rg
Transactional server:  s189p01-pg-epr-transactional
Read server:           s189p01-pg-epr-read
```

### C4 deployment diagram

The diagram represents one environment. S158 and S189 share the Microsoft Entra tenant **DfE Platform Identity**, with domain `platform.education.gov.uk` (confirmed by the technical architect on 8 October 2026).

```mermaid
%%{init: {"wrap": true, "c4": {"width": 320}}}%%
C4Deployment
title EPR database deployment - one environment

Deployment_Node(tenant, "DfE Platform Identity", "Microsoft Entra tenant") {
    Deployment_Node(subscription, "S189 environment subscription", "Azure subscription") {
        Deployment_Node(resource_group, "<resource-prefix>-<env-short>-rg", "Azure resource group") {
            Deployment_Node(read_server, "[subscription-identifier][env-identifier]-pg-epr-read", "Azure Database for PostgreSQL Flexible Server") {
                ContainerDb(read_db, "read_projection", "PostgreSQL database", "Schemas: establishment and governance")
            }
            Deployment_Node(transactional, "[subscription-identifier][env-identifier]-pg-epr-transactional", "Azure Database for PostgreSQL Flexible Server") {
                ContainerDb(establishment_db, "establishment", "PostgreSQL database", "Schema: establishment")
                ContainerDb(governance_db, "governance", "PostgreSQL database", "Schema: governance")
            }
        }
    }
}

Rel(establishment_db, read_db, "Permitted Establishment data", "Logical replication")
Rel(governance_db, read_db, "Non-PII Governance data", "Logical replication")

UpdateElementStyle(establishment_db, $bgColor="#DBEAFE", $fontColor="#172554", $borderColor="#2563EB")
UpdateElementStyle(governance_db, $bgColor="#EDE9FE", $fontColor="#3B0764", $borderColor="#7C3AED")
UpdateElementStyle(read_db, $bgColor="#DCFCE7", $fontColor="#14532D", $borderColor="#16A34A")
UpdateRelStyle(establishment_db, read_db, $textColor="#1D4ED8", $lineColor="#2563EB", $offsetX="-75", $offsetY="-55")
UpdateRelStyle(governance_db, read_db, $textColor="#6D28D9", $lineColor="#7C3AED", $offsetX="40", $offsetY="0")
UpdateLayoutConfig($c4ShapeInRow="2", $c4BoundaryInRow="2")
```



* DevOps owns the server, database and schema infrastructure. 
* Development teams own the [Establishment](../models/schema/establishment) and [Governance](../models/schema/governance) schema contents and logical replication configuration.
## Git repo structure

Each component repository contains its database Terraform in a top-level `terraform` folder. 
* The Establishment API repository owns the shared transactional server and Establishment database. 
* The Governance API repository owns the Governance database. 
* The web repository owns the Read Projection server and database.

```text
education-provider-registry-establishment-api/
|-- Establishment and Groups API
`-- terraform/
    |-- API infrastructure
    |-- Transactional PostgreSQL server
    |-- establishment database and access permissions
    `-- Transactional server ID and endpoint outputs

education-provider-registry-governance-api/
|-- Governance API
`-- terraform/
    |-- API infrastructure
    `-- governance database and access permissions
        on the Establishment-owned transactional server

education-provider-registry-web/
|-- Web application
`-- terraform/
    |-- Web infrastructure
    |-- Read Projection PostgreSQL server
    `-- read_projection database and access permissions
```


Read Projection Terraform currently lives in `education-provider-registry-data`. It is suggested that this is moved to `education-provider-registry-web`. 

## ETL process

ADF extracts and transforms BAU SQL Server data and loads both transactional databases daily. Native PostgreSQL logical replication copies the permitted base-table subset into the single Read Projection database using two source publications and two destination subscriptions.

```mermaid
flowchart LR
    BAU["BAU Edubase<br/>SQL Server in S189"]
    ADF["Azure Data Factory<br/>Daily extract, transform and load"]

    subgraph TX["Transactional PostgreSQL instance"]
        E[("establishment database<br/>Schema: establishment")]
        G[("governance database<br/>Schema: governance")]
    end

    L["PostgreSQL logical replication<br/>Two publications and subscriptions"]

    subgraph READ["Read Projection PostgreSQL instance"]
        R[("read_projection database<br/>Schemas: establishment and governance")]
    end

    APPS["Web frontend and read APIs<br/>Application-owned read models"]

    BAU --> ADF
    ADF --> E
    ADF --> G
    E -->|Permitted Establishment data| L
    G -->|Non-PII Governance data| L
    L --> R
    R --> APPS

    classDef source fill:#F3F4F6,stroke:#6B7280,color:#111827
    classDef processing fill:#FEF3C7,stroke:#D97706,color:#78350F
    classDef establishment fill:#DBEAFE,stroke:#2563EB,color:#172554
    classDef governance fill:#EDE9FE,stroke:#7C3AED,color:#3B0764
    classDef read fill:#DCFCE7,stroke:#16A34A,color:#14532D
    class BAU source
    class ADF,L processing
    class E establishment
    class G governance
    class R,APPS read
```

The Read Projection contains no Governance PII, including in the initial copy and subsequent replication. The Establishment publication covers the current agreed data scope; extensions are subject to review. The two domains are eventually consistent.

* ETL and replication move domain data; they do not construct application view models. 
* Application teams own read models, indexes and any materialised views. 
* Development teams implement load validation, replication catch-up checks, refresh coordination, retries and reconciliation.
