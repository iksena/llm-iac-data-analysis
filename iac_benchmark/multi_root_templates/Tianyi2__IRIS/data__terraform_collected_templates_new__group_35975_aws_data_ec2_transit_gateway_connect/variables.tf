variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters"
  type = object({
    name   = string
    values = list(string)
  })
  default = null

  validation {
    condition = var.filter == null || (
      var.filter.name != null &&
      var.filter.values != null &&
      length(var.filter.values) > 0
    )
    error_message = "data_aws_ec2_transit_gateway_connect, filter: When filter is provided, both name and values must be specified, and values must not be empty."
  }

  validation {
    condition     = var.filter == null || can(regex("^[a-zA-Z0-9-_.]+$", var.filter.name))
    error_message = "data_aws_ec2_transit_gateway_connect, filter: Filter name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "transit_gateway_connect_id" {
  description = "Identifier of the EC2 Transit Gateway Connect"
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_connect_id == null || can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_connect_id))
    error_message = "data_aws_ec2_transit_gateway_connect, transit_gateway_connect_id: Must be a valid Transit Gateway Connect ID (tgw-attach-xxxxxxxx)."
  }
}

variable "read_timeout" {
  description = "Read timeout for the data source"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.read_timeout))
    error_message = "data_aws_ec2_transit_gateway_connect, read_timeout: Must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}