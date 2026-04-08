variable "domain_identifier" {
  description = "The domain identifier."
  type        = string

  validation {
    condition     = length(var.domain_identifier) > 0
    error_message = "resource_aws_datazone_user_profile, domain_identifier must not be empty."
  }
}

variable "user_identifier" {
  description = "The user identifier."
  type        = string

  validation {
    condition     = length(var.user_identifier) > 0
    error_message = "resource_aws_datazone_user_profile, user_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "status" {
  description = "The user profile status."
  type        = string
  default     = null
}

variable "user_type" {
  description = "The user type."
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_datazone_user_profile, timeouts_create must be a valid duration (e.g., '5m', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_datazone_user_profile, timeouts_update must be a valid duration (e.g., '5m', '1h')."
  }
}