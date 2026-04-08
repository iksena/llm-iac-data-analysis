variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "principal" {
  description = "Lake Formation principal. Supported principals are IAM users or IAM roles."
  type = object({
    data_lake_principal = string
  })
  validation {
    condition     = var.principal.data_lake_principal != null && var.principal.data_lake_principal != ""
    error_message = "resource_aws_lakeformation_opt_in, principal.data_lake_principal must be provided and cannot be empty."
  }
}

variable "resource_data" {
  description = "Structure for the resource."
  type = object({
    catalog = optional(object({
      id = string
    }))
    data_cells_filter = optional(object({
      database_name    = string
      name             = string
      table_catalog_id = string
      table_name       = string
    }))
    data_location = optional(object({
      resource_arn = string
      catalog_id   = optional(string)
    }))
    database = optional(object({
      name       = string
      catalog_id = optional(string)
    }))
    lf_tag = optional(map(string))
    lf_tag_expression = optional(object({
      name       = string
      catalog_id = optional(string)
    }))
    lf_tag_policy = optional(object({
      resource_type   = string
      catalog_id      = optional(string)
      expression      = optional(list(string))
      expression_name = optional(string)
    }))
    table = optional(object({
      database_name = string
      name          = optional(string)
      catalog_id    = optional(string)
      wildcard      = optional(bool)
    }))
    table_with_columns = optional(object({
      database_name   = string
      name            = string
      catalog_id      = optional(string)
      column_names    = optional(list(string))
      column_wildcard = optional(object({}))
    }))
  })
  validation {
    condition     = var.resource_data != null
    error_message = "resource_aws_lakeformation_opt_in, resource_data must be provided."
  }
  validation {
    condition = (
      (var.resource_data.catalog != null ? 1 : 0) +
      (var.resource_data.data_cells_filter != null ? 1 : 0) +
      (var.resource_data.data_location != null ? 1 : 0) +
      (var.resource_data.database != null ? 1 : 0) +
      (var.resource_data.lf_tag != null ? 1 : 0) +
      (var.resource_data.lf_tag_expression != null ? 1 : 0) +
      (var.resource_data.lf_tag_policy != null ? 1 : 0) +
      (var.resource_data.table != null ? 1 : 0) +
      (var.resource_data.table_with_columns != null ? 1 : 0)
    ) >= 1
    error_message = "resource_aws_lakeformation_opt_in, resource_data must contain at least one resource type."
  }
  validation {
    condition = var.resource_data.data_cells_filter != null ? (
      var.resource_data.data_cells_filter.database_name != null &&
      var.resource_data.data_cells_filter.database_name != "" &&
      var.resource_data.data_cells_filter.name != null &&
      var.resource_data.data_cells_filter.name != "" &&
      var.resource_data.data_cells_filter.table_catalog_id != null &&
      var.resource_data.data_cells_filter.table_catalog_id != "" &&
      var.resource_data.data_cells_filter.table_name != null &&
      var.resource_data.data_cells_filter.table_name != ""
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.data_cells_filter requires database_name, name, table_catalog_id, and table_name."
  }
  validation {
    condition = var.resource_data.data_location != null ? (
      var.resource_data.data_location.resource_arn != null &&
      var.resource_data.data_location.resource_arn != ""
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.data_location requires resource_arn."
  }
  validation {
    condition = var.resource_data.database != null ? (
      var.resource_data.database.name != null &&
      var.resource_data.database.name != ""
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.database requires name."
  }
  validation {
    condition = var.resource_data.lf_tag_expression != null ? (
      var.resource_data.lf_tag_expression.name != null &&
      var.resource_data.lf_tag_expression.name != ""
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.lf_tag_expression requires name."
  }
  validation {
    condition = var.resource_data.lf_tag_policy != null ? (
      var.resource_data.lf_tag_policy.resource_type != null &&
      var.resource_data.lf_tag_policy.resource_type != ""
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.lf_tag_policy requires resource_type."
  }
  validation {
    condition = var.resource_data.table != null ? (
      var.resource_data.table.database_name != null &&
      var.resource_data.table.database_name != "" &&
      (var.resource_data.table.name != null || var.resource_data.table.wildcard != null)
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.table requires database_name and at least one of name or wildcard."
  }
  validation {
    condition = var.resource_data.table_with_columns != null ? (
      var.resource_data.table_with_columns.database_name != null &&
      var.resource_data.table_with_columns.database_name != "" &&
      var.resource_data.table_with_columns.name != null &&
      var.resource_data.table_with_columns.name != "" &&
      (var.resource_data.table_with_columns.column_names != null || var.resource_data.table_with_columns.column_wildcard != null)
    ) : true
    error_message = "resource_aws_lakeformation_opt_in, resource_data.table_with_columns requires database_name, name, and at least one of column_names or column_wildcard."
  }
}

variable "timeouts" {
  description = "Timeouts configuration for the resource."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}