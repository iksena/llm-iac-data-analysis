variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table"
  type        = string

  validation {
    condition     = length(var.transit_gateway_route_table_id) > 0
    error_message = "data_aws_ec2_transit_gateway_route_table_routes, transit_gateway_route_table_id must not be empty."
  }
}

variable "filter" {
  description = "Custom filter block. More complex filters can be expressed using one or more filter sub-blocks"
  type = list(object({
    name   = string
    values = list(string)
  }))

  validation {
    condition     = length(var.filter) > 0
    error_message = "data_aws_ec2_transit_gateway_route_table_routes, filter is required and must contain at least one filter."
  }

  validation {
    condition     = alltrue([for f in var.filter : length(f.name) > 0])
    error_message = "data_aws_ec2_transit_gateway_route_table_routes, filter name must not be empty."
  }

  validation {
    condition     = alltrue([for f in var.filter : length(f.values) > 0])
    error_message = "data_aws_ec2_transit_gateway_route_table_routes, filter values must contain at least one value."
  }
}