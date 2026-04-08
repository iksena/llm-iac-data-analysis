variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Region-unique name for the AMI."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ami_from_instance, name must not be empty."
  }
}

variable "source_instance_id" {
  description = "ID of the instance to use as the basis of the AMI."
  type        = string

  validation {
    condition     = can(regex("^i-[0-9a-fA-F]+$", var.source_instance_id))
    error_message = "resource_aws_ami_from_instance, source_instance_id must be a valid EC2 instance ID starting with 'i-'."
  }
}

variable "snapshot_without_reboot" {
  description = "Boolean that overrides the behavior of stopping the instance before snapshotting. This is risky since it may cause a snapshot of an inconsistent filesystem state, but can be used to avoid downtime if the user otherwise guarantees that no filesystem writes will be underway at the time of snapshot."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeout_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "40m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_create))
    error_message = "resource_aws_ami_from_instance, timeout_create must be a valid duration (e.g., '40m', '1h', '30s')."
  }
}

variable "timeout_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "40m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_update))
    error_message = "resource_aws_ami_from_instance, timeout_update must be a valid duration (e.g., '40m', '1h', '30s')."
  }
}

variable "timeout_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "90m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_delete))
    error_message = "resource_aws_ami_from_instance, timeout_delete must be a valid duration (e.g., '90m', '1h', '30s')."
  }
}