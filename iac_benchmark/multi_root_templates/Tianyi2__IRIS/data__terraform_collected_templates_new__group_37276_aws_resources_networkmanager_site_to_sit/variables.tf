variable "core_network_id" {
  description = "ID of a core network for the VPN attachment"
  type        = string

  validation {
    condition     = can(regex("^cn-[0-9a-f]{17}$", var.core_network_id))
    error_message = "resource_aws_networkmanager_site_to_site_vpn_attachment, core_network_id must be a valid core network ID (format: cn-xxxxxxxxxxxxxxxxx)"
  }
}

variable "vpn_connection_arn" {
  description = "ARN of the site-to-site VPN connection"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:vpn-connection/vpn-[0-9a-f]{17}$", var.vpn_connection_arn))
    error_message = "resource_aws_networkmanager_site_to_site_vpn_attachment, vpn_connection_arn must be a valid VPN connection ARN"
  }
}

variable "tags" {
  description = "Key-value tags for the attachment"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s\\.\\-_:/@+]*$", k)) && length(k) <= 128
    ])
    error_message = "resource_aws_networkmanager_site_to_site_vpn_attachment, tags keys must be valid tag keys (max 128 characters, alphanumeric, spaces, and ._-:/@+)"
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : length(v) <= 256
    ])
    error_message = "resource_aws_networkmanager_site_to_site_vpn_attachment, tags values must not exceed 256 characters"
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
    update = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
    update = "10m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update))
    ])
    error_message = "resource_aws_networkmanager_site_to_site_vpn_attachment, timeouts must be valid timeout strings (e.g., '10m', '1h', '30s')"
  }
}