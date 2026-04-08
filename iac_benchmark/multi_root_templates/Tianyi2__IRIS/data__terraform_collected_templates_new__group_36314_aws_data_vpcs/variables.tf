variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_vpcs, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired vpcs."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "data_aws_vpcs, tags must be a valid map of string key-value pairs."
  }
}

variable "filter" {
  description = "Custom filter block for more complex filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_vpcs, filter name must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpcs, filter values must not be empty."
  }
}

variable "read_timeout" {
  description = "Read timeout for the data source."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.read_timeout))
    error_message = "data_aws_vpcs, read_timeout must be a valid duration format (e.g., 20m, 5h, 30s)."
  }
}