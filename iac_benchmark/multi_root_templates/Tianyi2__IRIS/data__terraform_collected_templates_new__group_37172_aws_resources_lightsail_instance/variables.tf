variable "availability_zone" {
  description = "Availability Zone in which to create your instance"
  type        = string

  validation {
    condition     = length(var.availability_zone) > 0
    error_message = "resource_aws_lightsail_instance, availability_zone must be a non-empty string."
  }
}

variable "blueprint_id" {
  description = "ID for a virtual private server image"
  type        = string

  validation {
    condition     = length(var.blueprint_id) > 0
    error_message = "resource_aws_lightsail_instance, blueprint_id must be a non-empty string."
  }
}

variable "bundle_id" {
  description = "Bundle of specification information"
  type        = string

  validation {
    condition     = length(var.bundle_id) > 0
    error_message = "resource_aws_lightsail_instance, bundle_id must be a non-empty string."
  }
}

variable "name" {
  description = "Name of the Lightsail Instance"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_lightsail_instance, name must be a non-empty string."
  }
}

variable "add_on" {
  description = "Add-on configuration for the instance"
  type = object({
    snapshot_time = string
    status        = string
    type          = string
  })
  default = null

  validation {
    condition = var.add_on == null || (
      var.add_on.type == "AutoSnapshot" &&
      contains(["Enabled", "Disabled"], var.add_on.status) &&
      can(regex("^[0-2][0-9]:00$", var.add_on.snapshot_time))
    )
    error_message = "resource_aws_lightsail_instance, add_on must have type 'AutoSnapshot', status 'Enabled' or 'Disabled', and snapshot_time in HH:00 format."
  }
}

variable "ip_address_type" {
  description = "IP address type of the Lightsail Instance"
  type        = string
  default     = "dualstack"

  validation {
    condition     = contains(["dualstack", "ipv4", "ipv6"], var.ip_address_type)
    error_message = "resource_aws_lightsail_instance, ip_address_type must be one of: dualstack, ipv4, ipv6."
  }
}

variable "key_pair_name" {
  description = "Name of your key pair"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "Single lined launch script as a string to configure server with additional user data"
  type        = string
  default     = null
}