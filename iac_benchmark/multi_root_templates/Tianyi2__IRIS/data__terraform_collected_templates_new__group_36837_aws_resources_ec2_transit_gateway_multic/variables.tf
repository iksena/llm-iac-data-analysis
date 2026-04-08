variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "EC2 Transit Gateway identifier. The EC2 Transit Gateway must have multicast_support enabled."
  type        = string

  validation {
    condition     = can(regex("^tgw-[0-9a-f]{8,17}$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain, transit_gateway_id must be a valid Transit Gateway ID (format: tgw-xxxxxxxx)."
  }
}

variable "auto_accept_shared_associations" {
  description = "Whether to automatically accept cross-account subnet associations that are associated with the EC2 Transit Gateway Multicast Domain. Valid values: disable, enable."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.auto_accept_shared_associations)
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain, auto_accept_shared_associations must be either 'disable' or 'enable'."
  }
}

variable "igmpv2_support" {
  description = "Whether to enable Internet Group Management Protocol (IGMP) version 2 for the EC2 Transit Gateway Multicast Domain. Valid values: disable, enable."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.igmpv2_support)
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain, igmpv2_support must be either 'disable' or 'enable'."
  }
}

variable "static_sources_support" {
  description = "Whether to enable support for statically configuring multicast group sources for the EC2 Transit Gateway Multicast Domain. Valid values: disable, enable."
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.static_sources_support)
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain, static_sources_support must be either 'disable' or 'enable'."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Multicast Domain. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the EC2 Transit Gateway Multicast Domain."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain, create_timeout must be a valid duration string (e.g., '10m', '1h')."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the EC2 Transit Gateway Multicast Domain."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain, delete_timeout must be a valid duration string (e.g., '10m', '1h')."
  }
}