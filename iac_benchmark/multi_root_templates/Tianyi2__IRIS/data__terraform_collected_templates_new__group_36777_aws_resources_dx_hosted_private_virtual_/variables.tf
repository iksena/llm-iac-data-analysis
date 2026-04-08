variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "address_family" {
  description = "The address family for the BGP peer"
  type        = string

  validation {
    condition     = contains(["ipv4", "ipv6"], var.address_family)
    error_message = "resource_aws_dx_hosted_private_virtual_interface, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration"
  type        = number

  validation {
    condition     = var.bgp_asn >= 1 && var.bgp_asn <= 4294967294
    error_message = "resource_aws_dx_hosted_private_virtual_interface, bgp_asn must be a valid AS number between 1 and 4294967294."
  }
}

variable "connection_id" {
  description = "The ID of the Direct Connect connection (or LAG) on which to create the virtual interface"
  type        = string

  validation {
    condition     = can(regex("^(dxcon|dxlag)-[0-9a-f]{8}$", var.connection_id))
    error_message = "resource_aws_dx_hosted_private_virtual_interface, connection_id must be a valid Direct Connect connection ID starting with 'dxcon-' or 'dxlag-' followed by 8 hexadecimal characters."
  }
}

variable "name" {
  description = "The name for the virtual interface"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_dx_hosted_private_virtual_interface, name must be between 1 and 128 characters in length."
  }
}

variable "owner_account_id" {
  description = "The AWS account that will own the new virtual interface"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.owner_account_id))
    error_message = "resource_aws_dx_hosted_private_virtual_interface, owner_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "vlan" {
  description = "The VLAN ID"
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4094
    error_message = "resource_aws_dx_hosted_private_virtual_interface, vlan must be between 1 and 4094."
  }
}

variable "amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers"
  type        = string
  default     = null

  validation {
    condition     = var.amazon_address == null || can(cidrhost(var.amazon_address, 0))
    error_message = "resource_aws_dx_hosted_private_virtual_interface, amazon_address must be a valid IPv4 CIDR address."
  }
}

variable "mtu" {
  description = "The maximum transmission unit (MTU) is the size, in bytes, of the largest permissible packet that can be passed over the connection"
  type        = number
  default     = 1500

  validation {
    condition     = contains([1500, 9001], var.mtu)
    error_message = "resource_aws_dx_hosted_private_virtual_interface, mtu must be either 1500 or 9001."
  }
}

variable "bgp_auth_key" {
  description = "The authentication key for BGP configuration"
  type        = string
  default     = null
  sensitive   = true
}

variable "customer_address" {
  description = "The IPv4 CIDR destination address to which Amazon should send traffic. Required for IPv4 BGP peers"
  type        = string
  default     = null

  validation {
    condition     = var.customer_address == null || can(cidrhost(var.customer_address, 0))
    error_message = "resource_aws_dx_hosted_private_virtual_interface, customer_address must be a valid IPv4 CIDR address."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation"
  type        = string
  default     = "10m"
}


variable "timeouts_delete" {
  description = "Timeout for delete operation"
  type        = string
  default     = "10m"
}