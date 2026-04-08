variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_network_interfaces, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags, each pair of which must exactly match a pair on the desired network interfaces."
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "data_aws_network_interfaces, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "filters" {
  type = list(object({
    name   = string
    values = list(string)
  }))
  description = "Custom filter block. Each filter must have a name and values."
  default     = []

  validation {
    condition     = alltrue([for filter in var.filters : length(filter.name) > 0])
    error_message = "data_aws_network_interfaces, filters name cannot be empty."
  }

  validation {
    condition     = alltrue([for filter in var.filters : length(filter.values) > 0])
    error_message = "data_aws_network_interfaces, filters values cannot be empty."
  }
}

variable "timeouts_read" {
  type        = string
  description = "Configuration options for read timeout."
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_network_interfaces, timeouts_read must be a valid duration format (e.g., 20m, 1h, 300s)."
  }
}