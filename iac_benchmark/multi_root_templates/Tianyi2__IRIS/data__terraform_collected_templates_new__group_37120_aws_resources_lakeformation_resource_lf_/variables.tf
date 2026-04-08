variable "lf_tags" {
  description = "Set of LF-tags to attach to the resource"
  type = list(object({
    key        = string
    value      = string
    catalog_id = optional(string)
  }))

  validation {
    condition     = length(var.lf_tags) > 0
    error_message = "resource_aws_lakeformation_resource_lf_tags, lf_tags must contain at least one LF-tag"
  }

  validation {
    condition = alltrue([
      for tag in var.lf_tags : tag.key != null && tag.key != ""
    ])
    error_message = "resource_aws_lakeformation_resource_lf_tags, lf_tags key is required and cannot be empty"
  }

  validation {
    condition = alltrue([
      for tag in var.lf_tags : tag.value != null && tag.value != ""
    ])
    error_message = "resource_aws_lakeformation_resource_lf_tags, lf_tags value is required and cannot be empty"
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
    error_message = "resource_aws_lakeformation_resource_lf_tags, database name is required when database block is specified"
  }
}

variable "table" {
  description = "Configuration block for a table resource"
  type = object({
    database_name = string
    name          = optional(string)
    wildcard      = optional(bool, false)
    region        = optional(string)
    catalog_id    = optional(string)
  })
  default = null

  validation {
    condition = var.table == null || (
      var.table.database_name != null && var.table.database_name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tags, table database_name is required when table block is specified"
  }

  validation {
    condition = var.table == null || (
      (var.table.name != null && var.table.name != "") || var.table.wildcard == true
    )
    error_message = "resource_aws_lakeformation_resource_lf_tags, table must specify either name or wildcard"
  }
}

variable "table_with_columns" {
  description = "Configuration block for a table with columns resource"
  type = object({
    column_names          = optional(set(string))
    database_name         = string
    name                  = string
    wildcard              = bool
    region                = optional(string)
    catalog_id            = optional(string)
    excluded_column_names = optional(set(string))
  })
  default = null

  validation {
    condition = var.table_with_columns == null || (
      var.table_with_columns.database_name != null && var.table_with_columns.database_name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tags, table_with_columns database_name is required when table_with_columns block is specified"
  }

  validation {
    condition = var.table_with_columns == null || (
      var.table_with_columns.name != null && var.table_with_columns.name != ""
    )
    error_message = "resource_aws_lakeformation_resource_lf_tags, table_with_columns name is required when table_with_columns block is specified"
  }

  validation {
    condition = var.table_with_columns == null || (
      (var.table_with_columns.column_names != null && length(var.table_with_columns.column_names) > 0) || var.table_with_columns.wildcard == true
    )
    error_message = "resource_aws_lakeformation_resource_lf_tags, table_with_columns must specify either column_names or wildcard"
  }

  validation {
    condition = var.table_with_columns == null || (
      var.table_with_columns.excluded_column_names == null || var.table_with_columns.wildcard == true
    )
    error_message = "resource_aws_lakeformation_resource_lf_tags, table_with_columns wildcard must be true when excluded_column_names is specified"
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

# Validation to ensure exactly one resource type is specified
locals {
  resource_count = (
    (var.database != null ? 1 : 0) +
    (var.table != null ? 1 : 0) +
    (var.table_with_columns != null ? 1 : 0)
  )
}

variable "resource_validation" {
  description = "Internal validation variable"
  type        = bool
  default     = true

  validation {
    condition     = var.resource_validation == true && local.resource_count == 1
    error_message = "resource_aws_lakeformation_resource_lf_tags, exactly one of database, table, or table_with_columns must be specified"
  }
}