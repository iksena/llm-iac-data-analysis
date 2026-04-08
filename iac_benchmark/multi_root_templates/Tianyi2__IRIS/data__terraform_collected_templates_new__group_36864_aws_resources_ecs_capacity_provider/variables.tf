variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the capacity provider"
  type        = string
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "auto_scaling_group_provider" {
  description = "Configuration block for the provider for the ECS auto scaling group"
  type = object({
    auto_scaling_group_arn         = string
    managed_draining               = optional(string)
    managed_termination_protection = optional(string)
    managed_scaling = optional(object({
      instance_warmup_period    = optional(number)
      maximum_scaling_step_size = optional(number)
      minimum_scaling_step_size = optional(number)
      status                    = optional(string)
      target_capacity           = optional(number)
    }))
  })

  validation {
    condition     = var.auto_scaling_group_provider.managed_draining == null || contains(["ENABLED", "DISABLED"], var.auto_scaling_group_provider.managed_draining)
    error_message = "resource_aws_ecs_capacity_provider, managed_draining must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.auto_scaling_group_provider.managed_termination_protection == null || contains(["ENABLED", "DISABLED"], var.auto_scaling_group_provider.managed_termination_protection)
    error_message = "resource_aws_ecs_capacity_provider, managed_termination_protection must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.auto_scaling_group_provider.managed_scaling == null || var.auto_scaling_group_provider.managed_scaling.maximum_scaling_step_size == null || (var.auto_scaling_group_provider.managed_scaling.maximum_scaling_step_size >= 1 && var.auto_scaling_group_provider.managed_scaling.maximum_scaling_step_size <= 10000)
    error_message = "resource_aws_ecs_capacity_provider, maximum_scaling_step_size must be a number between 1 and 10,000."
  }

  validation {
    condition     = var.auto_scaling_group_provider.managed_scaling == null || var.auto_scaling_group_provider.managed_scaling.minimum_scaling_step_size == null || (var.auto_scaling_group_provider.managed_scaling.minimum_scaling_step_size >= 1 && var.auto_scaling_group_provider.managed_scaling.minimum_scaling_step_size <= 10000)
    error_message = "resource_aws_ecs_capacity_provider, minimum_scaling_step_size must be a number between 1 and 10,000."
  }

  validation {
    condition     = var.auto_scaling_group_provider.managed_scaling == null || var.auto_scaling_group_provider.managed_scaling.status == null || contains(["ENABLED", "DISABLED"], var.auto_scaling_group_provider.managed_scaling.status)
    error_message = "resource_aws_ecs_capacity_provider, status must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.auto_scaling_group_provider.managed_scaling == null || var.auto_scaling_group_provider.managed_scaling.target_capacity == null || (var.auto_scaling_group_provider.managed_scaling.target_capacity >= 1 && var.auto_scaling_group_provider.managed_scaling.target_capacity <= 100)
    error_message = "resource_aws_ecs_capacity_provider, target_capacity must be a number between 1 and 100."
  }
}