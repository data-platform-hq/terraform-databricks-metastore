locals {
  # This optional suffix is added to the end of resource names.
  suffix                                = length(var.suffix) == 0 ? "" : "-${var.suffix}"
  databricks_metastore_name             = var.custom_databricks_metastore_name == null ? "metastore-${var.env}${local.suffix}" : var.custom_databricks_metastore_name
  databricks_metastore_data_access_name = var.custom_databricks_metastore_data_access_name == null ? "data-access-${var.env}" : var.custom_databricks_metastore_data_access_name
}

resource "databricks_metastore" "this" {
  name                                              = local.databricks_metastore_name
  storage_root                                      = var.storage_root
  delta_sharing_scope                               = var.delta_sharing_scope
  delta_sharing_recipient_token_lifetime_in_seconds = var.delta_sharing_recipient_token_lifetime_in_seconds
  force_destroy                                     = true
  region                                            = var.region
}

resource "databricks_metastore_data_access" "this" {
  count = length(var.credentials_type) != 0 ? 1 : 0

  metastore_id = databricks_metastore.this.id
  name         = local.databricks_metastore_data_access_name
  is_default   = var.is_data_access_default

  # Azure Access Connector
  dynamic "azure_managed_identity" {
    for_each = var.credentials_type == "azure" ? [1] : []
    content {
      access_connector_id = var.azure_access_connector_id
    }
  }

  # GCP Service Account
  dynamic "databricks_gcp_service_account" {
    for_each = var.credentials_type == "gcp" ? [1] : []
    content {
      email = var.gcp_service_account_email
    }
  }

  # AWS Role
  dynamic "aws_iam_role" {
    for_each = var.credentials_type == "aws" ? [1] : []
    content {
      role_arn = var.aws_iam_role_arn
    }
  }
}
