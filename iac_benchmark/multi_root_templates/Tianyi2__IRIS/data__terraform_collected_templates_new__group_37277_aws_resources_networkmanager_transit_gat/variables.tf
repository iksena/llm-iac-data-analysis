variable "device_id" {
  description = "ID of the device."
  type        = string

  validation {
    condition     = can(regex("^device-[0-9a-f]{17}$", var.device_id))
    error_message = "resource_aws_networkmanager_transit_gateway_connect_peer_association, device_id must be a valid device ID in the format 'device-' followed by 17 alphanumeric characters."
  }
}

variable "global_network_id" {
  description = "ID of the global network."
  type        = string

  validation {
    condition     = can(regex("^global-network-[0-9a-f]{17}$", var.global_network_id))
    error_message = "resource_aws_networkmanager_transit_gateway_connect_peer_association, global_network_id must be a valid global network ID in the format 'global-network-' followed by 17 alphanumeric characters."
  }
}

variable "transit_gateway_connect_peer_arn" {
  description = "ARN of the Connect peer."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:transit-gateway-connect-peer/tgw-connect-peer-[0-9a-f]{8,17}$", var.transit_gateway_connect_peer_arn))
    error_message = "resource_aws_networkmanager_transit_gateway_connect_peer_association, transit_gateway_connect_peer_arn must be a valid transit gateway connect peer ARN."
  }
}

variable "link_id" {
  description = "ID of the link."
  type        = string
  default     = null

  validation {
    condition     = var.link_id == null || can(regex("^link-[0-9a-f]{17}$", var.link_id))
    error_message = "resource_aws_networkmanager_transit_gateway_connect_peer_association, link_id must be null or a valid link ID in the format 'link-' followed by 17 alphanumeric characters."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_networkmanager_transit_gateway_connect_peer_association, timeouts.create must be a valid timeout duration (e.g., '10m', '1h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_networkmanager_transit_gateway_connect_peer_association, timeouts.delete must be a valid timeout duration (e.g., '10m', '1h')."
  }
}