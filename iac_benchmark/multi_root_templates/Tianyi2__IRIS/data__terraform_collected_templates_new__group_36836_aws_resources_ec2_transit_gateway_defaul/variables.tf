variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_propagation, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway to change the default association route table on."
  type        = string

  validation {
    condition     = can(regex("^tgw-[0-9a-f]{8,17}$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_propagation, transit_gateway_id must be a valid Transit Gateway ID (e.g., tgw-xxxxxxxxx)."
  }
}

variable "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway Route Table to be made the default association route table."
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-f]{8,17}$", var.transit_gateway_route_table_id))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_propagation, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID (e.g., tgw-rtb-xxxxxxxxx)."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_propagation, timeouts_create must be a valid timeout format (e.g., 5m, 10s, 1h)."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_propagation, timeouts_update must be a valid timeout format (e.g., 5m, 10s, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_propagation, timeouts_delete must be a valid timeout format (e.g., 5m, 10s, 1h)."
  }
}