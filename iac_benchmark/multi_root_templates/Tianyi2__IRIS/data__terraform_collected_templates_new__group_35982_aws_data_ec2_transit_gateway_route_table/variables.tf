variable "transit_gateway_route_table_id" {
  description = "Identifier of EC2 Transit Gateway Route Table"
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]{8,17}$", var.transit_gateway_route_table_id))
    error_message = "data_aws_ec2_transit_gateway_route_table_associations, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID (format: tgw-rtb-xxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "filters" {
  description = "Custom filter block for filtering Transit Gateway Route Table Associations"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : can(regex("^[a-zA-Z0-9\\-_.]+$", filter.name))
    ])
    error_message = "data_aws_ec2_transit_gateway_route_table_associations, filters name must contain only alphanumeric characters, hyphens, underscores, and periods."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_route_table_associations, filters values must contain at least one value."
  }
}