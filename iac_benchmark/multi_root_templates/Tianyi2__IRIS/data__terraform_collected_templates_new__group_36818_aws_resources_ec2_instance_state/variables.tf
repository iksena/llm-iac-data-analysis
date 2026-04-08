variable "instance_id" {
  description = "ID of the instance"
  type        = string

  validation {
    condition     = can(regex("^i-[0-9a-f]{8,17}$", var.instance_id))
    error_message = "resource_aws_ec2_instance_state, instance_id must be a valid EC2 instance ID (format: i-xxxxxxxxx)."
  }
}

variable "state" {
  description = "State of the instance"
  type        = string

  validation {
    condition     = contains(["stopped", "running"], var.state)
    error_message = "resource_aws_ec2_instance_state, state must be either 'stopped' or 'running'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "force" {
  description = "Whether to request a forced stop when state is stopped. Otherwise (i.e., state is running), ignored. When an instance is forced to stop, it does not flush file system caches or file system metadata, and you must subsequently perform file system check and repair. Not recommended for Windows instances"
  type        = bool
  default     = false
}

variable "create_timeout" {
  description = "Timeout for create operations"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_ec2_instance_state, create_timeout must be a valid duration (e.g., '10m', '1h', '30s')."
  }
}

variable "update_timeout" {
  description = "Timeout for update operations"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_ec2_instance_state, update_timeout must be a valid duration (e.g., '10m', '1h', '30s')."
  }
}

variable "delete_timeout" {
  description = "Timeout for delete operations"
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_ec2_instance_state, delete_timeout must be a valid duration (e.g., '1m', '30s', '2h')."
  }
}