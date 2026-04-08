variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired local gateway route table."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(var.tags)
    error_message = "data_aws_ec2_local_gateway_route_tables, tags must be a valid map of strings."
  }
}

variable "filters" {
  description = "Custom filter blocks"
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : can(filter.name) && length(filter.name) > 0
    ])
    error_message = "data_aws_ec2_local_gateway_route_tables, filters must have a non-empty name."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : can(filter.values) && length(filter.values) > 0
    ])
    error_message = "data_aws_ec2_local_gateway_route_tables, filters must have at least one value."
  }
}

variable "timeouts_read" {
  description = "Read timeout for the data source"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_local_gateway_route_tables, timeouts_read must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}