variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length."
  type        = string
  default     = null
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC. Default is default, which ensures that EC2 instances launched in this VPC use the EC2 instance tenancy attribute specified when the EC2 instance is launched."
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "resource_aws_vpc, instance_tenancy must be either 'default' or 'dedicated'."
  }
}

variable "ipv4_ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. IPAM is a VPC feature that you can use to automate your IP address management workflows including assigning, tracking, troubleshooting, and auditing IP addresses across AWS Regions and accounts."
  type        = string
  default     = null
}

variable "ipv4_netmask_length" {
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC. Requires specifying a ipv4_ipam_pool_id."
  type        = number
  default     = null
}

variable "ipv6_cidr_block" {
  description = "IPv6 CIDR block to request from an IPAM Pool. Can be set explicitly or derived from IPAM using ipv6_netmask_length."
  type        = string
  default     = null
}

variable "ipv6_ipam_pool_id" {
  description = "IPAM Pool ID for a IPv6 pool. Conflicts with assign_generated_ipv6_cidr_block."
  type        = string
  default     = null
}

variable "ipv6_netmask_length" {
  description = "Netmask length to request from IPAM Pool. Conflicts with ipv6_cidr_block. This can be omitted if IPAM pool as a allocation_default_netmask_length set. Valid values are from 44 to 60 in increments of 4."
  type        = number
  default     = null
  validation {
    condition     = var.ipv6_netmask_length == null || (var.ipv6_netmask_length >= 44 && var.ipv6_netmask_length <= 60 && var.ipv6_netmask_length % 4 == 0)
    error_message = "resource_aws_vpc, ipv6_netmask_length must be between 44 and 60 in increments of 4."
  }
}

variable "ipv6_cidr_block_network_border_group" {
  description = "By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC. This can be changed to restrict advertisement of public addresses to specific Network Border Groups such as LocalZones."
  type        = string
  default     = null
}

variable "enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults to true."
  type        = bool
  default     = true
}

variable "enable_network_address_usage_metrics" {
  description = "Indicates whether Network Address Usage metrics are enabled for your VPC. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  type        = bool
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false. Conflicts with ipv6_ipam_pool_id"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}