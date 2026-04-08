variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "address_family" {
  description = "The IP protocol assigned to this pool. You must choose either IPv4 or IPv6 protocol for a pool."
  type        = string

  validation {
    condition     = contains(["ipv4", "ipv6"], var.address_family)
    error_message = "resource_aws_vpc_ipam_pool, address_family must be either 'ipv4' or 'ipv6'."
  }
}

variable "allocation_default_netmask_length" {
  description = "A default netmask length for allocations added to this pool. If, for example, the CIDR assigned to this pool is 10.0.0.0/8 and you enter 16 here, new allocations will default to 10.0.0.0/16 (unless you provide a different netmask value when you create the new allocation)."
  type        = number
  default     = null

  validation {
    condition     = var.allocation_default_netmask_length == null || (var.allocation_default_netmask_length >= 0 && var.allocation_default_netmask_length <= 128)
    error_message = "resource_aws_vpc_ipam_pool, allocation_default_netmask_length must be between 0 and 128."
  }
}

variable "allocation_max_netmask_length" {
  description = "The maximum netmask length that will be required for CIDR allocations in this pool."
  type        = number
  default     = null

  validation {
    condition     = var.allocation_max_netmask_length == null || (var.allocation_max_netmask_length >= 0 && var.allocation_max_netmask_length <= 128)
    error_message = "resource_aws_vpc_ipam_pool, allocation_max_netmask_length must be between 0 and 128."
  }
}

variable "allocation_min_netmask_length" {
  description = "The minimum netmask length that will be required for CIDR allocations in this pool."
  type        = number
  default     = null

  validation {
    condition     = var.allocation_min_netmask_length == null || (var.allocation_min_netmask_length >= 0 && var.allocation_min_netmask_length <= 128)
    error_message = "resource_aws_vpc_ipam_pool, allocation_min_netmask_length must be between 0 and 128."
  }
}

variable "allocation_resource_tags" {
  description = "Tags that are required for resources that use CIDRs from this IPAM pool. Resources that do not have these tags will not be allowed to allocate space from the pool. If the resources have their tags changed after they have allocated space or if the allocation tagging requirements are changed on the pool, the resource may be marked as noncompliant."
  type        = map(string)
  default     = null
}

variable "auto_import" {
  description = "If you include this argument, IPAM automatically imports any VPCs you have in your scope that fall within the CIDR range in the pool."
  type        = bool
  default     = null
}

variable "aws_service" {
  description = "Limits which AWS service the pool can be used in. Only useable on public scopes. Valid Values: ec2."
  type        = string
  default     = null

  validation {
    condition     = var.aws_service == null || var.aws_service == "ec2"
    error_message = "resource_aws_vpc_ipam_pool, aws_service must be 'ec2' when specified."
  }
}

variable "cascade" {
  description = "Enables you to quickly delete an IPAM pool and all resources within that pool, including provisioned CIDRs, allocations, and other pools."
  type        = bool
  default     = null
}

variable "description" {
  description = "A description for the IPAM pool."
  type        = string
  default     = null
}

variable "ipam_scope_id" {
  description = "The ID of the scope in which you would like to create the IPAM pool."
  type        = string

  validation {
    condition     = length(var.ipam_scope_id) > 0
    error_message = "resource_aws_vpc_ipam_pool, ipam_scope_id cannot be empty."
  }
}

variable "locale" {
  description = "The locale in which you would like to create the IPAM pool. Locale is the Region where you want to make an IPAM pool available for allocations. You can only create pools with locales that match the operating Regions of the IPAM. You can only create VPCs from a pool whose locale matches the VPC's Region. Possible values: Any AWS region, such as us-east-1."
  type        = string
  default     = null
}

variable "publicly_advertisable" {
  description = "Defines whether or not IPv6 pool space is publicly advertisable over the internet. This argument is required if address_family = 'ipv6' and public_ip_source = 'byoip', default is false. This option is not available for IPv4 pool space or if public_ip_source = 'amazon'. Setting this argument to true when it is not available may result in erroneous differences being reported."
  type        = bool
  default     = null
}

variable "public_ip_source" {
  description = "The IP address source for pools in the public scope. Only used for provisioning IP address CIDRs to pools in the public scope. Valid values are byoip or amazon. Default is byoip."
  type        = string
  default     = null

  validation {
    condition     = var.public_ip_source == null || contains(["byoip", "amazon"], var.public_ip_source)
    error_message = "resource_aws_vpc_ipam_pool, public_ip_source must be either 'byoip' or 'amazon'."
  }
}

variable "source_ipam_pool_id" {
  description = "The ID of the source IPAM pool. Use this argument to create a child pool within an existing pool."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}