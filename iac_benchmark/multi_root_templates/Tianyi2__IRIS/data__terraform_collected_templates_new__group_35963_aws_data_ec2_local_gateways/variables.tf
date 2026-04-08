variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_local_gateways, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired local_gateways."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) >= 0
    error_message = "data_aws_ec2_local_gateways, tags must be a valid map of string key-value pairs."
  }
}

variable "filter" {
  description = "Custom filter blocks to filter Local Gateways."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_local_gateways, filter name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_local_gateways, filter values must contain at least one value."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.read))
    error_message = "data_aws_ec2_local_gateways, timeouts.read must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}