# BAU to EPR data platform design

This document describes the target database infrastructure, repository ownership and data flow for private-beta Find and Share. BAU remains the write authority. Its Establishment and Governance data is synchronised into the new domain models, with permitted data published to a separate Read Projection.

## DB topology

Each environment has two DB server instances in S189, using Azure Database for PostgreSQL Flexible Server. Each environment has its own DB server instances and databases.

| DB server instance name | Database name | Schemas |
| --- | --- | --- |
| `<subscription-identifier><env-identifier>-pg-epr-transactional` | `establishment` | `establishment` |
| `<subscription-identifier><env-identifier>-pg-epr-transactional`| `governance` | `governance` |
| `<subscription-identifier><env-identifier>-pg-epr-read` | `read_projection` | `establishment`, `governance` |

Database and schema names are identical across environments. The Read Projection is an independent DB server instance receiving logical replication, not an Azure physical read replica. The topology contains two DB server instances, without additional replica DB server instances.

### Separate DB server instances for separate security zones

Establishment and Governance share the transactional DB server instance because both transactional databases are in the same security zone. The Read Projection has its own DB server instance so that its network access can be controlled independently of the transactional data.

Network controls apply to the DB server instance endpoint, not to individual databases or schemas inside that DB server instance. Separate databases provide logical separation and database permissions, but cannot provide independent network isolation. Hosting the Read Projection on the transactional DB server instance would therefore expose the same endpoint to both transactional clients and read consumers.

The separate read DB server instance enables the required isolation; subnet and network rules enforce it. Read consumers must reach only the read DB server instance. Transactional access is restricted to approved domain services, ETL, administration and the replication connection. Database roles and grants still restrict access within each DB server instance.

These are target security requirements. The network controls needed to enforce them are not yet implemented.

### Infrastructure requirements and practices

* The current Terraform approach provisions DB server instances and databases; schema creation is expected to remain application-owned, as in the existing services. Existing PostgreSQL applications commonly use the `public` schema. The named `establishment` and `governance` schemas in this design remain the proposed target and must be created and maintained through application database migrations.
* Each AKS cluster currently has a single `postgres-subnet`. A separate subnet for the read DB server instance can be tested, but has not yet been established as a supported deployment pattern.
* AKS network security is not yet configured. A spike is planned, and the eventual security solution will follow its outcome. Implementation is expected to be at least a few months away; this is an indicative dependency, not a committed delivery date.

The two-DB-server-instance topology remains the target. Its network-isolation implementation depends on the separate-subnet test and AKS network-security work. Provisioning the DB server instances alone does not demonstrate that the required isolation has been achieved.

### Recommended network layout

The proposed target is a separate subnet and network security group (NSG) for each DB server instance, subject to the infrastructure team's subnet test and network-security spike. The diagram uses private access through VNet integration, with both database subnets delegated to `Microsoft.DBforPostgreSQL/flexibleServers`. There is no public database endpoint in this proposed layout. Private DNS and explicit NSG rules must allow the approved clients and deny unapproved traffic between security zones, including overriding Azure's default allowance for traffic within the VNet. Separate subnets alone do not isolate the DB server instances. The final controls and AKS-to-database access rules will be agreed from the spike's findings.




Suggested production names:

```text
Subscription:                       s189-teacher-services-cloud-production
Resource group:                     s189p01-epr-pd-rg
Transactional DB server instance:   s189p01-pg-epr-transactional
Read DB server instance:            s189p01-pg-epr-read
```

### C4 deployment diagram

The diagram represents one environment and the proposed VNet-integration layout, not the current deployment. Subnet names are descriptive placeholders. The separate read subnet is subject to testing, and the security controls are subject to the AKS network-security spike.

```mermaid
%%{init: {"wrap": true, "c4": {"width": 320}}}%%
C4Deployment
title EPR database deployment - one environment

Deployment_Node(tenant, "DfE Platform Identity", "Microsoft Entra tenant") {
    Deployment_Node(subscription, "S189 environment subscription", "Azure subscription") {
        Deployment_Node(vnet, "Environment VNet", "Azure virtual network") {
            Deployment_Node(read_subnet, "Read database subnet (proposed)", "Delegated PostgreSQL subnet", "Separate-subnet test pending; dedicated NSG proposed") {
                Deployment_Node(read_server, "[subscription-identifier][env-identifier]-pg-epr-read", "DB server instance", "Azure Database for PostgreSQL Flexible Server") {
                    ContainerDb(read_db, "read_projection", "PostgreSQL database", "Schemas: establishment and governance")
                }
            }
            Deployment_Node(transactional_subnet, "Transactional database subnet", "Delegated PostgreSQL subnet", "Transactional security zone; NSG controls pending spike") {
                Deployment_Node(transactional, "[subscription-identifier][env-identifier]-pg-epr-transactional", "DB server instance", "Azure Database for PostgreSQL Flexible Server") {
                    ContainerDb(establishment_db, "establishment", "PostgreSQL database", "Schema: establishment")
                    ContainerDb(governance_db, "governance", "PostgreSQL database", "Schema: governance")
                }
            }
        }
    }
}

Rel(establishment_db, read_db, "Permitted Establishment data", "Logical replication")
Rel(governance_db, read_db, "Non-PII Governance data", "Logical replication")

%% Relationships show data flow. The subscriber initiates the network connection to the publisher.

UpdateElementStyle(establishment_db, $bgColor="#DBEAFE", $fontColor="#172554", $borderColor="#2563EB")
UpdateElementStyle(governance_db, $bgColor="#EDE9FE", $fontColor="#3B0764", $borderColor="#7C3AED")
UpdateElementStyle(read_db, $bgColor="#DCFCE7", $fontColor="#14532D", $borderColor="#16A34A")
UpdateRelStyle(establishment_db, read_db, $textColor="#1D4ED8", $lineColor="#2563EB", $offsetX="-75", $offsetY="-55")
UpdateRelStyle(governance_db, read_db, $textColor="#6D28D9", $lineColor="#7C3AED", $offsetX="40", $offsetY="0")
UpdateLayoutConfig($c4ShapeInRow="2", $c4BoundaryInRow="2")
```



* DevOps owns the DB server instance and database infrastructure, together with network provisioning and controls agreed through the infrastructure work.
* Development teams create and maintain the [Establishment](../models/schema/establishment) and [Governance](../models/schema/governance) schemas and their contents through application database migrations. They also own logical replication configuration and the required schemas and tables in the Read Projection database.
## Git repo structure

Each component repository contains its database Terraform in a top-level `terraform` folder. 
* The Establishment API repository owns the shared transactional DB server instance and Establishment database.
* The Governance API repository owns the Governance database. 
* The web repository owns the Read Projection DB server instance and database.

```text
education-provider-registry-establishment-api/
|-- Establishment and Groups API
`-- terraform/
    |-- API infrastructure
    |-- Transactional DB server instance
    |-- establishment database and access permissions
    `-- Transactional DB server instance ID and endpoint outputs

education-provider-registry-governance-api/
|-- Governance API
`-- terraform/
    |-- API infrastructure
    `-- governance database and access permissions
        on the Establishment-owned transactional DB server instance

education-provider-registry-web/
|-- Web application
`-- terraform/
    |-- Web infrastructure
    |-- Read Projection DB server instance
    `-- read_projection database and access permissions
```


Read Projection Terraform currently lives in `education-provider-registry-data`. It is suggested that this is moved to `education-provider-registry-web`. 

## ETL process

ADF extracts and transforms BAU SQL Server data and loads both transactional databases daily. Native PostgreSQL logical replication copies the permitted base-table subset into the single Read Projection database using two source publications and two destination subscriptions.

```mermaid
flowchart LR
    BAU["BAU Edubase<br/>SQL Server in S189"]
    ADF["Azure Data Factory<br/>Daily extract, transform and load"]

    subgraph TX["Transactional DB server instance"]
        E[("establishment database<br/>Schema: establishment")]
        G[("governance database<br/>Schema: governance")]
    end

    L["PostgreSQL logical replication<br/>Two publications and subscriptions"]

    subgraph READ["Read Projection DB server instance"]
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
