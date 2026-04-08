variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Profile Association. Must match a regex of (?!^[0-9]+$)([a-zA-Z0-9\\-_' ']+)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9\\-_' ']*$", var.name)) && !can(regex("^[0-9]+$", var.name))
    error_message = "resource_aws_route53profiles_association, name must start with a letter and contain only alphanumeric characters, hyphens, underscores, and spaces. It cannot be only numbers."
  }
}

variable "profile_id" {
  description = "ID of the profile associated with the VPC."
  type        = string

  validation {
    condition     = length(var.profile_id) > 0
    error_message = "resource_aws_route53profiles_association, profile_id cannot be empty."
  }
}

variable "resource_id" {
  description = "Resource ID of the VPC the profile to be associated with."
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_route53profiles_association, resource_id cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the resource."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_route53profiles_association, create_timeout must be a valid duration (e.g., 30m, 1h)."
  }
}

variable "update_timeout" {
  description = "Timeout for updating the resource."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_route53profiles_association, update_timeout must be a valid duration (e.g., 5m, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the resource."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_route53profiles_association, delete_timeout must be a valid duration (e.g., 30m, 1h)."
  }
}