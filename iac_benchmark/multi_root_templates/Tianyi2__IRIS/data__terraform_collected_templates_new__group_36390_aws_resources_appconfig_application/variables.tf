variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name for the application. Must be between 1 and 64 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_appconfig_application, name must be between 1 and 64 characters in length."
  }
}

variable "description" {
  description = "Description of the application. Can be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_appconfig_application, description can be at most 1024 characters."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}