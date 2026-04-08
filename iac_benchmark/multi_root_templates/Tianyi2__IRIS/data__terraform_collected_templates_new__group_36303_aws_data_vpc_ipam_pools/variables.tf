variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "filter" {
  description = "Custom filter block"
  type = list(object({
    name   = string
    values = list(string)
  }))

  validation {
    condition     = length(var.filter) > 0
    error_message = "data_aws_vpc_ipam_pools, filter - at least one filter block must be provided."
  }

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_ipam_pools, filter.name - filter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc_ipam_pools, filter.values - filter values are required and cannot be empty."
  }
}