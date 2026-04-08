variable "ipam_pool_id" {
  description = "The ID of the pool to which you want to assign a CIDR"
  type        = string

  validation {
    condition     = length(var.ipam_pool_id) > 0
    error_message = "resource_aws_vpc_ipam_preview_next_cidr, ipam_pool_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "disallowed_cidrs" {
  description = "Exclude a particular CIDR range from being returned by the pool"
  type        = list(string)
  default     = null

  validation {
    condition = var.disallowed_cidrs == null ? true : alltrue([
      for cidr in var.disallowed_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_vpc_ipam_preview_next_cidr, disallowed_cidrs must contain valid CIDR blocks."
  }
}

variable "netmask_length" {
  description = "The netmask length of the CIDR you would like to preview from the IPAM pool"
  type        = number
  default     = null

  validation {
    condition     = var.netmask_length == null ? true : (var.netmask_length >= 0 && var.netmask_length <= 32)
    error_message = "resource_aws_vpc_ipam_preview_next_cidr, netmask_length must be between 0 and 32."
  }
}