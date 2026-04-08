variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the service."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "data_aws_service_discovery_service, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "namespace_id" {
  description = "ID of the namespace that the service belongs to."
  type        = string

  validation {
    condition     = length(var.namespace_id) > 0
    error_message = "data_aws_service_discovery_service, namespace_id cannot be empty."
  }
}