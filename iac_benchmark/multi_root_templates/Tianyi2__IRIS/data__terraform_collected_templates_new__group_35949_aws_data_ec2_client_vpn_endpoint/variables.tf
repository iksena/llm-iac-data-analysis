variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "client_vpn_endpoint_id" {
  description = "ID of the Client VPN endpoint."
  type        = string
  default     = null

  validation {
    condition     = var.client_vpn_endpoint_id == null || can(regex("^cvpn-endpoint-[a-zA-Z0-9]{17}$", var.client_vpn_endpoint_id))
    error_message = "data_aws_ec2_client_vpn_endpoint, client_vpn_endpoint_id must be a valid Client VPN endpoint ID starting with 'cvpn-endpoint-' followed by 17 alphanumeric characters."
  }
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : length(f.name) > 0
    ])
    error_message = "data_aws_ec2_client_vpn_endpoint, filter name cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_client_vpn_endpoint, filter values cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired endpoint."
  type        = map(string)
  default     = {}
}

variable "timeouts_read" {
  description = "Configuration for read timeout"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_client_vpn_endpoint, timeouts_read must be a valid duration format (e.g., '20m', '1h', '30s')."
  }
}