output "metastore_id" {
  value       = databricks_metastore.this.id
  description = "Unity Catalog Metastore Id"
}

output "metastore_name" {
  value       = databricks_metastore.this.name
  description = "Unity Catalog Metastore name"
}

output "gcp_service_principal" {
  value       = try(databricks_metastore_data_access.this.databricks_gcp_service_account[0], null)
  description = "Databricks-managed GCP Service Account used for UC access"
}
