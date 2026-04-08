variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_host, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "host_id" {
  description = "ID of the Dedicated Host."
  type        = string
  default     = null

  validation {
    condition     = var.host_id == null || can(regex("^h-[0-9a-f]{8,17}$", var.host_id))
    error_message = "data_aws_ec2_host, host_id must be a valid EC2 host ID format (h-xxxxxxxxx) or null."
  }
}

variable "filters" {
  description = "Configuration block for complex filters. You can use one or more filter blocks."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_ec2_host, filters each filter must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_ec2_host, filters each filter must have at least one value."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : alltrue([
        for value in filter.values : value != null && value != ""
      ])
    ])
    error_message = "data_aws_ec2_host, filters all filter values must be non-empty strings."
  }
}

variable "read_timeout" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_ec2_host, read_timeout must be a valid duration format (e.g., 20m, 30s, 1h)."
  }
}