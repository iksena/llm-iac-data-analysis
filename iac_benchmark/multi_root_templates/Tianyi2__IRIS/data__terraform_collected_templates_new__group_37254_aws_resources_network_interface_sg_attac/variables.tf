variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]{8,17}$", var.security_group_id))
    error_message = "resource_aws_network_interface_sg_attachment, security_group_id must be a valid security group ID (sg-xxxxxxxx)."
  }
}

variable "network_interface_id" {
  description = "The ID of the network interface to attach to."
  type        = string

  validation {
    condition     = can(regex("^eni-[0-9a-f]{8,17}$", var.network_interface_id))
    error_message = "resource_aws_network_interface_sg_attachment, network_interface_id must be a valid network interface ID (eni-xxxxxxxx)."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "3m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_network_interface_sg_attachment, timeouts_create must be a valid timeout format (e.g., 3m, 30s, 1h)."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operation."
  type        = string
  default     = "3m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "resource_aws_network_interface_sg_attachment, timeouts_read must be a valid timeout format (e.g., 3m, 30s, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "3m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_network_interface_sg_attachment, timeouts_delete must be a valid timeout format (e.g., 3m, 30s, 1h)."
  }
}