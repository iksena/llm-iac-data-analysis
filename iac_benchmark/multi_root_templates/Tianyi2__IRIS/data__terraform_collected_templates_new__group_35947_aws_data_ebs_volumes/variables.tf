variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "filters" {
  description = "Custom filter blocks"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.name) > 0
    ])
    error_message = "data_aws_ebs_volumes, filters: filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_ebs_volumes, filters: filter values cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired volumes"
  type        = map(string)
  default     = {}
}

variable "read_timeout" {
  description = "Read timeout for the data source"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_ebs_volumes, read_timeout must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}