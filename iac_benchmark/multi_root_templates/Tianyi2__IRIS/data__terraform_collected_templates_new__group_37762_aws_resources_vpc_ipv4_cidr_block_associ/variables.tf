variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_block == null || can(cidrhost(var.cidr_block, 0))
    error_message = "resource_aws_vpc_ipv4_cidr_block_association, cidr_block must be a valid IPv4 CIDR block."
  }
}

variable "ipv4_ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. IPAM is a VPC feature that you can use to automate your IP address management workflows including assigning, tracking, troubleshooting, and auditing IP addresses across AWS Regions and accounts."
  type        = string
  default     = null

  validation {
    condition     = var.ipv4_ipam_pool_id == null || can(regex("^ipam-pool-[0-9a-f]{17}$", var.ipv4_ipam_pool_id))
    error_message = "resource_aws_vpc_ipv4_cidr_block_association, ipv4_ipam_pool_id must be a valid IPAM pool ID (ipam-pool-xxxxxxxxxxxxxxxxx)."
  }
}

variable "ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id."
  type        = number
  default     = null

  validation {
    condition     = var.ipv4_netmask_length == null || (var.ipv4_netmask_length >= 16 && var.ipv4_netmask_length <= 28)
    error_message = "resource_aws_vpc_ipv4_cidr_block_association, ipv4_netmask_length must be between 16 and 28."
  }

  validation {
    condition     = var.ipv4_netmask_length == null || var.ipv4_ipam_pool_id != null
    error_message = "resource_aws_vpc_ipv4_cidr_block_association, ipv4_netmask_length requires ipv4_ipam_pool_id to be specified."
  }
}

variable "vpc_id" {
  description = "The ID of the VPC to make the association with."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8,17}$", var.vpc_id))
    error_message = "resource_aws_vpc_ipv4_cidr_block_association, vpc_id must be a valid VPC ID (vpc-xxxxxxxx or vpc-xxxxxxxxxxxxxxxxx)."
  }
}

variable "timeouts" {
  description = "Configuration block(s) for setting request timeouts"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      can(regex("^[0-9]+[smh]$", var.timeouts.create)) &&
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    )
    error_message = "resource_aws_vpc_ipv4_cidr_block_association, timeouts values must be valid duration strings (e.g., '10m', '30s', '1h')."
  }
}