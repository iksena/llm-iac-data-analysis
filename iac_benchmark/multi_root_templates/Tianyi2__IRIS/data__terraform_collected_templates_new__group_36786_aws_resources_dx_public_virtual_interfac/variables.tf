variable "address_family" {
  description = "The address family for the BGP peer"
  type        = string

  validation {
    condition     = contains(["ipv4", "ipv6"], var.address_family)
    error_message = "resource_aws_dx_public_virtual_interface, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration"
  type        = number

  validation {
    condition     = var.bgp_asn >= 1 && var.bgp_asn <= 4294967295
    error_message = "resource_aws_dx_public_virtual_interface, bgp_asn must be a valid AS number between 1 and 4294967295."
  }
}

variable "connection_id" {
  description = "The ID of the Direct Connect connection (or LAG) on which to create the virtual interface"
  type        = string

  validation {
    condition     = can(regex("^(dxcon|dxlag)-[0-9a-z]+$", var.connection_id))
    error_message = "resource_aws_dx_public_virtual_interface, connection_id must be a valid Direct Connect connection or LAG ID (starts with 'dxcon-' or 'dxlag-')."
  }
}

variable "name" {
  description = "The name for the virtual interface"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_dx_public_virtual_interface, name must be between 1 and 64 characters in length."
  }
}

variable "vlan" {
  description = "The VLAN ID"
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4094
    error_message = "resource_aws_dx_public_virtual_interface, vlan must be between 1 and 4094."
  }
}

variable "route_filter_prefixes" {
  description = "A list of routes to be advertised to the AWS network in this region"
  type        = list(string)

  validation {
    condition     = length(var.route_filter_prefixes) > 0
    error_message = "resource_aws_dx_public_virtual_interface, route_filter_prefixes must contain at least one route prefix."
  }

  validation {
    condition = alltrue([
      for prefix in var.route_filter_prefixes : can(cidrhost(prefix, 0))
    ])
    error_message = "resource_aws_dx_public_virtual_interface, route_filter_prefixes must contain valid CIDR notation prefixes."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers"
  type        = string
  default     = null

  validation {
    condition = var.amazon_address == null || (
      can(cidrhost(var.amazon_address, 0)) &&
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.amazon_address))
    )
    error_message = "resource_aws_dx_public_virtual_interface, amazon_address must be a valid IPv4 CIDR address when specified."
  }
}

variable "bgp_auth_key" {
  description = "The authentication key for BGP configuration"
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.bgp_auth_key == null || length(var.bgp_auth_key) <= 80
    error_message = "resource_aws_dx_public_virtual_interface, bgp_auth_key must be 80 characters or less when specified."
  }
}

variable "customer_address" {
  description = "The IPv4 CIDR destination address to which Amazon should send traffic. Required for IPv4 BGP peers"
  type        = string
  default     = null

  validation {
    condition = var.customer_address == null || (
      can(cidrhost(var.customer_address, 0)) &&
      can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}/[0-9]{1,2}$", var.customer_address))
    )
    error_message = "resource_aws_dx_public_virtual_interface, customer_address must be a valid IPv4 CIDR address when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 128 && length(v) <= 256
    ])
    error_message = "resource_aws_dx_public_virtual_interface, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the virtual interface"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_dx_public_virtual_interface, create_timeout must be a valid duration (e.g., '10m', '1h')."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the virtual interface"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_dx_public_virtual_interface, delete_timeout must be a valid duration (e.g., '10m', '1h')."
  }
}