variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "window_id" {
  description = "The Id of the maintenance window to register the target with."
  type        = string

  validation {
    condition     = var.window_id != null && var.window_id != ""
    error_message = "resource_aws_ssm_maintenance_window_target, window_id is required and cannot be empty."
  }
}

variable "name" {
  description = "The name of the maintenance window target."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the maintenance window target."
  type        = string
  default     = null
}

variable "resource_type" {
  description = "The type of target being registered with the Maintenance Window. Possible values are INSTANCE and RESOURCE_GROUP."
  type        = string

  validation {
    condition     = var.resource_type != null && var.resource_type != ""
    error_message = "resource_aws_ssm_maintenance_window_target, resource_type is required and cannot be empty."
  }

  validation {
    condition     = contains(["INSTANCE", "RESOURCE_GROUP"], var.resource_type)
    error_message = "resource_aws_ssm_maintenance_window_target, resource_type must be either 'INSTANCE' or 'RESOURCE_GROUP'."
  }
}

variable "targets" {
  description = "The targets to register with the maintenance window. In other words, the instances to run commands on when the maintenance window runs."
  type = list(object({
    key    = string
    values = list(string)
  }))

  validation {
    condition     = length(var.targets) > 0
    error_message = "resource_aws_ssm_maintenance_window_target, targets is required and must contain at least one target."
  }

  validation {
    condition = alltrue([
      for target in var.targets : target.key != null && target.key != ""
    ])
    error_message = "resource_aws_ssm_maintenance_window_target, targets each target must have a non-empty key."
  }

  validation {
    condition = alltrue([
      for target in var.targets : length(target.values) > 0
    ])
    error_message = "resource_aws_ssm_maintenance_window_target, targets each target must have at least one value."
  }
}

variable "owner_information" {
  description = "User-provided value that will be included in any CloudWatch events raised while running tasks for these targets in this Maintenance Window."
  type        = string
  default     = null
}