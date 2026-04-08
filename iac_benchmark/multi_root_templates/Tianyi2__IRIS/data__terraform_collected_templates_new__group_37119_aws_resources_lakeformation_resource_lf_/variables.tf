variable "lf_tag" {
  description = "Set of LF-tags to attach to the resource"
  type = object({
    key        = string
    value      = string
    catalog_id = optional(string)
  })

  validation {
    condition     = var.lf_tag.key != null && var.lf_tag.key != ""
    error_message = "resource_aws_lakeformation_resource_lf_tag, lf_tag.key must be provided and cannot be empty."
  }

  validation {
    condition     = var.lf_tag.value != null && var.lf_tag.value != ""
    error_message = "resource_aws_lakeformation_resource_lf_tag, lf_tag.value must be provided and cannot be empty."
  }
}

variable "database" {
  description = "Configuration block for a database resource"
  type = object({
    name       = string
    catalog_id = optional(string)
  })
  default = null

  validation {
    condition = var.database == null || (
      var.database.name != null && var.database.name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tag, database.name must be provided and cannot be empty when database block is specified."
  }
}

variable "table" {
  description = "Configuration block for a table resource"
  type = object({
    database_name = string
    name          = optional(string)
    wildcard      = optional(bool, false)
    catalog_id    = optional(string)
  })
  default = null

  validation {
    condition = var.table == null || (
      var.table.database_name != null && var.table.database_name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tag, table.database_name must be provided and cannot be empty when table block is specified."
  }

  validation {
    condition = var.table == null || (
      (var.table.name != null && var.table.name != "") || var.table.wildcard == true
    )
    error_message = "resource_aws_lakeformation_resource_lf_tag, table must have either name specified or wildcard set to true."
  }
}

variable "table_with_columns" {
  description = "Configuration block for a table with columns resource"
  type = object({
    column_names  = optional(set(string))
    database_name = string
    name          = string
    catalog_id    = optional(string)
    column_wildcard = optional(object({
      excluded_column_names = optional(set(string))
    }))
  })
  default = null

  validation {
    condition = var.table_with_columns == null || (
      var.table_with_columns.database_name != null && var.table_with_columns.database_name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tag, table_with_columns.database_name must be provided and cannot be empty when table_with_columns block is specified."
  }

  validation {
    condition = var.table_with_columns == null || (
      var.table_with_columns.name != null && var.table_with_columns.name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tag, table_with_columns.name must be provided and cannot be empty when table_with_columns block is specified."
  }

  validation {
    condition = var.table_with_columns == null || (
      (var.table_with_columns.column_names != null && length(var.table_with_columns.column_names) > 0) ||
      var.table_with_columns.column_wildcard != null
    )
    error_message = "resource_aws_lakeformation_resource_lf_tag, table_with_columns must have either column_names specified or column_wildcard block defined."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "catalog_id" {
  description = "Identifier for the Data Catalog"
  type        = string
  default     = null
}

# Validation to ensure exactly one of database, table, or table_with_columns is specified
variable "resource_count_validation" {
  description = "Internal validation variable - do not set"
  type        = number
  default     = 0

  validation {
    condition     = var.resource_count_validation >= 0
    error_message = "resource_aws_lakeformation_resource_lf_tag, exactly one of database, table, or table_with_columns must be specified."
  }
}