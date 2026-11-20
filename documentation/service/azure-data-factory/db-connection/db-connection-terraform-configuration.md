# Illustrative Terraform configuration

**Illustrative specification code only.** These examples describe the intended development-environment resources and configuration. They have not been tested or validated and are not a runnable implementation. DevOps must adapt, complete and test them within the subscription Terraform configuration before use.

Components correspond to the [deployment diagram and component table](deployment-diagram.md).

| Code | Deployment diagram components |
| --- | --- |
| Factory and identity | `s189t01-eprdat-development-adf`; System-assigned identity |
| Managed network and runtime | `default`; `ir-gias-bau-sql-dev` |
| Managed private endpoints | `mpe-epr-dev-key-vault`; `mpe-edubase-dev-sql` |
| Linked services | `ls_epr_key_vault`; `ls_gias_bau_sql_dev` |
| Secret-read role | Key Vault Secrets User |
| Target-side approvals | Key Vault private connection; SQL-side private endpoint approval |
| Password secret | `edubase-dev-adf-automation-sql-password` |

Required inputs: placement, existing vault/server IDs, SQL username and factory public-access setting. Confirm connector properties against the existing definition. Code has not been validated or deployed.

## Inputs

```hcl
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "factory_public_network_enabled" {
  type = bool
}

variable "key_vault_id" {
  type        = string
  description = "Existing s189t01-eprdat-dv-inf-kv resource ID."
}

variable "sql_server_id" {
  type        = string
  description = "Existing s189t01-eprapi-dv-edubase-sql resource ID."
}

variable "sql_username" {
  type        = string
  description = "Confirmed working SQL automation account."
}

variable "sql_password" {
  type        = string
  sensitive   = true
  ephemeral   = true
  description = "Supplied securely by pipeline; must match the existing SQL account."
}

variable "password_update_counter" {
  type        = number
  default     = 1
  description = "Increment when changing the supplied password; not an Azure secret version ID."
}

locals {
  factory_name = "s189t01-eprdat-development-adf"
  secret_name  = "edubase-dev-adf-automation-sql-password"
  vault_uri    = "https://s189t01-eprdat-dv-inf-kv.vault.azure.net/"
}
```

## Factory, identity, network and runtime

The factory creates the `default` managed network. Interactive authoring is disabled; compute and TTL use service defaults.

```hcl
resource "azurerm_data_factory" "connection" {
  name                            = local.factory_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  managed_virtual_network_enabled = true
  public_network_enabled          = var.factory_public_network_enabled
  tags                            = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_factory_integration_runtime_azure" "sql" {
  name                    = "ir-gias-bau-sql-dev"
  data_factory_id         = azurerm_data_factory.connection.id
  location                = var.location
  virtual_network_enabled = true
}

resource "azurerm_data_factory_managed_private_endpoint" "vault" {
  name               = "mpe-epr-dev-key-vault"
  data_factory_id     = azurerm_data_factory.connection.id
  target_resource_id = var.key_vault_id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_managed_private_endpoint" "sql" {
  name               = "mpe-edubase-dev-sql"
  data_factory_id     = azurerm_data_factory.connection.id
  target_resource_id = var.sql_server_id
  subresource_name   = "sqlServer"
}
```

## Secret and factory permission

Supply `sql_password` securely through the pipeline; its value must match the existing SQL account.

Requires write-only secret and ephemeral input support. Increment `password_update_counter` when changing the password; ADF still uses the latest secret version. Supply the password at apply time.

```hcl
resource "azurerm_key_vault_secret" "sql_password" {
  name             = local.secret_name
  key_vault_id     = var.key_vault_id
  value_wo         = var.sql_password
  value_wo_version = var.password_update_counter
  tags             = var.tags
}

resource "azurerm_role_assignment" "factory_secret_reader" {
  name = uuidv5("url", join("|", [
    lower(var.key_vault_id),
    azurerm_data_factory.connection.identity[0].principal_id,
    "Key Vault Secrets User"
  ]))
  scope                            = var.key_vault_id
  role_definition_name             = "Key Vault Secrets User"
  principal_id                     = azurerm_data_factory.connection.identity[0].principal_id
  principal_type                   = "ServicePrincipal"
  skip_service_principal_aad_check = true
}
```

## Linked services

Linked services reference the secret by name; no password value is embedded.

```hcl
resource "azapi_resource" "vault_linked_service" {
  type      = "Microsoft.DataFactory/factories/linkedservices@2018-06-01"
  name      = "ls_epr_key_vault"
  parent_id = azurerm_data_factory.connection.id

  body = {
    properties = {
      type = "AzureKeyVault"
      typeProperties = {
        baseUrl = local.vault_uri
      }
    }
  }

  depends_on = [azurerm_role_assignment.factory_secret_reader]
}

resource "azapi_resource" "sql_linked_service" {
  type      = "Microsoft.DataFactory/factories/linkedservices@2018-06-01"
  name      = "ls_gias_bau_sql_dev"
  parent_id = azurerm_data_factory.connection.id

  body = {
    properties = {
      type        = "AzureSqlDatabase"
      description = "Connects using Keyvault"
      connectVia = {
        referenceName = azurerm_data_factory_integration_runtime_azure.sql.name
        type          = "IntegrationRuntimeReference"
      }
      typeProperties = {
        server                 = "s189t01-eprapi-dv-edubase-sql.database.windows.net"
        database               = "t1dv-edubase"
        authenticationType     = "SQL"
        userName               = var.sql_username
        encrypt                = "mandatory"
        trustServerCertificate = false
        password = {
          type       = "AzureKeyVaultSecret"
          secretName = local.secret_name
          store = {
            referenceName = azapi_resource.vault_linked_service.name
            type          = "LinkedServiceReference"
          }
        }
      }
    }
  }

  depends_on = [azurerm_key_vault_secret.sql_password]
}

output "factory_principal_id" {
  value = azurerm_data_factory.connection.identity[0].principal_id
}

output "managed_private_endpoint_ids" {
  value = {
    vault = azurerm_data_factory_managed_private_endpoint.vault.id
    sql   = azurerm_data_factory_managed_private_endpoint.sql.id
  }
}
```

Always Encrypted is left disabled by omitting its optional configuration. `secretVersion` is omitted.

## Private endpoint approvals

Apply approvals after the managed private endpoints create their target-side connection requests.

Supply the exact new vault-side and SQL-side connection IDs, correlated to this factory's endpoints. These differ from the ADF endpoint IDs. Automated discovery remains pipeline integration work; these blocks only apply approval.

```hcl
variable "vault_connection_id" {
  type        = string
  description = "Exact current Microsoft.KeyVault/vaults/privateEndpointConnections ID."
}

variable "sql_connection_id" {
  type        = string
  description = "Exact current Microsoft.Sql/servers/privateEndpointConnections ID."
}

resource "azapi_update_resource" "vault_approval" {
  type        = "Microsoft.KeyVault/vaults/privateEndpointConnections@2023-07-01"
  resource_id = var.vault_connection_id

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        status          = "Approved"
        description     = "Approved for development ADF Key Vault access"
        actionsRequired = "None"
      }
    }
  }
}

resource "azapi_update_resource" "sql_approval" {
  type        = "Microsoft.Sql/servers/privateEndpointConnections@2023-08-01"
  resource_id = var.sql_connection_id

  body = {
    properties = {
      privateLinkServiceConnectionState = {
        status      = "Approved"
        description = "Approved for development ADF SQL access"
      }
    }
  }
}
```



