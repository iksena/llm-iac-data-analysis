variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "internet_gateway_id" {
  description = "ID of the specific Internet Gateway to retrieve."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Internet Gateway."
  type        = map(string)
  default     = {}
}

variable "filters" {
  description = "List of custom filter blocks."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_internet_gateway, filters: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_internet_gateway, filters: filter values must contain at least one value."
  }
}

variable "read_timeout" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_internet_gateway, read_timeout: must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}