output "metastore_id" {
  value       = databricks_metastore.this.id
  description = "Unity Catalog Metastore Id"
}

output "metastore_name" {
  value       = databricks_metastore.this.name
  description = "Unity Catalog Metastore name"
}
