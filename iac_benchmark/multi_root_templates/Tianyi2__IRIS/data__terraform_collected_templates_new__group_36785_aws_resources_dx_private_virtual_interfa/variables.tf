variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "address_family" {
  description = "The address family for the BGP peer. ipv4 or ipv6."
  type        = string

  validation {
    condition     = contains(["ipv4", "ipv6"], var.address_family)
    error_message = "resource_aws_dx_private_virtual_interface, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration."
  type        = number

  validation {
    condition     = var.bgp_asn >= 1 && var.bgp_asn <= 4294967295
    error_message = "resource_aws_dx_private_virtual_interface, bgp_asn must be between 1 and 4294967295."
  }
}

variable "connection_id" {
  description = "The ID of the Direct Connect connection (or LAG) on which to create the virtual interface."
  type        = string

  validation {
    condition     = can(regex("^(dxcon-|dxlag-)[0-9a-f]{8}$", var.connection_id))
    error_message = "resource_aws_dx_private_virtual_interface, connection_id must be a valid Direct Connect connection or LAG ID."
  }
}

variable "name" {
  description = "The name for the virtual interface."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 100
    error_message = "resource_aws_dx_private_virtual_interface, name must be between 1 and 100 characters."
  }
}

variable "vlan" {
  description = "The VLAN ID."
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4094
    error_message = "resource_aws_dx_private_virtual_interface, vlan must be between 1 and 4094."
  }
}

variable "amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers."
  type        = string
  default     = null

  validation {
    condition     = var.amazon_address == null || can(cidrhost(var.amazon_address, 0))
    error_message = "resource_aws_dx_private_virtual_interface, amazon_address must be a valid IPv4 CIDR address."
  }
}

variable "bgp_auth_key" {
  description = "The authentication key for BGP configuration."
  type        = string
  default     = null
  sensitive   = true
}

variable "customer_address" {
  description = "The IPv4 CIDR destination address to which Amazon should send traffic. Required for IPv4 BGP peers."
  type        = string
  default     = null

  validation {
    condition     = var.customer_address == null || can(cidrhost(var.customer_address, 0))
    error_message = "resource_aws_dx_private_virtual_interface, customer_address must be a valid IPv4 CIDR address."
  }
}

variable "dx_gateway_id" {
  description = "The ID of the Direct Connect gateway to which to connect the virtual interface."
  type        = string
  default     = null

  validation {
    condition     = var.dx_gateway_id == null || can(regex("^dxgw-[0-9a-f]{8,17}$", var.dx_gateway_id))
    error_message = "resource_aws_dx_private_virtual_interface, dx_gateway_id must be a valid Direct Connect gateway ID."
  }
}

variable "mtu" {
  description = "The maximum transmission unit (MTU) is the size, in bytes, of the largest permissible packet that can be passed over the connection. The MTU of a virtual private interface can be either 1500 or 9001 (jumbo frames). Default is 1500."
  type        = number
  default     = 1500

  validation {
    condition     = contains([1500, 9001], var.mtu)
    error_message = "resource_aws_dx_private_virtual_interface, mtu must be either 1500 or 9001."
  }
}

variable "sitelink_enabled" {
  description = "Indicates whether to enable or disable SiteLink."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "vpn_gateway_id" {
  description = "The ID of the virtual private gateway to which to connect the virtual interface."
  type        = string
  default     = null

  validation {
    condition     = var.vpn_gateway_id == null || can(regex("^vgw-[0-9a-f]{8,17}$", var.vpn_gateway_id))
    error_message = "resource_aws_dx_private_virtual_interface, vpn_gateway_id must be a valid virtual private gateway ID."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the private virtual interface."
  type        = string
  default     = "10m"
}

variable "update_timeout" {
  description = "Timeout for updating the private virtual interface."
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the private virtual interface."
  type        = string
  default     = "10m"
}