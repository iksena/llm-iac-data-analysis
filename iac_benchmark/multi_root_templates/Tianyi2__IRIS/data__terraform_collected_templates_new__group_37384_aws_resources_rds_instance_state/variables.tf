variable "identifier" {
  description = "DB Instance Identifier"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z]", var.identifier))
    error_message = "resource_aws_rds_instance_state, identifier must start with a letter."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.identifier))
    error_message = "resource_aws_rds_instance_state, identifier can only contain alphanumeric characters and hyphens."
  }

  validation {
    condition     = length(var.identifier) >= 1 && length(var.identifier) <= 63
    error_message = "resource_aws_rds_instance_state, identifier must be between 1 and 63 characters long."
  }
}

variable "state" {
  description = "Configured state of the DB Instance. Valid values are 'available' and 'stopped'."
  type        = string

  validation {
    condition     = contains(["available", "stopped"], var.state)
    error_message = "resource_aws_rds_instance_state, state must be either 'available' or 'stopped'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "timeout_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeout_create))
    error_message = "resource_aws_rds_instance_state, timeout_create must be a valid duration (e.g., '30m', '1h', '300s')."
  }
}

variable "timeout_update" {
  description = "Timeout for update operation"
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeout_update))
    error_message = "resource_aws_rds_instance_state, timeout_update must be a valid duration (e.g., '30m', '1h', '300s')."
  }
}