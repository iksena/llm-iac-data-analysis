variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "table_data" {
  description = "Information about the data cells filter."
  type = object({
    database_name    = string
    name             = string
    table_catalog_id = string
    table_name       = string
    column_names     = optional(list(string))
    version_id       = optional(string)
    column_wildcard = optional(object({
      excluded_column_names = optional(list(string))
    }))
    row_filter = optional(object({
      all_rows_wildcard = optional(string)
      filter_expression = optional(string)
    }))
  })

  validation {
    condition     = var.table_data.database_name != null && var.table_data.database_name != ""
    error_message = "resource_aws_lakeformation_data_cells_filter, database_name cannot be null or empty."
  }

  validation {
    condition     = var.table_data.name != null && var.table_data.name != ""
    error_message = "resource_aws_lakeformation_data_cells_filter, name cannot be null or empty."
  }

  validation {
    condition     = var.table_data.table_catalog_id != null && var.table_data.table_catalog_id != ""
    error_message = "resource_aws_lakeformation_data_cells_filter, table_catalog_id cannot be null or empty."
  }

  validation {
    condition     = var.table_data.table_name != null && var.table_data.table_name != ""
    error_message = "resource_aws_lakeformation_data_cells_filter, table_name cannot be null or empty."
  }

  validation {
    condition     = var.table_data.column_wildcard == null || var.table_data.column_names == null
    error_message = "resource_aws_lakeformation_data_cells_filter, column_wildcard and column_names cannot both be specified."
  }

  validation {
    condition = var.table_data.row_filter == null || (
      var.table_data.row_filter.all_rows_wildcard == null || var.table_data.row_filter.filter_expression == null
    )
    error_message = "resource_aws_lakeformation_data_cells_filter, row_filter cannot have both all_rows_wildcard and filter_expression specified."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "2m")
  })
  default = {
    create = "2m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_lakeformation_data_cells_filter, create timeout must be in valid duration format (e.g., '2m', '30s', '1h')."
  }
}