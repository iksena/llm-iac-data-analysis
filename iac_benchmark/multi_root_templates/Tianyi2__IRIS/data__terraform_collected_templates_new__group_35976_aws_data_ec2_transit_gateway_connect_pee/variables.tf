variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
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
    error_message = "data_aws_ec2_transit_gateway_connect_peer, filter name must be specified and cannot be empty."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_ec2_transit_gateway_connect_peer, filter values must be specified and cannot be empty."
  }
}

variable "transit_gateway_connect_peer_id" {
  description = "Identifier of the EC2 Transit Gateway Connect Peer."
  type        = string
  default     = null

  validation {
    condition     = var.transit_gateway_connect_peer_id == null || can(regex("^tgw-connect-peer-[0-9a-fA-F]{8,17}$", var.transit_gateway_connect_peer_id))
    error_message = "data_aws_ec2_transit_gateway_connect_peer, transit_gateway_connect_peer_id must be a valid Transit Gateway Connect Peer ID format (tgw-connect-peer-xxxxxxxx)."
  }
}

variable "timeouts_read" {
  description = "Timeout configuration for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_transit_gateway_connect_peer, timeouts_read must be a valid timeout format (e.g., '20m', '1h', '300s')."
  }
}