variable "device_id" {
  description = "ID of the device"
  type        = string

  validation {
    condition     = can(regex("^device-[0-9a-f]{17}$", var.device_id))
    error_message = "resource_aws_networkmanager_link_association, device_id must be a valid device ID starting with 'device-' followed by 17 hexadecimal characters."
  }
}

variable "global_network_id" {
  description = "ID of the global network"
  type        = string

  validation {
    condition     = can(regex("^global-network-[0-9a-f]{17}$", var.global_network_id))
    error_message = "resource_aws_networkmanager_link_association, global_network_id must be a valid global network ID starting with 'global-network-' followed by 17 hexadecimal characters."
  }
}

variable "link_id" {
  description = "ID of the link"
  type        = string

  validation {
    condition     = can(regex("^link-[0-9a-f]{17}$", var.link_id))
    error_message = "resource_aws_networkmanager_link_association, link_id must be a valid link ID starting with 'link-' followed by 17 hexadecimal characters."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_networkmanager_link_association, timeouts create and delete must be valid duration strings (e.g., '10m', '1h', '30s')."
  }
}