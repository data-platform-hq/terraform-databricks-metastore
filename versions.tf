terraform {
  required_version = ">=1.0.0"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">=1.24.1"
    }
  }
}
