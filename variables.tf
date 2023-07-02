variable "env" {
  type        = string
  description = "Environment name"
}

variable "storage_root" {
  type        = string
  description = "Path on cloud storage, where managed Unity Catalog Metastore is created"
}

variable "suffix" {
  type        = string
  description = "Optional suffix that would be added to the end of resources names."
  default     = ""
}

variable "is_data_access_default" {
  type        = string
  description = "Are Data Access Storage Credentials default for assigned Metastore?"
  default     = true
}

variable "azure_access_connector_id" {
  type        = string
  description = "Databricks Access Connector Id that lets you to connect managed identities to an Azure Databricks account. Provides an ability to access Unity Catalog with assigned identity"
  default     = null
}

variable "gcp_service_account_email" {
  type        = string
  description = "The email of the GCP service account created, to be granted access to relevant buckets."
  default     = null
}

variable "custom_databricks_metastore_name" {
  type        = string
  description = "The name to provide for your Databricks Metastore"
  default     = null
}

variable "custom_databricks_metastore_data_access_name" {
  type        = string
  description = "The name to provide for your Databricks Metastore Data Access Resource"
  default     = null
}
