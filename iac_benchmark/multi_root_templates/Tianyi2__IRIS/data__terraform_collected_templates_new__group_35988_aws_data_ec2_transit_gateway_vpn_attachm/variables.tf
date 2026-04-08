variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "Identifier of the EC2 Transit Gateway."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_id == null || can(regex("^tgw-[0-9a-f]{8,17}$", var.transit_gateway_id))
    error_message = "data_aws_ec2_transit_gateway_vpn_attachment, transit_gateway_id must be a valid Transit Gateway ID (tgw-xxxxxxxx)."
  }
}

variable "vpn_connection_id" {
  description = "Identifier of the EC2 VPN Connection."
  type        = string
  default     = null

  validation {
    condition     = var.vpn_connection_id == null || can(regex("^vpn-[0-9a-f]{8,17}$", var.vpn_connection_id))
    error_message = "data_aws_ec2_transit_gateway_vpn_attachment, vpn_connection_id must be a valid VPN Connection ID (vpn-xxxxxxxx)."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_transit_gateway_vpn_attachment, filter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_vpn_attachment, filter values must contain at least one value."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired Transit Gateway VPN Attachment."
  type        = map(string)
  default     = {}
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_transit_gateway_vpn_attachment, timeouts_read must be a valid duration (e.g., 20m, 1h, 30s)."
  }
}