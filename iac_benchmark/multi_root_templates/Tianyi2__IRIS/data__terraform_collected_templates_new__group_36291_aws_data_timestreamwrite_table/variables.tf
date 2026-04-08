variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_timestreamwrite_table, region must be a valid AWS region format."
  }
}

variable "database_name" {
  description = "Name of the Timestream database."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.database_name)) && length(var.database_name) >= 3 && length(var.database_name) <= 256
    error_message = "data_aws_timestreamwrite_table, database_name must be between 3 and 256 characters and contain only alphanumeric characters, hyphens, periods, and underscores."
  }
}

variable "name" {
  description = "Name of the Timestream table."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name)) && length(var.name) >= 3 && length(var.name) <= 256
    error_message = "data_aws_timestreamwrite_table, name must be between 3 and 256 characters and contain only alphanumeric characters, hyphens, periods, and underscores."
  }
}