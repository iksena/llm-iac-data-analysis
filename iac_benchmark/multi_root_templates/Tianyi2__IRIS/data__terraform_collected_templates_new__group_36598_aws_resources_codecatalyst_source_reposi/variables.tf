variable "name" {
  description = "The name of the source repository. For more information about name requirements, see Quotas for source repositories."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codecatalyst_source_repository, name must be a non-empty string."
  }
}

variable "space_name" {
  description = "The name of the CodeCatalyst space."
  type        = string

  validation {
    condition     = length(var.space_name) > 0
    error_message = "resource_aws_codecatalyst_source_repository, space_name must be a non-empty string."
  }
}

variable "project_name" {
  description = "The name of the project in the CodeCatalyst space."
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "resource_aws_codecatalyst_source_repository, project_name must be a non-empty string."
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
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_codecatalyst_source_repository, timeouts_create must be a valid timeout format (e.g., 30m, 1h, 300s)."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_codecatalyst_source_repository, timeouts_update must be a valid timeout format (e.g., 30m, 1h, 300s)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_codecatalyst_source_repository, timeouts_delete must be a valid timeout format (e.g., 30m, 1h, 300s)."
  }
}