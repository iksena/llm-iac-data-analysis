variable "space_name" {
  description = "The name of the space."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.space_name))
    error_message = "resource_aws_codecatalyst_project, space_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "display_name" {
  description = "The friendly name of the project that will be displayed to users."
  type        = string

  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 100
    error_message = "resource_aws_codecatalyst_project, display_name must be between 1 and 100 characters long."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the project. This description will be displayed to all users of the project."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 500
    error_message = "resource_aws_codecatalyst_project, description must be 500 characters or less."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the CodeCatalyst project."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_codecatalyst_project, timeouts_create must be a valid duration (e.g., '5m', '30s', '1h')."
  }
}

variable "timeouts_update" {
  description = "Timeout for updating the CodeCatalyst project."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_update))
    error_message = "resource_aws_codecatalyst_project, timeouts_update must be a valid duration (e.g., '5m', '30s', '1h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the CodeCatalyst project."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_codecatalyst_project, timeouts_delete must be a valid duration (e.g., '5m', '30s', '1h')."
  }
}