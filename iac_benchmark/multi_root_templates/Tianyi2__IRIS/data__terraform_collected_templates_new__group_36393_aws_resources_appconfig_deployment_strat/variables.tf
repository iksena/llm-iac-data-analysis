variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "deployment_duration_in_minutes" {
  description = "Total amount of time for a deployment to last."
  type        = number

  validation {
    condition     = var.deployment_duration_in_minutes >= 0 && var.deployment_duration_in_minutes <= 1440
    error_message = "resource_aws_appconfig_deployment_strategy, deployment_duration_in_minutes must be between 0 and 1440."
  }
}

variable "growth_factor" {
  description = "Percentage of targets to receive a deployed configuration during each interval."
  type        = number

  validation {
    condition     = var.growth_factor >= 1.0 && var.growth_factor <= 100.0
    error_message = "resource_aws_appconfig_deployment_strategy, growth_factor must be between 1.0 and 100.0."
  }
}

variable "name" {
  description = "Name for the deployment strategy. Must be between 1 and 64 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_appconfig_deployment_strategy, name must be between 1 and 64 characters in length."
  }
}

variable "replicate_to" {
  description = "Where to save the deployment strategy."
  type        = string

  validation {
    condition     = contains(["NONE", "SSM_DOCUMENT"], var.replicate_to)
    error_message = "resource_aws_appconfig_deployment_strategy, replicate_to must be one of: NONE, SSM_DOCUMENT."
  }
}

variable "description" {
  description = "Description of the deployment strategy. Can be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_appconfig_deployment_strategy, description must be at most 1024 characters."
  }
}

variable "final_bake_time_in_minutes" {
  description = "Amount of time AWS AppConfig monitors for alarms before considering the deployment to be complete and no longer eligible for automatic roll back."
  type        = number
  default     = null

  validation {
    condition     = var.final_bake_time_in_minutes == null || (var.final_bake_time_in_minutes >= 0 && var.final_bake_time_in_minutes <= 1440)
    error_message = "resource_aws_appconfig_deployment_strategy, final_bake_time_in_minutes must be between 0 and 1440."
  }
}

variable "growth_type" {
  description = "Algorithm used to define how percentage grows over time."
  type        = string
  default     = "LINEAR"

  validation {
    condition     = contains(["LINEAR", "EXPONENTIAL"], var.growth_type)
    error_message = "resource_aws_appconfig_deployment_strategy, growth_type must be one of: LINEAR, EXPONENTIAL."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}