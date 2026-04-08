variable "global_network_id" {
  description = "ID of the global network"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.global_network_id))
    error_message = "resource_aws_networkmanager_link, global_network_id must be a valid global network ID containing only alphanumeric characters and hyphens."
  }
}

variable "site_id" {
  description = "ID of the site"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.site_id))
    error_message = "resource_aws_networkmanager_link, site_id must be a valid site ID containing only alphanumeric characters and hyphens."
  }
}

variable "bandwidth" {
  description = "Upload speed and download speed in Mbps"
  type = object({
    download_speed = optional(number)
    upload_speed   = optional(number)
  })

  validation {
    condition = var.bandwidth != null ? (
      (var.bandwidth.download_speed == null || (var.bandwidth.download_speed > 0 && var.bandwidth.download_speed <= 100000)) &&
      (var.bandwidth.upload_speed == null || (var.bandwidth.upload_speed > 0 && var.bandwidth.upload_speed <= 100000))
    ) : true
    error_message = "resource_aws_networkmanager_link, bandwidth download_speed and upload_speed must be positive numbers between 1 and 100000 Mbps."
  }
}

variable "description" {
  description = "Description of the link"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) >= 0 && length(var.description) <= 256)
    error_message = "resource_aws_networkmanager_link, description must be between 0 and 256 characters."
  }
}

variable "provider_name" {
  description = "Provider of the link"
  type        = string
  default     = null

  validation {
    condition     = var.provider_name == null || (length(var.provider_name) >= 0 && length(var.provider_name) <= 128)
    error_message = "resource_aws_networkmanager_link, provider_name must be between 0 and 128 characters."
  }
}

variable "tags" {
  description = "Key-value tags for the link"
  type        = map(string)
  default     = {}

  validation {
    condition     = can(keys(var.tags))
    error_message = "resource_aws_networkmanager_link, tags must be a valid map of string key-value pairs."
  }
}

variable "type" {
  description = "Type of the link"
  type        = string
  default     = null

  validation {
    condition     = var.type == null || (length(var.type) >= 0 && length(var.type) <= 128)
    error_message = "resource_aws_networkmanager_link, type must be between 0 and 128 characters."
  }
}

variable "timeouts" {
  description = "Timeouts for the resource operations"
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
    error_message = "resource_aws_networkmanager_link, timeouts must be valid duration strings (e.g., '10m', '1h', '30s')."
  }
}