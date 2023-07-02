locals {
  # This optional suffix is added to the end of resource names.
  suffix                                = length(var.suffix) == 0 ? "" : "-${var.suffix}"
  databricks_metastore_name             = var.custom_databricks_metastore_name == null ? "metastore-${var.env}${local.suffix}" : var.custom_databricks_metastore_name
  databricks_metastore_data_access_name = var.custom_databricks_metastore_data_access_name == null ? "data-access-${var.env}" : var.custom_databricks_metastore_data_access_name
}


resource "databricks_metastore" "this" {
  name          = local.databricks_metastore_name
  storage_root  = var.storage_root
  force_destroy = true
}

resource "databricks_metastore_data_access" "this" {
  metastore_id = databricks_metastore.this.id
  name         = local.databricks_metastore_data_access_name
  is_default   = var.is_data_access_default

  # Azure Access Connector
  dynamic "azure_managed_identity" {
    for_each = var.azure_access_connector_id != null ? [1] : []
    content {
      access_connector_id = var.azure_access_connector_id
    }
  }

  # GCP Service Account
  dynamic "databricks_gcp_service_account" {
    for_each = var.gcp_service_account_email != null ? [1] : []
    content {
      email = var.gcp_service_account_email
    }
  }
}
