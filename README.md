# Azure Databricks Metastore Terraform module
Terraform module for creation of Azure Databricks Metastore

## Usage

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

  env                       = "example"
  storage_root              = "abfss://${data.azurerm_storage_container.example.name}@${data.azurerm_storage_account.example.name}.dfs.core.windows.net/"
  azure_access_connector_id = azurerm_databricks_access_connector.example.id

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
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)          | >= 1.14.2 |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm)          | 1.14.2  |


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env)| Environment name | `string` | n/a | yes |
| <a name="input_storage_root"></a> [storage\_root](#input\_storage\_root)| Path on cloud storage, where managed Unity Catalog Metastore is created | `string` | n/a | yes |
| <a name="input_suffix"></a> [suffix](#input\_suffix)| Optional suffix that would be added to the end of resources names. | `string` | "" | no |
| <a name="input_azure_access_connector_id"></a> [azure\_access\_connector\_id](#input\_azure\_access\_connector\_id)|  Databricks Access Connector Id that lets you to connect managed identities to an Azure Databricks account. Provides an ability to access Unity Catalog with assigned identity | `string` | null | no |
| <a name="input_gcp_service_account_email"></a> [gcp\_service\_account\_email](#input\_gcp\_service\_account\_email)| The email of the GCP service account created, to be granted access to relevant buckets. | `string` | null | no |
| <a name="input_custom_databricks_metastore_name"></a> [custom\_databricks\_metastore\_name](#input\_custom\_databricks\_metastore\_name)| The name to provide for your Databricks Metastore | `string` | null | no |
| <a name="input_custom_databricks_metastore_container_name"></a> [custom\_databricks\_metastore\_container\_name](#input\_custom\_databricks\_metastore\_container\_name)| The name to provide for your Databricks Metastore Container | `string` | null | no |
| <a name="input_custom_databricks_metastore_data_access_name"></a> [custom\_databricks\_metastore\_data_access\_name](#input\_custom\_databricks\_metastore\_data_access\_name)| The name to provide for your Databricks Metastore Data Access Resource | `string` | null | no |
                                                                                                                                                                                                                                                                                                       
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
