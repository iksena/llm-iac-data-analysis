variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the custom event schema registry. Maximum of 64 characters consisting of lower case letters, upper case letters, 0-9, ., -, _."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) <= 64
    error_message = "resource_aws_schemas_registry, name must contain only letters, numbers, dots, hyphens, and underscores, and be maximum 64 characters long."
  }
}

variable "description" {
  description = "The description of the discoverer. Maximum of 256 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null ? true : length(var.description) <= 256
    error_message = "resource_aws_schemas_registry, description must be maximum 256 characters long."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}