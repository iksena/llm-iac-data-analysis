variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "ipam_pool_id" {
  type        = string
  description = "ID of the IPAM pool you would like the list of provisioned CIDRs."

  validation {
    condition     = can(regex("^ipam-pool-[0-9a-f]{8}([0-9a-f]{9}|[0-9a-f]{17})$", var.ipam_pool_id))
    error_message = "data_aws_vpc_ipam_pool_cidrs, ipam_pool_id must be a valid IPAM pool ID in the format 'ipam-pool-xxxxxxxxx'."
  }
}

variable "filter" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  default     = null
  description = "Custom filter block. Each filter should have a name and values."

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_ipam_pool_cidrs, filter name must be specified and cannot be empty."
  }

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc_ipam_pool_cidrs, filter values must contain at least one value."
  }
}

variable "timeouts_read" {
  type        = string
  default     = "1m"
  description = "Timeout for read operations."

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_vpc_ipam_pool_cidrs, timeouts_read must be a valid duration (e.g., '1m', '30s', '1h')."
  }
}