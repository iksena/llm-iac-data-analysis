variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_service_discovery_public_dns_namespace, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "name" {
  description = "The name of the namespace."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+$", var.name)) && length(var.name) > 0
    error_message = "resource_aws_service_discovery_public_dns_namespace, name must be a non-empty string containing only alphanumeric characters, dots, and hyphens."
  }
}

variable "description" {
  description = "The description that you specify for the namespace when you create it."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_service_discovery_public_dns_namespace, description must be 1024 characters or less."
  }
}

variable "tags" {
  description = "A map of tags to assign to the namespace."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s._:/=+@-]*$", k)) && can(regex("^[a-zA-Z0-9\\s._:/=+@-]*$", v))
    ])
    error_message = "resource_aws_service_discovery_public_dns_namespace, tags keys and values must contain only valid characters (alphanumeric, spaces, and ._:/=+@-)."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 128 && length(v) <= 256
    ])
    error_message = "resource_aws_service_discovery_public_dns_namespace, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}