variable "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  type        = string

  validation {
    condition     = can(regex("^cvpn-endpoint-[0-9a-f]{17}$", var.client_vpn_endpoint_id))
    error_message = "resource_aws_ec2_client_vpn_authorization_rule, client_vpn_endpoint_id must be a valid Client VPN endpoint ID starting with 'cvpn-endpoint-' followed by 17 hexadecimal characters."
  }
}

variable "target_network_cidr" {
  description = "The IPv4 address range, in CIDR notation, of the network to which the authorization rule applies"
  type        = string

  validation {
    condition     = can(cidrhost(var.target_network_cidr, 0))
    error_message = "resource_aws_ec2_client_vpn_authorization_rule, target_network_cidr must be a valid IPv4 CIDR block."
  }
}

variable "access_group_id" {
  description = "The ID of the group to which the authorization rule grants access. One of access_group_id or authorize_all_groups must be set"
  type        = string
  default     = null
}

variable "authorize_all_groups" {
  description = "Indicates whether the authorization rule grants access to all clients. One of access_group_id or authorize_all_groups must be set"
  type        = bool
  default     = null

  validation {
    condition     = (var.access_group_id != null && var.authorize_all_groups == null) || (var.access_group_id == null && var.authorize_all_groups != null) || (var.access_group_id != null && var.authorize_all_groups == false) || (var.authorize_all_groups == true && var.access_group_id == null)
    error_message = "resource_aws_ec2_client_vpn_authorization_rule, authorize_all_groups - exactly one of access_group_id or authorize_all_groups must be specified."
  }
}

variable "description" {
  description = "A brief description of the authorization rule"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 1 && length(var.description) <= 255)
    error_message = "resource_aws_ec2_client_vpn_authorization_rule, description must be between 1 and 255 characters when specified."
  }
}

variable "timeouts" {
  description = "Configuration block for customizing how long certain operations are allowed to take before being considered to have failed"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      can(regex("^[0-9]+[smh]$", var.timeouts.create)) &&
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    )
    error_message = "resource_aws_ec2_client_vpn_authorization_rule, timeouts values must be in valid duration format (e.g., '10m', '1h', '30s')."
  }
}