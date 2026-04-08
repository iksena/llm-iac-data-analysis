variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr" {
  description = "The CIDR you want to assign to the pool. Conflicts with netmask_length."
  type        = string
  default     = null
}

variable "ipam_pool_id" {
  description = "The ID of the pool to which you want to assign a CIDR."
  type        = string

  validation {
    condition     = can(regex("^ipam-pool-[0-9a-f]+$", var.ipam_pool_id))
    error_message = "resource_aws_vpc_ipam_pool_cidr, ipam_pool_id must be a valid IPAM Pool ID in the format 'ipam-pool-<id>'."
  }
}

variable "netmask_length" {
  description = "If provided, the cidr provisioned into the specified pool will be the next available cidr given this declared netmask length. Conflicts with cidr."
  type        = number
  default     = null

  validation {
    condition     = var.netmask_length == null || (var.netmask_length >= 0 && var.netmask_length <= 128)
    error_message = "resource_aws_vpc_ipam_pool_cidr, netmask_length must be between 0 and 128."
  }
}

variable "cidr_authorization_context" {
  description = "A signed document that proves that you are authorized to bring the specified IP address range to Amazon using BYOIP."
  type = object({
    message   = optional(string)
    signature = optional(string)
  })
  default = null

  validation {
    condition = var.cidr_authorization_context == null || (
      var.cidr_authorization_context.message != null &&
      var.cidr_authorization_context.signature != null
    )
    error_message = "resource_aws_vpc_ipam_pool_cidr, cidr_authorization_context when specified, both message and signature must be provided."
  }
}