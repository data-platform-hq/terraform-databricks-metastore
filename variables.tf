variable "metastore_name" {
  type        = string
  description = "Unity Catalog Metastore name"
}

variable "storage_root" {
  type        = string
  description = "Path on cloud storage, where managed Unity Catalog Metastore is created"
}

variable "credentials_type" {
  type        = string
  description = "Cloud provider. Select from: azure, gcp, aws"

  validation {
    condition     = contains(["azure", "gcp", "aws"], var.credentials_type)
    error_message = "Please provide correct provider, use : azure, gcp, aws."
  }
}

variable "metastore_data_access_name" {
  type        = string
  description = "Unity Catalog Metastore Data Access Storage Credentials name"
  default     = null
}

variable "metastore_data_access_force_destroy" {
  type        = bool
  description = "DAC force destroy option"
  default     = true
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

variable "aws_iam_role_arn" {
  type        = string
  description = "The Amazon Resource Name, of the AWS IAM role for S3 data access"
  default     = null
}

variable "region" {
  type        = string
  description = "Required when using Account level API provider authorization. The region of metastore"
  default     = null
}
