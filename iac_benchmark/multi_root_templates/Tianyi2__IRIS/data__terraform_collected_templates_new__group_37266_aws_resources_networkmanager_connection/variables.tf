variable "global_network_id" {
  description = "ID of the global network"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-zA-Z-]+$", var.global_network_id))
    error_message = "resource_aws_networkmanager_connection, global_network_id must be a valid global network ID."
  }
}

variable "device_id" {
  description = "ID of the first device in the connection"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-zA-Z-]+$", var.device_id))
    error_message = "resource_aws_networkmanager_connection, device_id must be a valid device ID."
  }
}

variable "connected_device_id" {
  description = "ID of the second device in the connection"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-zA-Z-]+$", var.connected_device_id))
    error_message = "resource_aws_networkmanager_connection, connected_device_id must be a valid device ID."
  }
}

variable "connected_link_id" {
  description = "ID of the link for the second device"
  type        = string
  default     = null

  validation {
    condition     = var.connected_link_id == null || can(regex("^[0-9a-zA-Z-]+$", var.connected_link_id))
    error_message = "resource_aws_networkmanager_connection, connected_link_id must be a valid link ID or null."
  }
}

variable "description" {
  description = "Description of the connection"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 256
    error_message = "resource_aws_networkmanager_connection, description must be 256 characters or less."
  }
}

variable "link_id" {
  description = "ID of the link for the first device"
  type        = string
  default     = null

  validation {
    condition     = var.link_id == null || can(regex("^[0-9a-zA-Z-]+$", var.link_id))
    error_message = "resource_aws_networkmanager_connection, link_id must be a valid link ID or null."
  }
}

variable "tags" {
  description = "Key-value tags for the connection"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k))])
    error_message = "resource_aws_networkmanager_connection, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_networkmanager_connection, tags values must be 256 characters or less."
  }
}

variable "timeouts" {
  description = "Timeouts configuration"
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
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_networkmanager_connection, timeouts.create must be a valid duration (e.g., 10m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_networkmanager_connection, timeouts.delete must be a valid duration (e.g., 10m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.update))
    error_message = "resource_aws_networkmanager_connection, timeouts.update must be a valid duration (e.g., 10m, 1h)."
  }
}