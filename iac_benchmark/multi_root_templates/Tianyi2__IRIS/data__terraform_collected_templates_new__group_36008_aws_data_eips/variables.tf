variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_eips, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "filters" {
  description = "Custom filter blocks for filtering Elastic IPs."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_eips, filters each filter must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_eips, filters each filter must have at least one value."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Elastic IPs."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags : key != null && key != "" && value != null
    ])
    error_message = "data_aws_eips, tags keys and values must not be null or empty."
  }
}

variable "timeouts" {
  description = "Configuration block with read timeout."
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_eips, timeouts read timeout must be in format like '20m', '1h', or '30s'."
  }
}