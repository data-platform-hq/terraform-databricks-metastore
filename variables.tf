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

variable "delta_sharing_scope" {
  type        = string
  description = "Used to enable delta sharing on the metastore. Valid values: INTERNAL, INTERNAL_AND_EXTERNAL."
  default     = "INTERNAL"
}

variable "delta_sharing_recipient_token_lifetime_in_seconds" {
  type        = string
  description = "Used to set expiration duration in seconds on recipient data access tokens. Set to 0 for unlimited duration."
  default     = 0
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

variable "region" {
  type        = string
  description = "Required when using Account level API provider authorization. The region of metastore"
  default     = null
}

variable "credentials_type" {
  type        = string
  description = "Cloud provider"
  default     = null

  validation {
    condition     = contains(["azure", "gcp", "aws"], var.credentials_type)
    error_message = "Please provide correct provider, use : azure, gcp, aws."
  }
}

variable "aws_iam_role_arn" {
  type        = string
  description = "The Amazon Resource Name, of the AWS IAM role for S3 data access"
  default     = null
}
