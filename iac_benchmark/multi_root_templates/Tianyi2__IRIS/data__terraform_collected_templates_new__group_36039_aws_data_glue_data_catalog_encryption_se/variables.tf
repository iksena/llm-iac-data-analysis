variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "ID of the Data Catalog. This is typically the AWS account ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.catalog_id))
    error_message = "data_aws_glue_data_catalog_encryption_settings, catalog_id must be a 12-digit AWS account ID."
  }
}