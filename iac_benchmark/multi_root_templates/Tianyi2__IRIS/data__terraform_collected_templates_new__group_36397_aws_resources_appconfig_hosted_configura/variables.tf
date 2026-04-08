variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "Application ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{7}$", var.application_id))
    error_message = "resource_aws_appconfig_hosted_configuration_version, application_id must be a valid 7-character hexadecimal ID."
  }
}

variable "configuration_profile_id" {
  description = "Configuration profile ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-z]{7}$", var.configuration_profile_id))
    error_message = "resource_aws_appconfig_hosted_configuration_version, configuration_profile_id must be a valid 7-character alphanumeric ID."
  }
}

variable "content" {
  description = "Content of the configuration or the configuration data."
  type        = string

  validation {
    condition     = length(var.content) > 0
    error_message = "resource_aws_appconfig_hosted_configuration_version, content cannot be empty."
  }
}

variable "content_type" {
  description = "Standard MIME type describing the format of the configuration content."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9!#$&\\-\\^_]*\\/[a-zA-Z0-9][a-zA-Z0-9!#$&\\-\\^_]*$", var.content_type))
    error_message = "resource_aws_appconfig_hosted_configuration_version, content_type must be a valid MIME type (e.g., 'application/json')."
  }
}

variable "description" {
  description = "Description of the configuration."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_appconfig_hosted_configuration_version, description cannot exceed 1024 characters."
  }
}