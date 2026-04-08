variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_transit_gateway_route_tables, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "filter" {
  description = "Custom filter blocks to filter Transit Gateway Route Tables"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_route_tables, filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_route_tables, filter values must contain at least one value."
  }
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired transit gateway route table"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : k != "" && v != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_route_tables, tags keys and values cannot be empty strings."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the data source"
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_ec2_transit_gateway_route_tables, timeouts read must be a valid duration string (e.g., 20m, 1h, 30s)."
  }
}