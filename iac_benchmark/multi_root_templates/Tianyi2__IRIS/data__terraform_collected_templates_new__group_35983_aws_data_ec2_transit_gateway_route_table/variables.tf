variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table."
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]{17}$", var.transit_gateway_route_table_id))
    error_message = "data_aws_ec2_transit_gateway_route_table_propagations, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID starting with 'tgw-rtb-'."
  }
}

variable "filter" {
  description = "Custom filter block for filtering Transit Gateway Route Table Propagations."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_route_table_propagations, filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_route_table_propagations, filter values cannot be empty."
  }
}