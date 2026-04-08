variable "name" {
  description = "Name for the Resource Configuration"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_vpclattice_resource_configuration, name must not be empty."
  }
}

variable "port_ranges" {
  description = "Port ranges to access the Resource either single port 80 or range 80-81 range"
  type        = list(string)

  validation {
    condition     = length(var.port_ranges) > 0
    error_message = "resource_aws_vpclattice_resource_configuration, port_ranges must contain at least one port range."
  }

  validation {
    condition = alltrue([
      for port_range in var.port_ranges : can(regex("^\\d+(-\\d+)?$", port_range))
    ])
    error_message = "resource_aws_vpclattice_resource_configuration, port_ranges must be valid port numbers or port ranges (e.g., '80' or '80-81')."
  }
}

variable "allow_association_to_shareable_service_network" {
  description = "Allow or Deny the association of this resource to a shareable service network"
  type        = bool
  default     = null
}

variable "protocol" {
  description = "Protocol for the Resource TCP is currently the only supported value. MUST be specified if resource_configuration_group_id is not"
  type        = string
  default     = null

  validation {
    condition     = var.protocol == null || var.protocol == "TCP"
    error_message = "resource_aws_vpclattice_resource_configuration, protocol must be 'TCP' when specified."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "resource_configuration_group_id" {
  description = "ID of Resource Configuration where type is CHILD"
  type        = string
  default     = null
}

variable "resource_gateway_identifier" {
  description = "ID of the Resource Gateway used to access the resource. MUST be specified if resource_configuration_group_id is not"
  type        = string
  default     = null
}

variable "type" {
  description = "Type of Resource Configuration. Must be one of GROUP, CHILD, SINGLE, ARN"
  type        = string
  default     = null

  validation {
    condition     = var.type == null || contains(["GROUP", "CHILD", "SINGLE", "ARN"], var.type)
    error_message = "resource_aws_vpclattice_resource_configuration, type must be one of: GROUP, CHILD, SINGLE, ARN."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "resource_configuration_definition" {
  description = "Details of the Resource Configuration"
  type = object({
    region = optional(string)
    arn_resource = optional(object({
      arn = string
    }))
    dns_resource = optional(object({
      domain_name     = string
      ip_address_type = string
    }))
    ip_resource = optional(object({
      ip_address = string
    }))
  })
  default = null

  validation {
    condition = var.resource_configuration_definition == null || (
      (var.resource_configuration_definition.arn_resource != null ? 1 : 0) +
      (var.resource_configuration_definition.dns_resource != null ? 1 : 0) +
      (var.resource_configuration_definition.ip_resource != null ? 1 : 0) == 1
    )
    error_message = "resource_aws_vpclattice_resource_configuration, resource_configuration_definition must specify exactly one of: arn_resource, dns_resource, or ip_resource."
  }

  validation {
    condition = var.resource_configuration_definition == null || var.resource_configuration_definition.dns_resource == null || (
      var.resource_configuration_definition.dns_resource.ip_address_type == "IPV4" ||
      var.resource_configuration_definition.dns_resource.ip_address_type == "IPV6"
    )
    error_message = "resource_aws_vpclattice_resource_configuration, dns_resource.ip_address_type must be either 'IPV4' or 'IPV6'."
  }

  validation {
    condition = var.resource_configuration_definition == null || var.resource_configuration_definition.dns_resource == null || (
      length(var.resource_configuration_definition.dns_resource.domain_name) > 0
    )
    error_message = "resource_aws_vpclattice_resource_configuration, dns_resource.domain_name must not be empty."
  }

  validation {
    condition = var.resource_configuration_definition == null || var.resource_configuration_definition.ip_resource == null || (
      can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$|^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$", var.resource_configuration_definition.ip_resource.ip_address))
    )
    error_message = "resource_aws_vpclattice_resource_configuration, ip_resource.ip_address must be a valid IPv4 or IPv6 address."
  }

  validation {
    condition = var.resource_configuration_definition == null || var.resource_configuration_definition.arn_resource == null || (
      length(var.resource_configuration_definition.arn_resource.arn) > 0 &&
      can(regex("^arn:aws:", var.resource_configuration_definition.arn_resource.arn))
    )
    error_message = "resource_aws_vpclattice_resource_configuration, arn_resource.arn must be a valid AWS ARN."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  validation {
    condition = alltrue([
      can(regex("^\\d+[smh]$", var.timeouts.create)),
      can(regex("^\\d+[smh]$", var.timeouts.update)),
      can(regex("^\\d+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_vpclattice_resource_configuration, timeouts must be valid duration strings (e.g., '10m', '1h', '30s')."
  }
}