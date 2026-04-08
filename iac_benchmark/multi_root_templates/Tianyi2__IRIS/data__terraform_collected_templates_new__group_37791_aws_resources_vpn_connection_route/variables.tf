variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destination_cidr_block" {
  description = "The CIDR block associated with the local subnet of the customer network."
  type        = string

  validation {
    condition     = can(cidrhost(var.destination_cidr_block, 0))
    error_message = "resource_aws_vpn_connection_route, destination_cidr_block must be a valid CIDR block."
  }
}

variable "vpn_connection_id" {
  description = "The ID of the VPN connection."
  type        = string

  validation {
    condition     = can(regex("^vpn-[0-9a-f]{8,17}$", var.vpn_connection_id))
    error_message = "resource_aws_vpn_connection_route, vpn_connection_id must be a valid VPN connection ID starting with 'vpn-'."
  }
}