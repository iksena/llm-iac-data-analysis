variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "filter" {
  description = "Custom filter blocks"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : can(regex("^.+$", f.name))
    ])
    error_message = "data_aws_subnets, filter: name must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_subnets, filter: values must contain at least one value."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired subnets"
  type        = map(string)
  default     = {}
}

variable "read_timeout" {
  description = "Read timeout for the data source"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_subnets, read_timeout: timeout must be a valid duration (e.g., 20m, 5s, 1h)."
  }
}