variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512

  validation {
    condition = (
      var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534
      ) || (
      var.amazon_side_asn >= 4200000000 && var.amazon_side_asn <= 4294967294
    )
    error_message = "resource_aws_ec2_transit_gateway, amazon_side_asn must be in range 64512-65534 for 16-bit ASNs or 4200000000-4294967294 for 32-bit ASNs."
  }
}

variable "auto_accept_shared_attachments" {
  description = "Whether resource attachment requests are automatically accepted"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.auto_accept_shared_attachments)
    error_message = "resource_aws_ec2_transit_gateway, auto_accept_shared_attachments must be either 'disable' or 'enable'."
  }
}

variable "default_route_table_association" {
  description = "Whether resource attachments are automatically associated with the default association route table"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.default_route_table_association)
    error_message = "resource_aws_ec2_transit_gateway, default_route_table_association must be either 'disable' or 'enable'."
  }
}

variable "default_route_table_propagation" {
  description = "Whether resource attachments automatically propagate routes to the default propagation route table"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.default_route_table_propagation)
    error_message = "resource_aws_ec2_transit_gateway, default_route_table_propagation must be either 'disable' or 'enable'."
  }
}

variable "description" {
  description = "Description of the EC2 Transit Gateway"
  type        = string
  default     = null
}

variable "dns_support" {
  description = "Whether DNS support is enabled"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.dns_support)
    error_message = "resource_aws_ec2_transit_gateway, dns_support must be either 'disable' or 'enable'."
  }
}

variable "security_group_referencing_support" {
  description = "Whether Security Group Referencing Support is enabled"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.security_group_referencing_support)
    error_message = "resource_aws_ec2_transit_gateway, security_group_referencing_support must be either 'disable' or 'enable'."
  }
}

variable "multicast_support" {
  description = "Whether Multicast support is enabled"
  type        = string
  default     = "disable"

  validation {
    condition     = contains(["disable", "enable"], var.multicast_support)
    error_message = "resource_aws_ec2_transit_gateway, multicast_support must be either 'disable' or 'enable'."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway"
  type        = map(string)
  default     = {}
}

variable "transit_gateway_cidr_blocks" {
  description = "One or more IPv4 or IPv6 CIDR blocks for the transit gateway"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.transit_gateway_cidr_blocks :
      can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_ec2_transit_gateway, transit_gateway_cidr_blocks must contain valid CIDR blocks."
  }
}

variable "vpn_ecmp_support" {
  description = "Whether VPN Equal Cost Multipath Protocol support is enabled"
  type        = string
  default     = "enable"

  validation {
    condition     = contains(["disable", "enable"], var.vpn_ecmp_support)
    error_message = "resource_aws_ec2_transit_gateway, vpn_ecmp_support must be either 'disable' or 'enable'."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the Transit Gateway"
  type        = string
  default     = "10m"
}

variable "timeouts_update" {
  description = "Timeout for updating the Transit Gateway"
  type        = string
  default     = "10m"
}

variable "timeouts_delete" {
  description = "Timeout for deleting the Transit Gateway"
  type        = string
  default     = "10m"
}