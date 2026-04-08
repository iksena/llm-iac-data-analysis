variable "ipam_pool_id" {
  description = "ID of the pool to which you want to assign a CIDR"
  type        = string

  validation {
    condition     = length(var.ipam_pool_id) > 0
    error_message = "data_aws_vpc_ipam_preview_next_cidr, ipam_pool_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_vpc_ipam_preview_next_cidr, region must be a non-empty string when specified."
  }
}

variable "disallowed_cidrs" {
  description = "Exclude a particular CIDR range from being returned by the pool"
  type        = list(string)
  default     = null

  validation {
    condition = var.disallowed_cidrs == null || alltrue([
      for cidr in var.disallowed_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "data_aws_vpc_ipam_preview_next_cidr, disallowed_cidrs must contain valid CIDR blocks."
  }
}

variable "netmask_length" {
  description = "Netmask length of the CIDR you would like to preview from the IPAM pool"
  type        = number
  default     = null

  validation {
    condition     = var.netmask_length == null || (var.netmask_length >= 0 && var.netmask_length <= 32)
    error_message = "data_aws_vpc_ipam_preview_next_cidr, netmask_length must be between 0 and 32."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    read = optional(string, "20m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.read == null ||
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.read))
    )
    error_message = "data_aws_vpc_ipam_preview_next_cidr, timeouts.read must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}