variable "availability_zone" {
  description = "Availability Zone in which to create the disk"
  type        = string

  validation {
    condition     = length(var.availability_zone) > 0
    error_message = "resource_aws_lightsail_disk, availability_zone must not be empty."
  }
}

variable "name" {
  description = "Name of the disk. Must begin with an alphabetic character and contain only alphanumeric characters, underscores, hyphens, and dots"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_.-]*$", var.name))
    error_message = "resource_aws_lightsail_disk, name must begin with an alphabetic character and contain only alphanumeric characters, underscores, hyphens, and dots."
  }
}

variable "size_in_gb" {
  description = "Size of the disk in GB"
  type        = number

  validation {
    condition     = var.size_in_gb > 0
    error_message = "resource_aws_lightsail_disk, size_in_gb must be greater than 0."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. To create a key-only tag, use an empty string as the value"
  type        = map(string)
  default     = {}
}