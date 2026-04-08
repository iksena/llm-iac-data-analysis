variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "ipam_pool_id" {
  description = "ID of the IPAM pool you would like information on."
  type        = string
  default     = null

  validation {
    condition     = var.ipam_pool_id == null || can(regex("^ipam-pool-[0-9a-f]{17}$", var.ipam_pool_id))
    error_message = "data_aws_vpc_ipam_pool, ipam_pool_id must be a valid IPAM pool ID format (ipam-pool-xxxxxxxxxxxxxxxxx) or null."
  }
}

variable "filters" {
  description = "Custom filter blocks to filter IPAM pools."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_vpc_ipam_pool, filters each filter must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_vpc_ipam_pool, filters each filter must have at least one value."
  }
}

variable "read_timeout" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.read_timeout))
    error_message = "data_aws_vpc_ipam_pool, read_timeout must be a valid duration format (e.g., '20m', '1h', '30s')."
  }
}