variable "availability_zone_id" {
  description = "The availability zone identifiers for the requested regions."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.availability_zone_id))
    error_message = "resource_aws_finspace_kx_scaling_group, availability_zone_id must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment_id" {
  description = "A unique identifier for the kdb environment, where you want to create the scaling group."
  type        = string

  validation {
    condition     = length(var.environment_id) > 0
    error_message = "resource_aws_finspace_kx_scaling_group, environment_id cannot be empty."
  }
}

variable "name" {
  description = "Unique name for the scaling group that you want to create."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_finspace_kx_scaling_group, name cannot be empty."
  }
}

variable "host_type" {
  description = "The memory and CPU capabilities of the scaling group host on which FinSpace Managed kdb clusters will be placed."
  type        = string

  validation {
    condition     = length(var.host_type) > 0
    error_message = "resource_aws_finspace_kx_scaling_group, host_type cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags. You can add up to 50 tags to a scaling group."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_finspace_kx_scaling_group, tags cannot exceed 50 key-value pairs."
  }
}

variable "timeout_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "4h"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_create))
    error_message = "resource_aws_finspace_kx_scaling_group, timeout_create must be a valid duration (e.g., 4h, 30m, 120s)."
  }
}

variable "timeout_update" {
  description = "Timeout for update operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_update))
    error_message = "resource_aws_finspace_kx_scaling_group, timeout_update must be a valid duration (e.g., 4h, 30m, 120s)."
  }
}

variable "timeout_delete" {
  description = "Timeout for delete operation."
  type        = string
  default     = "4h"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeout_delete))
    error_message = "resource_aws_finspace_kx_scaling_group, timeout_delete must be a valid duration (e.g., 4h, 30m, 120s)."
  }
}