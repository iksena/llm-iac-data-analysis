variable "disk_name" {
  description = "Name of the Lightsail disk"
  type        = string

  validation {
    condition     = length(var.disk_name) > 0
    error_message = "resource_aws_lightsail_disk_attachment, disk_name must not be empty."
  }
}

variable "disk_path" {
  description = "Disk path to expose to the instance"
  type        = string

  validation {
    condition     = length(var.disk_path) > 0
    error_message = "resource_aws_lightsail_disk_attachment, disk_path must not be empty."
  }
}

variable "instance_name" {
  description = "Name of the Lightsail instance to attach to"
  type        = string

  validation {
    condition     = length(var.instance_name) > 0
    error_message = "resource_aws_lightsail_disk_attachment, instance_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}