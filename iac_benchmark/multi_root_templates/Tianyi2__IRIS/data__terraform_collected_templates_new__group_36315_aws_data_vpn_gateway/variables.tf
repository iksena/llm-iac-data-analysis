variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_vpn_gateway, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "id" {
  type        = string
  description = "ID of the specific VPN Gateway to retrieve."
  default     = null

  validation {
    condition     = var.id == null || can(regex("^vgw-[0-9a-f]{8,17}$", var.id))
    error_message = "data_aws_vpn_gateway, id must be a valid VPN Gateway ID format (e.g., vgw-12345678)."
  }
}

variable "state" {
  type        = string
  description = "State of the specific VPN Gateway to retrieve."
  default     = null

  validation {
    condition     = var.state == null || contains(["pending", "available", "deleting", "deleted"], var.state)
    error_message = "data_aws_vpn_gateway, state must be one of: pending, available, deleting, deleted."
  }
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone of the specific VPN Gateway to retrieve."
  default     = null

  validation {
    condition     = var.availability_zone == null || can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.availability_zone))
    error_message = "data_aws_vpn_gateway, availability_zone must be a valid AWS availability zone format (e.g., us-west-2a)."
  }
}

variable "attached_vpc_id" {
  type        = string
  description = "ID of a VPC attached to the specific VPN Gateway to retrieve."
  default     = null

  validation {
    condition     = var.attached_vpc_id == null || can(regex("^vpc-[0-9a-f]{8,17}$", var.attached_vpc_id))
    error_message = "data_aws_vpn_gateway, attached_vpc_id must be a valid VPC ID format (e.g., vpc-12345678)."
  }
}

variable "filter" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  description = "Custom filter block for querying VPN gateways."
  default     = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_vpn_gateway, filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpn_gateway, filter values cannot be empty."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags, each pair of which must exactly match a pair on the desired VPN Gateway."
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) > 0 && length(v) > 0
    ])
    error_message = "data_aws_vpn_gateway, tags keys and values cannot be empty."
  }
}

variable "amazon_side_asn" {
  type        = number
  description = "Autonomous System Number (ASN) for the Amazon side of the specific VPN Gateway to retrieve."
  default     = null

  validation {
    condition     = var.amazon_side_asn == null || (var.amazon_side_asn >= 64512 && var.amazon_side_asn <= 65534) || var.amazon_side_asn == 7224
    error_message = "data_aws_vpn_gateway, amazon_side_asn must be a valid ASN (64512-65534 for private ASNs or 7224 for Amazon default)."
  }
}