# Databricks Unity Catalog Metastore Terraform module
Terraform module for creation of Databricks Unity Catalog Metastore

## Usage

This module provides an ability to provision Databricks Unity Catalog Metastore and configure default access credentials. 
Below you can find examples of Account and Workspace level APIs configuration.

#### Account-level API provider authorization example (recommended).
```hcl
# Prerequisite resources
variable "databricks_account_id" {}

# Databricks Access Connector (managed identity)
resource "azurerm_databricks_access_connector" "example" {
  name                = "example-resource"
  resource_group_name = "example-rg"
  location            = "eastus"

  identity {
    type = "SystemAssigned"
  }
}

# Storage Account
data "azurerm_storage_account" "example" {
  name                = "example-storage-account"
  resource_group_name = "example-rg"
}

# Container
data "azurerm_storage_container" "example" {
  name                 = "example-container-name"
  storage_account_name = data.azurerm_storage_account.example.name
}

# Configure Databricks Provider
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.azuredatabricks.net"
  account_id = var.databricks_account_id
}

# Metastore creation
module "metastore" {
  source  = "data-platform-hq/metastore/databricks"
  version = "~> 1.0.0"

  env                                               = "example"
  region                                            = "eastus" # required if using account-level api
  storage_root                                      = "abfss://${data.azurerm_storage_container.example.name}@${data.azurerm_storage_account.example.name}.dfs.core.windows.net/"
  azure_access_connector_id                         = azurerm_databricks_access_connector.example.id
  delta_sharing_scope                               = "INTERNAL_AND_EXTERNAL"
  delta_sharing_recipient_token_lifetime_in_seconds = 0 # token is infinite

  providers = {
    databricks = databricks.account
  }
}

```
<br>

#### Workspace-level API provider authorization.

```hcl
# Prerequisite resources
# Databricks Access Connector (managed identity)
resource "azurerm_databricks_access_connector" "example" {
  name                = "example-resource"
  resource_group_name = "example-rg"
  location            = "eastus"

  identity {
    type = "SystemAssigned"
  }
}

# Storage Account
data "azurerm_storage_account" "example" {
  name                = "example-storage-account"
  resource_group_name = "example-rg"
}

# Container
data "azurerm_storage_container" "example" {
  name                 = "example-container-name"
  storage_account_name = data.azurerm_storage_account.example.name
}

# Configure Databricks Provider
data "azurerm_databricks_workspace" "example" {
  name                = "example-workspace"
  resource_group_name = "example-rg"
}

provider "databricks" {
  alias                       = "workspace"
  host                        = data.databricks_workspace.example.workspace_url
  azure_workspace_resource_id = data.databricks_workspace.example.id
}

# Metastore creation
module "metastore" {
  source  = "data-platform-hq/metastore/databricks"
  version = "~> 1.0.0"

  env                                               = "example"
  storage_root                                      = "abfss://${data.azurerm_storage_container.example.name}@${data.azurerm_storage_account.example.name}.dfs.core.windows.net/"
  azure_access_connector_id                         = azurerm_databricks_access_connector.example.id
  delta_sharing_scope                               = "INTERNAL_AND_EXTERNAL"
  delta_sharing_recipient_token_lifetime_in_seconds = 0 # token is infinite

  providers = {
    databricks = databricks.workspace
  }
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                         | Version   |
| ---------------------------------------------------------------------------- | --------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | >= 1.0.0  |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.24.1 |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | 1.24.1  |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env)| Environment name | `string` | n/a | yes |
| <a name="input_storage_root"></a> [storage\_root](#input\_storage\_root)| Path on cloud storage, where managed Unity Catalog Metastore is created | `string` | n/a | yes |
| <a name="input_suffix"></a> [suffix](#input\_suffix)| Optional suffix that would be added to the end of resources names. | `string` | "" | no |
| <a name="input_delta_sharing_scope"></a> [delta\_sharing\_scope](#input\_delta\_sharing\_scope)| Used to enable delta sharing on the metastore. Valid values: INTERNAL, INTERNAL_AND_EXTERNAL. | `string` | "INTERNAL" | no |
| <a name="input_delta_sharing_recipient_token_lifetime_in_seconds"></a> [delta\_sharing\_recipient\_token\_lifetime\_in\_seconds](#input\_delta\_sharing\_recipient\_token\_lifetime\_in\_seconds)| Used to set expiration duration in seconds on recipient data access tokens. Set to 0 for unlimited duration. | `string` | 0 | no |
| <a name="input_is_data_access_default"></a> [is\_data\_access\_default](#input\_is\_data\_access\_default)| Are Data Access Storage Credentials default for assigned Metastore? | `string` | true | no |
| <a name="input_azure_access_connector_id"></a> [azure\_access\_connector\_id](#input\_azure\_access\_connector\_id)|  Databricks Access Connector Id that lets you to connect managed identities to an Azure Databricks account. Provides an ability to access Unity Catalog with assigned identity | `string` | null | no |
| <a name="input_gcp_service_account_email"></a> [gcp\_service\_account\_email](#input\_gcp\_service\_account\_email)| The email of the GCP service account created, to be granted access to relevant buckets. | `string` | null | no |
| <a name="input_custom_databricks_metastore_name"></a> [custom\_databricks\_metastore\_name](#input\_custom\_databricks\_metastore\_name)| The name to provide for your Databricks Metastore | `string` | null | no |
| <a name="input_custom_databricks_metastore_data_access_name"></a> [custom\_databricks\_metastore\_data_access\_name](#input\_custom\_databricks\_metastore\_data_access\_name)| The name to provide for your Databricks Metastore Data Access Resource | `string` | null | no |
| <a name="input_region"></a> [region](#input\_region)| Required when using Account level API provider authorization. The region of metastore | `string` | null | no |
| <a name="input_credentials_type"></a> [credentials\_type](#input\_credentials\_type)| Cloud provider | `string` | null | no |
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn)| The Amazon Resource Name, of the AWS IAM role for S3 data access | `string` | null | no |
                                                                                                                                                                                                                                                                                              
## Modules

No modules.

## Resources

| Name                                                                                                                                                                | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [databricks_metastore.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore)                                          | resource |
| [databricks_metastore_data_access.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/metastore_data_access)                  | resource |


## Outputs

| Name                                                                                                                          | Description                                          |
| ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| <a name="output_metastore_id"></a> [metastore\_id](#output\_metastore\_id) | Unity Catalog Metastore Id |
| <a name="output_metastore_name"></a> [metastore_name](#output\_metastore_name) | Unity Catalog Metastore name |

<!-- END_TF_DOCS -->

## License

Apache 2 Licensed. For more information please see [LICENSE](https://github.com/data-platform-hq/terraform-databricks-metastore/blob/add_metastore/LICENSE)
