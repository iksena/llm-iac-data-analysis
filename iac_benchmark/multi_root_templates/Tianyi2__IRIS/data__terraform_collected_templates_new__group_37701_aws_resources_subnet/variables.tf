variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "assign_ipv6_address_on_creation" {
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address."
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "AZ for the subnet."
  type        = string
  default     = null
}

variable "availability_zone_id" {
  description = "AZ ID of the subnet. This argument is not supported in all regions or partitions. If necessary, use availability_zone instead."
  type        = string
  default     = null
}

variable "cidr_block" {
  description = "The IPv4 CIDR block for the subnet."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_block == null || can(cidrhost(var.cidr_block, 0))
    error_message = "resource_aws_subnet, cidr_block must be a valid IPv4 CIDR block."
  }
}

variable "customer_owned_ipv4_pool" {
  description = "The customer owned IPv4 address pool. Typically used with the map_customer_owned_ip_on_launch argument. The outpost_arn argument must be specified when configured."
  type        = string
  default     = null
}

variable "enable_dns64" {
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations."
  type        = bool
  default     = false
}

variable "enable_lni_at_device_index" {
  description = "Indicates the device position for local network interfaces in this subnet. For example, 1 indicates local network interfaces in this subnet are the secondary network interface (eth1). A local network interface cannot be the primary network interface (eth0)."
  type        = number
  default     = null

  validation {
    condition     = var.enable_lni_at_device_index == null || var.enable_lni_at_device_index >= 1
    error_message = "resource_aws_subnet, enable_lni_at_device_index must be 1 or greater as it cannot be the primary network interface (eth0)."
  }
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records."
  type        = bool
  default     = false
}

variable "enable_resource_name_dns_a_record_on_launch" {
  description = "Indicates whether to respond to DNS queries for instance hostnames with DNS A records."
  type        = bool
  default     = false
}

variable "ipv6_cidr_block" {
  description = "The IPv6 network range for the subnet, in CIDR notation. The subnet size must use a /64 prefix length."
  type        = string
  default     = null

  validation {
    condition     = var.ipv6_cidr_block == null || can(cidrhost(var.ipv6_cidr_block, 0)) && split("/", var.ipv6_cidr_block)[1] == "64"
    error_message = "resource_aws_subnet, ipv6_cidr_block must be a valid IPv6 CIDR block with /64 prefix length."
  }
}

variable "ipv6_native" {
  description = "Indicates whether to create an IPv6-only subnet."
  type        = bool
  default     = false
}

variable "map_customer_owned_ip_on_launch" {
  description = "Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The customer_owned_ipv4_pool and outpost_arn arguments must be specified when set to true."
  type        = bool
  default     = null
}

variable "map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = null
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the Outpost."
  type        = string
  default     = null

  validation {
    condition     = var.outpost_arn == null || can(regex("^arn:aws[a-z\\-]*:outposts:[a-z0-9\\-]*:[0-9]{12}:outpost/op-[a-z0-9]{8,17}$", var.outpost_arn))
    error_message = "resource_aws_subnet, outpost_arn must be a valid Outpost ARN."
  }
}

variable "private_dns_hostname_type_on_launch" {
  description = "The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID."
  type        = string
  default     = null

  validation {
    condition     = var.private_dns_hostname_type_on_launch == null || contains(["ip-name", "resource-name"], var.private_dns_hostname_type_on_launch)
    error_message = "resource_aws_subnet, private_dns_hostname_type_on_launch must be either 'ip-name' or 'resource-name'."
  }
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpc_id))
    error_message = "resource_aws_subnet, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "20m")
  })
  default = null
}