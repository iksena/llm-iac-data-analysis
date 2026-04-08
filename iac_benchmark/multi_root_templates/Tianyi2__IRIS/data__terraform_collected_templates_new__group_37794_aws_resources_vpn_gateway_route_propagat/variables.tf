variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpn_gateway_id" {
  description = "The id of the aws_vpn_gateway to propagate routes from."
  type        = string

  validation {
    condition     = can(regex("^vgw-[0-9a-f]{8}([0-9a-f]{9})?$", var.vpn_gateway_id))
    error_message = "resource_aws_vpn_gateway_route_propagation, vpn_gateway_id must be a valid VPN Gateway ID (format: vgw-xxxxxxxxx)."
  }
}

variable "route_table_id" {
  description = "The id of the aws_route_table to propagate routes into."
  type        = string

  validation {
    condition     = can(regex("^rtb-[0-9a-f]{8}([0-9a-f]{9})?$", var.route_table_id))
    error_message = "resource_aws_vpn_gateway_route_propagation, route_table_id must be a valid Route Table ID (format: rtb-xxxxxxxxx)."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the VPN gateway route propagation (default: 2m)"
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_vpn_gateway_route_propagation, timeouts_create must be a valid timeout format (e.g., 2m, 30s, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the VPN gateway route propagation (default: 2m)"
  type        = string
  default     = "2m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_vpn_gateway_route_propagation, timeouts_delete must be a valid timeout format (e.g., 2m, 30s, 1h)."
  }
}