variable "global_network_id" {
  description = "ID of the Global Network to create the site in"
  type        = string

  validation {
    condition     = length(var.global_network_id) > 0
    error_message = "resource_aws_networkmanager_site, global_network_id must not be empty."
  }
}

variable "description" {
  description = "Description of the Site"
  type        = string
  default     = null
}

variable "location" {
  description = "Site location configuration"
  type = object({
    address   = optional(string)
    latitude  = optional(string)
    longitude = optional(string)
  })
  default = null

  validation {
    condition = var.location == null ? true : (
      var.location.latitude == null || can(tonumber(var.location.latitude))
    )
    error_message = "resource_aws_networkmanager_site, location.latitude must be a valid number if provided."
  }

  validation {
    condition = var.location == null ? true : (
      var.location.longitude == null || can(tonumber(var.location.longitude))
    )
    error_message = "resource_aws_networkmanager_site, location.longitude must be a valid number if provided."
  }

  validation {
    condition = var.location == null ? true : (
      var.location.latitude == null ||
      (tonumber(var.location.latitude) >= -90 && tonumber(var.location.latitude) <= 90)
    )
    error_message = "resource_aws_networkmanager_site, location.latitude must be between -90 and 90 degrees."
  }

  validation {
    condition = var.location == null ? true : (
      var.location.longitude == null ||
      (tonumber(var.location.longitude) >= -180 && tonumber(var.location.longitude) <= 180)
    )
    error_message = "resource_aws_networkmanager_site, location.longitude must be between -180 and 180 degrees."
  }
}

variable "tags" {
  description = "Key-value tags for the Site"
  type        = map(string)
  default     = {}
}