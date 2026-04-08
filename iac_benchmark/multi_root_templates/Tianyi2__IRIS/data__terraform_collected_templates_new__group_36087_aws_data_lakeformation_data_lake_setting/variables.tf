variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_lakeformation_data_lake_settings, region must be a valid AWS region name."
  }
}

variable "catalog_id" {
  description = "Identifier for the Data Catalog. By default, the account ID."
  type        = string
  default     = null

  validation {
    condition     = var.catalog_id == null || can(regex("^[0-9]{12}$", var.catalog_id))
    error_message = "data_aws_lakeformation_data_lake_settings, catalog_id must be a valid 12-digit AWS account ID."
  }
}