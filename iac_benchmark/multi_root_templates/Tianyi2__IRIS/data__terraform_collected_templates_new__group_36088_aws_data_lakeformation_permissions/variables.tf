variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "principal" {
  description = "Principal to be granted the permissions on the resource. Supported principals are IAM users or IAM roles."
  type        = string

  validation {
    condition     = length(var.principal) > 0
    error_message = "data_lakeformation_permissions, principal must not be empty."
  }
}

variable "catalog_id" {
  description = "Identifier for the Data Catalog. By default, the account ID. The Data Catalog is the persistent metadata store."
  type        = string
  default     = null
}

variable "catalog_resource" {
  description = "Whether the permissions are to be granted for the Data Catalog."
  type        = bool
  default     = false
}

variable "data_cells_filter" {
  description = "Configuration block for a data cells filter resource."
  type = object({
    database_name    = string
    name             = string
    table_catalog_id = string
    table_name       = string
  })
  default = null

  validation {
    condition = var.data_cells_filter == null || (
      length(var.data_cells_filter.database_name) > 0 &&
      length(var.data_cells_filter.name) > 0 &&
      length(var.data_cells_filter.table_catalog_id) > 0 &&
      length(var.data_cells_filter.table_name) > 0
    )
    error_message = "data_lakeformation_permissions, data_cells_filter requires database_name, name, table_catalog_id, and table_name to be non-empty."
  }
}

variable "data_location" {
  description = "Configuration block for a data location resource."
  type = object({
    arn        = string
    catalog_id = optional(string)
  })
  default = null

  validation {
    condition     = var.data_location == null || length(var.data_location.arn) > 0
    error_message = "data_lakeformation_permissions, data_location arn must not be empty."
  }
}

variable "database" {
  description = "Configuration block for a database resource."
  type = object({
    name       = string
    catalog_id = optional(string)
  })
  default = null

  validation {
    condition     = var.database == null || length(var.database.name) > 0
    error_message = "data_lakeformation_permissions, database name must not be empty."
  }
}

variable "lf_tag" {
  description = "Configuration block for an LF-tag resource."
  type = object({
    key        = string
    values     = list(string)
    catalog_id = optional(string)
  })
  default = null

  validation {
    condition = var.lf_tag == null || (
      length(var.lf_tag.key) > 0 &&
      length(var.lf_tag.values) > 0
    )
    error_message = "data_lakeformation_permissions, lf_tag key must not be empty and values must not be empty."
  }
}

variable "lf_tag_policy" {
  description = "Configuration block for an LF-tag policy resource."
  type = object({
    resource_type = string
    expression = list(object({
      key    = string
      values = list(string)
    }))
    catalog_id = optional(string)
  })
  default = null

  validation {
    condition     = var.lf_tag_policy == null || contains(["DATABASE", "TABLE"], var.lf_tag_policy.resource_type)
    error_message = "data_lakeformation_permissions, lf_tag_policy resource_type must be DATABASE or TABLE."
  }

  validation {
    condition     = var.lf_tag_policy == null || length(var.lf_tag_policy.expression) > 0
    error_message = "data_lakeformation_permissions, lf_tag_policy expression must not be empty."
  }

  validation {
    condition = var.lf_tag_policy == null || alltrue([
      for expr in var.lf_tag_policy.expression :
      length(expr.key) > 0 && length(expr.values) > 0
    ])
    error_message = "data_lakeformation_permissions, lf_tag_policy expression key and values must not be empty."
  }
}

variable "table" {
  description = "Configuration block for a table resource."
  type = object({
    database_name = string
    region        = optional(string)
    catalog_id    = optional(string)
    name          = optional(string)
    wildcard      = optional(bool, false)
  })
  default = null

  validation {
    condition     = var.table == null || length(var.table.database_name) > 0
    error_message = "data_lakeformation_permissions, table database_name must not be empty."
  }

  validation {
    condition     = var.table == null || (var.table.name != null || var.table.wildcard == true)
    error_message = "data_lakeformation_permissions, table requires at least one of name or wildcard."
  }
}

variable "table_with_columns" {
  description = "Configuration block for a table with columns resource."
  type = object({
    database_name         = string
    name                  = string
    region                = optional(string)
    catalog_id            = optional(string)
    column_names          = optional(set(string))
    excluded_column_names = optional(set(string))
  })
  default = null

  validation {
    condition = var.table_with_columns == null || (
      length(var.table_with_columns.database_name) > 0 &&
      length(var.table_with_columns.name) > 0
    )
    error_message = "data_lakeformation_permissions, table_with_columns database_name and name must not be empty."
  }

  validation {
    condition = var.table_with_columns == null || (
      var.table_with_columns.column_names != null ||
      var.table_with_columns.excluded_column_names != null
    )
    error_message = "data_lakeformation_permissions, table_with_columns requires at least one of column_names or excluded_column_names."
  }
}