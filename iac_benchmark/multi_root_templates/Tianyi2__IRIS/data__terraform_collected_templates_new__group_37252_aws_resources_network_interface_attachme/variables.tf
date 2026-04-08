variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Instance ID to attach."
  type        = string

  validation {
    condition     = can(regex("^i-[0-9a-f]{8}([0-9a-f]{9})?$", var.instance_id))
    error_message = "resource_aws_network_interface_attachment, instance_id must be a valid EC2 instance ID (e.g., i-1234567890abcdef0)."
  }
}

variable "network_interface_id" {
  description = "ENI ID to attach."
  type        = string

  validation {
    condition     = can(regex("^eni-[0-9a-f]{8}([0-9a-f]{9})?$", var.network_interface_id))
    error_message = "resource_aws_network_interface_attachment, network_interface_id must be a valid ENI ID (e.g., eni-1234567890abcdef0)."
  }
}

variable "device_index" {
  description = "Network interface index (int)."
  type        = number

  validation {
    condition     = var.device_index >= 0
    error_message = "resource_aws_network_interface_attachment, device_index must be a non-negative integer."
  }
}

variable "network_card_index" {
  description = "Index of the network card. Specify a value greater than 0 when using multiple network cards, which are supported by some instance types. The default is 0."
  type        = number
  default     = 0

  validation {
    condition     = var.network_card_index >= 0
    error_message = "resource_aws_network_interface_attachment, network_card_index must be a non-negative integer."
  }
}