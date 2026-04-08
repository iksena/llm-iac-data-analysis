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
    error_message = "resource_aws_dx_transit_virtual_interface, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration."
  type        = number

  validation {
    condition     = var.bgp_asn > 0 && var.bgp_asn <= 4294967294
    error_message = "resource_aws_dx_transit_virtual_interface, bgp_asn must be a valid ASN between 1 and 4294967294."
  }
}

variable "connection_id" {
  description = "The ID of the Direct Connect connection (or LAG) on which to create the virtual interface."
  type        = string

  validation {
    condition     = length(var.connection_id) > 0
    error_message = "resource_aws_dx_transit_virtual_interface, connection_id cannot be empty."
  }
}

variable "dx_gateway_id" {
  description = "The ID of the Direct Connect gateway to which to connect the virtual interface."
  type        = string

  validation {
    condition     = length(var.dx_gateway_id) > 0
    error_message = "resource_aws_dx_transit_virtual_interface, dx_gateway_id cannot be empty."
  }
}

variable "name" {
  description = "The name for the virtual interface."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_dx_transit_virtual_interface, name cannot be empty."
  }
}

variable "vlan" {
  description = "The VLAN ID."
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4094
    error_message = "resource_aws_dx_transit_virtual_interface, vlan must be between 1 and 4094."
  }
}

variable "amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers."
  type        = string
  default     = null
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
}

variable "mtu" {
  description = "The maximum transmission unit (MTU) is the size, in bytes, of the largest permissible packet that can be passed over the connection. The MTU of a virtual transit interface can be either 1500 or 8500 (jumbo frames). Default is 1500."
  type        = number
  default     = 1500

  validation {
    condition     = contains([1500, 8500], var.mtu)
    error_message = "resource_aws_dx_transit_virtual_interface, mtu must be either 1500 or 8500."
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

variable "timeout_create" {
  description = "Timeout for creating the resource."
  type        = string
  default     = "10m"
}

variable "timeout_update" {
  description = "Timeout for updating the resource."
  type        = string
  default     = "10m"
}

variable "timeout_delete" {
  description = "Timeout for deleting the resource."
  type        = string
  default     = "10m"
}