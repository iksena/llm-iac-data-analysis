variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway to change the default association route table on."
  type        = string

  validation {
    condition     = can(regex("^tgw-[0-9a-z]+$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_association, transit_gateway_id must be a valid Transit Gateway ID starting with 'tgw-'."
  }
}

variable "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway Route Table to be made the default association route table."
  type        = string

  validation {
    condition     = can(regex("^tgw-rtb-[0-9a-z]+$", var.transit_gateway_route_table_id))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_association, transit_gateway_route_table_id must be a valid Transit Gateway Route Table ID starting with 'tgw-rtb-'."
  }
}

variable "timeouts_create" {
  description = "How long to wait for the resource to be created."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_association, timeouts_create must be a valid duration (e.g., '5m', '1h')."
  }
}

variable "timeouts_update" {
  description = "How long to wait for the resource to be updated."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_association, timeouts_update must be a valid duration (e.g., '5m', '1h')."
  }
}

variable "timeouts_delete" {
  description = "How long to wait for the resource to be deleted."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_ec2_transit_gateway_default_route_table_association, timeouts_delete must be a valid duration (e.g., '5m', '1h')."
  }
}