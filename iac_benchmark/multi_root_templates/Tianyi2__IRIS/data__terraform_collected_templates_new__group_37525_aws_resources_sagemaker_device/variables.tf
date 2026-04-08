variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "device_fleet_name" {
  description = "The name of the Device Fleet."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-_]+$", var.device_fleet_name))
    error_message = "resource_aws_sagemaker_device, device_fleet_name must contain only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.device_fleet_name) > 0
    error_message = "resource_aws_sagemaker_device, device_fleet_name cannot be empty."
  }
}

variable "device_description" {
  description = "A description for the device."
  type        = string

  validation {
    condition     = length(var.device_description) > 0
    error_message = "resource_aws_sagemaker_device, device_description cannot be empty."
  }
}

variable "device_name" {
  description = "The name of the device."
  type        = string
  default     = null

  validation {
    condition     = var.device_name == null || can(regex("^[a-zA-Z0-9\\-_]+$", var.device_name))
    error_message = "resource_aws_sagemaker_device, device_name must contain only alphanumeric characters, hyphens, and underscores when specified."
  }
}

variable "iot_thing_name" {
  description = "Amazon Web Services Internet of Things (IoT) object name."
  type        = string
  default     = null

  validation {
    condition     = var.iot_thing_name == null || can(regex("^[a-zA-Z0-9\\-_:]+$", var.iot_thing_name))
    error_message = "resource_aws_sagemaker_device, iot_thing_name must contain only alphanumeric characters, hyphens, underscores, and colons when specified."
  }
}