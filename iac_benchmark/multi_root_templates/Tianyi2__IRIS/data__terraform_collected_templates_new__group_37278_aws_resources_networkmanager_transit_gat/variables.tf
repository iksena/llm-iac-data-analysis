variable "core_network_id" {
  description = "ID of a core network"
  type        = string

  validation {
    condition     = can(regex("^core-network-[0-9a-f]{17}$", var.core_network_id))
    error_message = "resource_aws_networkmanager_transit_gateway_peering, core_network_id must be a valid core network ID format (core-network-xxxxxxxxxxxxxxxxx)."
  }
}

variable "transit_gateway_arn" {
  description = "ARN of the transit gateway for the peering request"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:transit-gateway/tgw-[0-9a-f]{17}$", var.transit_gateway_arn))
    error_message = "resource_aws_networkmanager_transit_gateway_peering, transit_gateway_arn must be a valid transit gateway ARN."
  }
}

variable "tags" {
  description = "Key-value tags for the peering"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_networkmanager_transit_gateway_peering, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_networkmanager_transit_gateway_peering, tags values must be between 0 and 256 characters."
  }
}

variable "timeouts" {
  description = "Timeouts configuration for the resource"
  type = object({
    create = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = {
    create = "20m"
    delete = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_networkmanager_transit_gateway_peering, timeouts.create must be a valid duration (e.g., 20m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_networkmanager_transit_gateway_peering, timeouts.delete must be a valid duration (e.g., 20m, 1h)."
  }
}