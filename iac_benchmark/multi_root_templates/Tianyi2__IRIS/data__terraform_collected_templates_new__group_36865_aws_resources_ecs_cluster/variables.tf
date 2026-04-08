variable "name" {
  description = "Name of the cluster (up to 255 letters, numbers, hyphens, and underscores)"
  type        = string

  validation {
    condition     = length(var.name) <= 255
    error_message = "resource_aws_ecs_cluster, name must be up to 255 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_ecs_cluster, name can only contain letters, numbers, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "configuration" {
  description = "Execute command configuration for the cluster"
  type = object({
    execute_command_configuration = optional(object({
      kms_key_id = optional(string)
      logging    = optional(string)
      log_configuration = optional(object({
        cloud_watch_encryption_enabled = optional(bool)
        cloud_watch_log_group_name     = optional(string)
        s3_bucket_name                 = optional(string)
        s3_bucket_encryption_enabled   = optional(bool)
        s3_key_prefix                  = optional(string)
      }))
    }))
    managed_storage_configuration = optional(object({
      fargate_ephemeral_storage_kms_key_id = optional(string)
      kms_key_id                           = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.configuration == null || var.configuration.execute_command_configuration == null || var.configuration.execute_command_configuration.logging == null || contains(["NONE", "DEFAULT", "OVERRIDE"], var.configuration.execute_command_configuration.logging)
    error_message = "resource_aws_ecs_cluster, configuration.execute_command_configuration.logging must be one of: NONE, DEFAULT, OVERRIDE."
  }

  validation {
    condition     = var.configuration == null || var.configuration.execute_command_configuration == null || var.configuration.execute_command_configuration.logging != "OVERRIDE" || var.configuration.execute_command_configuration.log_configuration != null
    error_message = "resource_aws_ecs_cluster, configuration.execute_command_configuration.log_configuration is required when logging is OVERRIDE."
  }
}

variable "service_connect_defaults" {
  description = "Default Service Connect namespace"
  type = object({
    namespace = string
  })
  default = null
}

variable "setting" {
  description = "Configuration blocks with cluster settings"
  type = list(object({
    name  = string
    value = string
  }))
  default = null

  validation {
    condition = var.setting == null || alltrue([
      for s in var.setting : contains(["containerInsights"], s.name)
    ])
    error_message = "resource_aws_ecs_cluster, setting.name must be one of: containerInsights."
  }

  validation {
    condition = var.setting == null || alltrue([
      for s in var.setting : contains(["enhanced", "enabled", "disabled"], s.value)
    ])
    error_message = "resource_aws_ecs_cluster, setting.value must be one of: enhanced, enabled, disabled."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}