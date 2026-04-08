variable "domain_identifier" {
  description = "The unique identifier of the Amazon DataZone domain where the custom asset type is being created."
  type        = string

  validation {
    condition     = length(var.domain_identifier) > 0
    error_message = "resource_aws_datazone_asset_type, domain_identifier must not be empty."
  }
}

variable "name" {
  description = "The name of the custom asset type."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_datazone_asset_type, name must not be empty."
  }
}

variable "owning_project_identifier" {
  description = "The unique identifier of the Amazon DataZone project that owns the custom asset type."
  type        = string

  validation {
    condition     = length(var.owning_project_identifier) > 0
    error_message = "resource_aws_datazone_asset_type, owning_project_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the custom asset type."
  type        = string
  default     = null
}

variable "forms_input" {
  description = "The metadata forms that are to be attached to the custom asset type."
  type        = any
  default     = null
}

variable "create_timeout" {
  description = "Timeout for creating the asset type."
  type        = string
  default     = "30s"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_datazone_asset_type, create_timeout must be a valid duration string (e.g., '30s', '5m', '1h')."
  }
}