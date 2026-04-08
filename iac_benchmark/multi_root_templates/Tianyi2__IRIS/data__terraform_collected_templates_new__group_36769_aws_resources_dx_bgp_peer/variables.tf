variable "address_family" {
  description = "The address family for the BGP peer. ipv4 or ipv6."
  type        = string

  validation {
    condition     = contains(["ipv4", "ipv6"], var.address_family)
    error_message = "resource_aws_dx_bgp_peer, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration."
  type        = number

  validation {
    condition     = var.bgp_asn >= 1 && var.bgp_asn <= 4294967295
    error_message = "resource_aws_dx_bgp_peer, bgp_asn must be between 1 and 4294967295."
  }
}

variable "virtual_interface_id" {
  description = "The ID of the Direct Connect virtual interface on which to create the BGP peer."
  type        = string

  validation {
    condition     = length(var.virtual_interface_id) > 0
    error_message = "resource_aws_dx_bgp_peer, virtual_interface_id cannot be empty."
  }
}

variable "amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers on public virtual interfaces."
  type        = string
  default     = null

  validation {
    condition     = var.amazon_address == null || can(cidrhost(var.amazon_address, 0))
    error_message = "resource_aws_dx_bgp_peer, amazon_address must be a valid IPv4 CIDR address or null."
  }
}

variable "bgp_auth_key" {
  description = "The authentication key for BGP configuration."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.bgp_auth_key == null || length(var.bgp_auth_key) > 0
    error_message = "resource_aws_dx_bgp_peer, bgp_auth_key cannot be an empty string if provided."
  }
}

variable "customer_address" {
  description = "The IPv4 CIDR destination address to which Amazon should send traffic. Required for IPv4 BGP peers on public virtual interfaces."
  type        = string
  default     = null

  validation {
    condition     = var.customer_address == null || can(cidrhost(var.customer_address, 0))
    error_message = "resource_aws_dx_bgp_peer, customer_address must be a valid IPv4 CIDR address or null."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      (var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))) &&
      (var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete)))
    )
    error_message = "resource_aws_dx_bgp_peer, timeouts values must be in the format of '10m', '30s', or '1h'."
  }
}