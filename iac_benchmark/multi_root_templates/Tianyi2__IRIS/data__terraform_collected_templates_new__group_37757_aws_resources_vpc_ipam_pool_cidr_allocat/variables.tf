variable "region" {
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr" {
  description = "(Optional, Forces new resource) The CIDR you want to assign to the pool."
  type        = string
  default     = null

  validation {
    condition     = var.cidr == null || can(cidrhost(var.cidr, 0))
    error_message = "resource_aws_vpc_ipam_pool_cidr_allocation, cidr must be a valid CIDR notation."
  }
}

variable "description" {
  description = "(Optional, Forces new resource) The description for the allocation."
  type        = string
  default     = null
}

variable "disallowed_cidrs" {
  description = "(Optional, Forces new resource) Exclude a particular CIDR range from being returned by the pool."
  type        = list(string)
  default     = null

  validation {
    condition = var.disallowed_cidrs == null || alltrue([
      for cidr in var.disallowed_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_vpc_ipam_pool_cidr_allocation, disallowed_cidrs must contain valid CIDR notations."
  }
}

variable "ipam_pool_id" {
  description = "(Required, Forces new resource) The ID of the pool to which you want to assign a CIDR."
  type        = string

  validation {
    condition     = length(var.ipam_pool_id) > 0
    error_message = "resource_aws_vpc_ipam_pool_cidr_allocation, ipam_pool_id cannot be empty."
  }
}

variable "netmask_length" {
  description = "(Optional, Forces new resource) The netmask length of the CIDR you would like to allocate to the IPAM pool. Valid Values: 0-128."
  type        = number
  default     = null

  validation {
    condition     = var.netmask_length == null || (var.netmask_length >= 0 && var.netmask_length <= 128)
    error_message = "resource_aws_vpc_ipam_pool_cidr_allocation, netmask_length must be between 0 and 128 inclusive."
  }
}