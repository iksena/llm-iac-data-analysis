variable "name" {
  description = "The name of the configured table"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cleanrooms_configured_table, name must be a non-empty string."
  }
}

variable "description" {
  description = "A description for the configured table"
  type        = string
  default     = null
}

variable "analysis_method" {
  description = "The analysis method for the configured table"
  type        = string

  validation {
    condition     = var.analysis_method == "DIRECT_QUERY"
    error_message = "resource_aws_cleanrooms_configured_table, analysis_method must be 'DIRECT_QUERY'."
  }
}

variable "allowed_columns" {
  description = "The columns of the references table which will be included in the configured table"
  type        = list(string)

  validation {
    condition     = length(var.allowed_columns) > 0
    error_message = "resource_aws_cleanrooms_configured_table, allowed_columns must contain at least one column."
  }
}

variable "table_reference_database_name" {
  description = "The name of the AWS Glue database which contains the table"
  type        = string

  validation {
    condition     = length(var.table_reference_database_name) > 0
    error_message = "resource_aws_cleanrooms_configured_table, table_reference_database_name must be a non-empty string."
  }
}

variable "table_reference_table_name" {
  description = "The name of the AWS Glue table which will be used to create the configured table"
  type        = string

  validation {
    condition     = length(var.table_reference_table_name) > 0
    error_message = "resource_aws_cleanrooms_configured_table, table_reference_table_name must be a non-empty string."
  }
}

variable "tags" {
  description = "Key value pairs which tag the configured table"
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for creating the configured table"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_cleanrooms_configured_table, timeouts_create must be a valid timeout format (e.g., '1m', '30s', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for updating the configured table"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_cleanrooms_configured_table, timeouts_update must be a valid timeout format (e.g., '1m', '30s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the configured table"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_cleanrooms_configured_table, timeouts_delete must be a valid timeout format (e.g., '1m', '30s', '1h')."
  }
}