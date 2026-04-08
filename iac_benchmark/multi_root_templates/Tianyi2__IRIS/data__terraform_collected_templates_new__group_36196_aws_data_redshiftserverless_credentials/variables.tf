variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "workgroup_name" {
  description = "The name of the workgroup associated with the database."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.workgroup_name)) && length(var.workgroup_name) >= 1
    error_message = "data_redshiftserverless_credentials, workgroup_name must contain only lowercase letters, numbers, and hyphens, and must be at least 1 character long."
  }
}

variable "db_name" {
  description = "The name of the database to get temporary authorization to log on to."
  type        = string
  default     = null

  validation {
    condition     = var.db_name == null || (can(regex("^[a-zA-Z][a-zA-Z0-9_$]*$", var.db_name)) && length(var.db_name) <= 64)
    error_message = "data_redshiftserverless_credentials, db_name must start with a letter and contain only letters, numbers, underscores, and dollar signs, with a maximum length of 64 characters."
  }
}

variable "duration_seconds" {
  description = "The number of seconds until the returned temporary password expires. The minimum is 900 seconds, and the maximum is 3600 seconds."
  type        = number
  default     = null

  validation {
    condition     = var.duration_seconds == null || (var.duration_seconds >= 900 && var.duration_seconds <= 3600)
    error_message = "data_redshiftserverless_credentials, duration_seconds must be between 900 and 3600 seconds."
  }
}