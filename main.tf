resource "databricks_metastore" "this" {
  name                                              = var.metastore_name
  storage_root                                      = var.storage_root
  delta_sharing_scope                               = var.delta_sharing_scope
  delta_sharing_recipient_token_lifetime_in_seconds = var.delta_sharing_recipient_token_lifetime_in_seconds
  force_destroy                                     = true
  region                                            = var.region
}

resource "databricks_metastore_data_access" "this" {
  metastore_id = databricks_metastore.this.id
  name         = coalesce(var.metastore_data_access_name, "data-access-${var.metastore_name}")
  is_default   = var.is_data_access_default
  force_destroy = var.metastore_data_access_force_destroy

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
    content {}
  }

  # AWS Role
  dynamic "aws_iam_role" {
    for_each = var.credentials_type == "aws" ? [1] : []
    content {
      role_arn = var.aws_iam_role_arn
    }
  }
}
