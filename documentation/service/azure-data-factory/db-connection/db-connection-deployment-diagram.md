# C4 deployment diagram: development ADF connection

This specification describes the development environment only, centred on Data Factory `s189t01-eprdat-development-adf`. The resource names and configuration shown apply to development; test and production environments are outside this specification. Linked services and identity are configuration attached to the factory; the integration runtime and private endpoints belong to its managed network. Secret and linked-service instances are shown to expose configuration relationships.

## Component key

```mermaid
C4Deployment

    Container(keyAdf, "ADF configuration", "", "Identity and linked services")
    Container(keyNetwork, "Runtime and networking", "", "Integration runtime and managed private endpoints")
    Container(keyVault, "Key Vault", "", "Secret, role assignment and connection approval")
    Container(keySql, "Azure SQL", "", "Database and connection approval")

    UpdateElementStyle(keyAdf, $bgColor="#DBEAFE", $fontColor="#172554", $borderColor="#2563EB")
    UpdateElementStyle(keyNetwork, $bgColor="#CCFBF1", $fontColor="#134E4A", $borderColor="#0D9488")
    UpdateElementStyle(keyVault, $bgColor="#FEF3C7", $fontColor="#78350F", $borderColor="#D97706")
    UpdateElementStyle(keySql, $bgColor="#EDE9FE", $fontColor="#4C1D95", $borderColor="#7C3AED")
    UpdateLayoutConfig($c4ShapeInRow="4", $c4BoundaryInRow="1")
```
## Development ADF connection - target deployment

```mermaid
C4Deployment


    UpdateLayoutConfig($c4ShapeInRow="1", $c4BoundaryInRow="2")
    Deployment_Node(azure, "Microsoft Azure", "Development environment") {
        Deployment_Node(factory, "s189t01-eprdat-development-adf", "Azure Data Factory V2") {
            Container(identity, "System-assigned identity", "Microsoft Entra managed identity", "Principal ID generated with factory")
            Container(kvLs, "ls_epr_key_vault", "AzureKeyVault linked service", "Vault URI; system-assigned identity")
            Container(sqlLs, "ls_gias_bau_sql_dev", "AzureSqlDatabase linked service", "SQL account authentication; Key Vault password reference")

            Deployment_Node(mnet, "default", "ADF managed virtual network") {
                Container(runtime, "ir-gias-bau-sql-dev", "Managed Azure integration runtime", "Executes SQL connection")
                Container(kvPe, "mpe-epr-dev-key-vault", "Managed private endpoint", "Group vault; proposed connection")
                Container(sqlPe, "mpe-edubase-dev-sql", "Managed private endpoint", "Group sqlServer")
            }
        }
        Deployment_Node(vault, "s189t01-eprdat-dv-inf-kv", "Existing Azure Key Vault; Azure RBAC") {
            Container(grant, "Key Vault Secrets User", "Azure role assignment", "Scope: vault; principal: current factory identity")
            Container(secret, "edubase-dev-adf-automation-sql-password", "Key Vault secret", "Created/populated by deployment; latest version")

            Container(kvApproval, "Key Vault private connection", "Target-side approval", "Approved; correlated to new Key Vault endpoint")
        }
        Deployment_Node(sqlServer, "s189t01-eprapi-dv-edubase-sql", "Existing Azure SQL logical server") {
            Container(sqlApproval, "SQL-side private endpoint approval", "Target-side approval", "Manually approved by user; automate for recreated endpoint")
            ContainerDb(database, "t1dv-edubase", "Azure SQL Database", "Existing read-only secondary and SQL automation account")
        }
    }

    Rel(sqlLs, kvLs, "Password store")
    Rel(sqlLs, runtime, "connectVia")
    Rel(kvLs, identity, "Authenticates as")
    Rel(identity, grant, "Secret-read permission")
    Rel(kvLs, secret, "Latest secret", "Logical reference")
    Rel(runtime, kvPe, "Get password", "HTTPS")
    Rel(kvPe, kvApproval, "Private Link connection")
    Rel(runtime, sqlPe, "SQL authentication", "TDS over TLS")
    Rel(kvApproval, secret, "Vault access", "HTTPS 443")
    Rel(sqlPe, sqlApproval, "Private Link connection")
    Rel(sqlApproval, database, "Database access", "TDS over TLS")

    UpdateRelStyle(sqlLs, kvLs, $offsetX="5", $offsetY="20")
    UpdateRelStyle(sqlLs, runtime, $offsetX="-5", $offsetY="-90")
    UpdateRelStyle(kvLs, identity, $offsetX="5", $offsetY="30")
    UpdateRelStyle(identity, grant, $offsetX="-110", $offsetY="-25")
    UpdateRelStyle(kvLs, secret, $offsetX="-110", $offsetY="-30")
    UpdateRelStyle(runtime, kvPe, $offsetX="-95", $offsetY="10")    
    UpdateRelStyle(runtime, sqlPe, $offsetX="5", $offsetY="110")
    UpdateRelStyle(kvPe, kvApproval, $offsetX="60", $offsetY="-90")
    UpdateRelStyle(kvApproval, secret, $offsetX="10", $offsetY="0")

    UpdateRelStyle(sqlPe, sqlApproval, $offsetX="-10", $offsetY="130")
    UpdateRelStyle(sqlApproval, database, $offsetX="5", $offsetY="10")

    UpdateElementStyle(identity, $bgColor="#DBEAFE", $fontColor="#172554", $borderColor="#2563EB")
    UpdateElementStyle(sqlLs, $bgColor="#DBEAFE", $fontColor="#172554", $borderColor="#2563EB")
    UpdateElementStyle(kvLs, $bgColor="#DBEAFE", $fontColor="#172554", $borderColor="#2563EB")
    UpdateElementStyle(runtime, $bgColor="#CCFBF1", $fontColor="#134E4A", $borderColor="#0D9488")
    UpdateElementStyle(kvPe, $bgColor="#CCFBF1", $fontColor="#134E4A", $borderColor="#0D9488")
    UpdateElementStyle(sqlPe, $bgColor="#CCFBF1", $fontColor="#134E4A", $borderColor="#0D9488")
    UpdateElementStyle(secret, $bgColor="#FEF3C7", $fontColor="#78350F", $borderColor="#D97706")
    UpdateElementStyle(grant, $bgColor="#FEF3C7", $fontColor="#78350F", $borderColor="#D97706")
    UpdateElementStyle(kvApproval, $bgColor="#FEF3C7", $fontColor="#78350F", $borderColor="#D97706")
    UpdateElementStyle(database, $bgColor="#EDE9FE", $fontColor="#4C1D95", $borderColor="#7C3AED")
    UpdateElementStyle(sqlApproval, $bgColor="#EDE9FE", $fontColor="#4C1D95", $borderColor="#7C3AED")
```


## Components

| Component | Azure resource type | Description and deployment requirement |
| --- | --- | --- |
| `s189t01-eprdat-development-adf` | Data Factory | Hosts the linked services, system-assigned identity and managed network. Recreate through the subscription Terraform deployment. |
| System-assigned identity | System-assigned managed identity | Generated with the factory. Use its current principal ID for secret-read permission after every recreation. |
| `ls_gias_bau_sql_dev` | Linked service | SQL authentication to `t1dv-edubase`; uses `ir-gias-bau-sql-dev` and references the password through `ls_epr_key_vault`. |
| `ls_epr_key_vault` | Linked service | References the existing vault URI and authenticates using the factory's system-assigned identity. |
| `default` | Managed virtual network | Contains the integration runtime and managed private endpoints; managed by ADF. |
| `ir-gias-bau-sql-dev` | Integration runtime | Executes the database connection inside the ADF managed network. |
| `mpe-epr-dev-key-vault` | Managed private endpoint | Private connection to the existing vault, group ID `vault`. Proposed target configuration. Requires matching vault-side approval. |
| `mpe-edubase-dev-sql` | Managed private endpoint | Private connection to the SQL logical server, group ID `sqlServer`. Creates the SQL-side request described below. |
| `s189t01-eprdat-dv-inf-kv` | Key Vault | Stores the SQL password secret and uses Azure RBAC. Vault creation remains outside this specification. |
| `edubase-dev-adf-automation-sql-password` | Key Vault secret | Create/populate through the deployment with a protected password input matching the SQL account. ADF references the latest version; omit `secretVersion`. |
| Key Vault Secrets User | Role assignment | Grants the current factory identity secret-read permission at vault scope. Recreate the assignment for the new principal ID. |
| Key Vault private connection | Private endpoint connection | Automatically requested by the vault managed private endpoint. Deployment must identify and approve the matching request using an authorised identity. |
| `s189t01-eprapi-dv-edubase-sql` | SQL server | Hosts the source database and the SQL-side private endpoint connection. Server creation remains outside this specification. |
| `t1dv-edubase` | SQL database | Read-only secondary accessed using the existing SQL automation account. Database and account creation remain outside this specification. |
| SQL-side private endpoint approval | Private endpoint connection | Creating `mpe-edubase-dev-sql` in ADF automatically creates a private endpoint connection request on the SQL server. This is the SQL side of the same private connection, not a separately created endpoint. You manually approved the original request. After recreation, the deployment must identify and approve the new matching request using an identity with approval permissions on the SQL server. The connection must be Approved before ADF can use it. |








