variable "resource_configuration_identifier" {
  description = "Identifier of Resource Configuration to associate to the Service Network."
  type        = string

  validation {
    condition     = length(var.resource_configuration_identifier) > 0
    error_message = "resource_aws_vpclattice_service_network_resource_association, resource_configuration_identifier must not be empty."
  }
}

variable "service_network_identifier" {
  description = "Identifier of the Service Network to associate the Resource to."
  type        = string

  validation {
    condition     = length(var.service_network_identifier) > 0
    error_message = "resource_aws_vpclattice_service_network_resource_association, service_network_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "How long to wait for the association to be created."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_vpclattice_service_network_resource_association, timeouts_create must be a valid duration (e.g., '10m', '1h', '30s')."
  }
}

variable "timeouts_delete" {
  description = "How long to wait for the association to be deleted."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_vpclattice_service_network_resource_association, timeouts_delete must be a valid duration (e.g., '10m', '1h', '30s')."
  }
}