variable "global_network_id" {
  description = "ID of the global network"
  type        = string
  validation {
    condition     = can(regex("^gn-[a-f0-9]{17}$", var.global_network_id))
    error_message = "resource_aws_networkmanager_device, global_network_id must be a valid global network ID."
  }
}

variable "site_id" {
  description = "ID of the site"
  type        = string
  default     = null
  validation {
    condition     = var.site_id == null || can(regex("^site-[a-f0-9]{17}$", var.site_id))
    error_message = "resource_aws_networkmanager_device, site_id must be a valid site ID or null."
  }
}

variable "description" {
  description = "Description of the device"
  type        = string
  default     = null
  validation {
    condition     = var.description == null || length(var.description) <= 256
    error_message = "resource_aws_networkmanager_device, description must be 256 characters or less."
  }
}

variable "model" {
  description = "Model of device"
  type        = string
  default     = null
  validation {
    condition     = var.model == null || length(var.model) <= 128
    error_message = "resource_aws_networkmanager_device, model must be 128 characters or less."
  }
}

variable "serial_number" {
  description = "Serial number of the device"
  type        = string
  default     = null
  validation {
    condition     = var.serial_number == null || length(var.serial_number) <= 128
    error_message = "resource_aws_networkmanager_device, serial_number must be 128 characters or less."
  }
}

variable "type" {
  description = "Type of device"
  type        = string
  default     = null
  validation {
    condition     = var.type == null || length(var.type) <= 128
    error_message = "resource_aws_networkmanager_device, type must be 128 characters or less."
  }
}

variable "vendor" {
  description = "Vendor of the device"
  type        = string
  default     = null
  validation {
    condition     = var.vendor == null || length(var.vendor) <= 128
    error_message = "resource_aws_networkmanager_device, vendor must be 128 characters or less."
  }
}

variable "tags" {
  description = "Key-value tags for the device"
  type        = map(string)
  default     = {}
}

variable "aws_location" {
  description = "AWS location of the device"
  type = object({
    subnet_arn = optional(string)
    zone       = optional(string)
  })
  default = null
  validation {
    condition = var.aws_location == null || (
      var.aws_location.subnet_arn == null || can(regex("^arn:aws:ec2:[^:]+:[^:]+:subnet/subnet-[a-f0-9]{8,17}$", var.aws_location.subnet_arn))
    )
    error_message = "resource_aws_networkmanager_device, aws_location.subnet_arn must be a valid subnet ARN or null."
  }
}

variable "location" {
  description = "Location of the device"
  type = object({
    address   = optional(string)
    latitude  = optional(string)
    longitude = optional(string)
  })
  default = null
  validation {
    condition = var.location == null || (
      var.location.latitude == null || can(tonumber(var.location.latitude)) && tonumber(var.location.latitude) >= -90 && tonumber(var.location.latitude) <= 90
    )
    error_message = "resource_aws_networkmanager_device, location.latitude must be a valid latitude between -90 and 90."
  }
  validation {
    condition = var.location == null || (
      var.location.longitude == null || can(tonumber(var.location.longitude)) && tonumber(var.location.longitude) >= -180 && tonumber(var.location.longitude) <= 180
    )
    error_message = "resource_aws_networkmanager_device, location.longitude must be a valid longitude between -180 and 180."
  }
  validation {
    condition     = var.location == null || var.location.address == null || length(var.location.address) <= 256
    error_message = "resource_aws_networkmanager_device, location.address must be 256 characters or less."
  }
}

variable "timeout_create" {
  description = "Timeout for creating the device"
  type        = string
  default     = "10m"
  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeout_create))
    error_message = "resource_aws_networkmanager_device, timeout_create must be a valid timeout duration (e.g., '10m', '1h')."
  }
}

variable "timeout_update" {
  description = "Timeout for updating the device"
  type        = string
  default     = "10m"
  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeout_update))
    error_message = "resource_aws_networkmanager_device, timeout_update must be a valid timeout duration (e.g., '10m', '1h')."
  }
}

variable "timeout_delete" {
  description = "Timeout for deleting the device"
  type        = string
  default     = "10m"
  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeout_delete))
    error_message = "resource_aws_networkmanager_device, timeout_delete must be a valid timeout duration (e.g., '10m', '1h')."
  }
}