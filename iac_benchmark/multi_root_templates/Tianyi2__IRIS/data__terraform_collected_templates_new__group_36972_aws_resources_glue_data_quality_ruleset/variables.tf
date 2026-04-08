variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the data quality ruleset."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the data quality ruleset."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_glue_data_quality_ruleset, name must be a non-empty string containing only alphanumeric characters, underscores, and hyphens."
  }
}

variable "ruleset" {
  description = "A Data Quality Definition Language (DQDL) ruleset. For more information, see the AWS Glue developer guide."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "target_table" {
  description = "A Configuration block specifying a target table associated with the data quality ruleset."
  type = object({
    catalog_id    = optional(string)
    database_name = string
    table_name    = string
  })
  default = null

  validation {
    condition = var.target_table == null || (
      var.target_table.database_name != null &&
      var.target_table.table_name != null &&
      length(var.target_table.database_name) > 0 &&
      length(var.target_table.table_name) > 0
    )
    error_message = "resource_aws_glue_data_quality_ruleset, target_table database_name and table_name must be non-empty strings when target_table is specified."
  }

  validation {
    condition = var.target_table == null || (
      var.target_table.catalog_id == null || length(var.target_table.catalog_id) > 0
    )
    error_message = "resource_aws_glue_data_quality_ruleset, target_table catalog_id must be a non-empty string when specified."
  }
}