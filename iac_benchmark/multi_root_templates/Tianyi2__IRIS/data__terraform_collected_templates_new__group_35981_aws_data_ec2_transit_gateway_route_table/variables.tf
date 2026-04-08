variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "id" {
  description = "Identifier of the EC2 Transit Gateway Route Table."
  type        = string
  default     = null
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_route_table, filter: name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_route_table, filter: values is required and must contain at least one value."
  }
}

variable "timeouts_read" {
  description = "Read timeout for the Transit Gateway Route Table data source."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_transit_gateway_route_table, timeouts_read: must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}