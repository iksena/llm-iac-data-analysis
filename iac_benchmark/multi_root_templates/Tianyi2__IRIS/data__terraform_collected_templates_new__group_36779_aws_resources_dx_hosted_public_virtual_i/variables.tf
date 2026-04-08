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
    error_message = "resource_aws_dx_hosted_public_virtual_interface, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration."
  type        = number

  validation {
    condition     = var.bgp_asn >= 1 && var.bgp_asn <= 4294967294
    error_message = "resource_aws_dx_hosted_public_virtual_interface, bgp_asn must be between 1 and 4294967294."
  }
}

variable "connection_id" {
  description = "The ID of the Direct Connect connection (or LAG) on which to create the virtual interface."
  type        = string

  validation {
    condition     = can(regex("^dxcon-[a-z0-9]+$", var.connection_id)) || can(regex("^dxlag-[a-z0-9]+$", var.connection_id))
    error_message = "resource_aws_dx_hosted_public_virtual_interface, connection_id must be a valid Direct Connect connection ID (dxcon-*) or LAG ID (dxlag-*)."
  }
}

variable "name" {
  description = "The name for the virtual interface."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 100
    error_message = "resource_aws_dx_hosted_public_virtual_interface, name must be between 1 and 100 characters."
  }
}

variable "owner_account_id" {
  description = "The AWS account that will own the new virtual interface."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.owner_account_id))
    error_message = "resource_aws_dx_hosted_public_virtual_interface, owner_account_id must be a valid 12-digit AWS account ID."
  }
}

variable "route_filter_prefixes" {
  description = "A list of routes to be advertised to the AWS network in this region."
  type        = list(string)

  validation {
    condition     = length(var.route_filter_prefixes) > 0
    error_message = "resource_aws_dx_hosted_public_virtual_interface, route_filter_prefixes must contain at least one prefix."
  }

  validation {
    condition = alltrue([
      for prefix in var.route_filter_prefixes : can(cidrhost(prefix, 0))
    ])
    error_message = "resource_aws_dx_hosted_public_virtual_interface, route_filter_prefixes must contain valid CIDR blocks."
  }
}

variable "vlan" {
  description = "The VLAN ID."
  type        = number

  validation {
    condition     = var.vlan >= 1 && var.vlan <= 4094
    error_message = "resource_aws_dx_hosted_public_virtual_interface, vlan must be between 1 and 4094."
  }
}

variable "amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers."
  type        = string
  default     = null

  validation {
    condition     = var.amazon_address == null || can(cidrhost(var.amazon_address, 0))
    error_message = "resource_aws_dx_hosted_public_virtual_interface, amazon_address must be a valid CIDR block when specified."
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
    error_message = "resource_aws_dx_hosted_public_virtual_interface, customer_address must be a valid CIDR block when specified."
  }
}

variable "timeout_create" {
  description = "Timeout for creating the virtual interface."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_create))
    error_message = "resource_aws_dx_hosted_public_virtual_interface, timeout_create must be a valid duration (e.g., '10m', '1h')."
  }
}

variable "timeout_delete" {
  description = "Timeout for deleting the virtual interface."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_delete))
    error_message = "resource_aws_dx_hosted_public_virtual_interface, timeout_delete must be a valid duration (e.g., '10m', '1h')."
  }
}