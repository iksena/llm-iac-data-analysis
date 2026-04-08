variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The display name of a backup plan."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_backup_plan, name cannot be empty."
  }
}

variable "rule" {
  description = "A rule object that specifies a scheduled task that is used to back up a selection of resources."
  type = list(object({
    rule_name                    = string
    target_vault_name            = string
    schedule                     = optional(string)
    schedule_expression_timezone = optional(string, "Etc/UTC")
    enable_continuous_backup     = optional(bool)
    start_window                 = optional(number)
    completion_window            = optional(number)
    recovery_point_tags          = optional(map(string))
    lifecycle = optional(object({
      cold_storage_after                        = optional(number)
      delete_after                              = optional(number)
      opt_in_to_archive_for_supported_resources = optional(bool)
    }))
    copy_action = optional(list(object({
      destination_vault_arn = string
      lifecycle = optional(object({
        cold_storage_after                        = optional(number)
        delete_after                              = optional(number)
        opt_in_to_archive_for_supported_resources = optional(bool)
      }))
    })))
  }))

  validation {
    condition     = length(var.rule) > 0
    error_message = "resource_aws_backup_plan, rule must contain at least one rule."
  }

  validation {
    condition = alltrue([
      for r in var.rule : length(r.rule_name) > 0
    ])
    error_message = "resource_aws_backup_plan, rule_name cannot be empty for any rule."
  }

  validation {
    condition = alltrue([
      for r in var.rule : length(r.target_vault_name) > 0
    ])
    error_message = "resource_aws_backup_plan, target_vault_name cannot be empty for any rule."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.lifecycle == null ? true : (
        r.lifecycle.delete_after == null || r.lifecycle.cold_storage_after == null ? true :
        r.lifecycle.delete_after >= (r.lifecycle.cold_storage_after + 90)
      )
    ])
    error_message = "resource_aws_backup_plan, delete_after must be 90 days greater than cold_storage_after."
  }

  validation {
    condition = alltrue(flatten([
      for r in var.rule : r.copy_action == null ? [true] : [
        for ca in r.copy_action : ca.lifecycle == null ? true : (
          ca.lifecycle.delete_after == null || ca.lifecycle.cold_storage_after == null ? true :
          ca.lifecycle.delete_after >= (ca.lifecycle.cold_storage_after + 90)
        )
      ]
    ]))
    error_message = "resource_aws_backup_plan, copy_action lifecycle delete_after must be 90 days greater than cold_storage_after."
  }
}

variable "advanced_backup_setting" {
  description = "An object that specifies backup options for each resource type."
  type = list(object({
    backup_options = map(string)
    resource_type  = string
  }))
  default = null

  validation {
    condition = var.advanced_backup_setting == null ? true : alltrue([
      for abs in var.advanced_backup_setting : contains(["EC2"], abs.resource_type)
    ])
    error_message = "resource_aws_backup_plan, resource_type must be 'EC2' for advanced_backup_setting."
  }

  validation {
    condition = var.advanced_backup_setting == null ? true : alltrue([
      for abs in var.advanced_backup_setting : length(abs.backup_options) > 0
    ])
    error_message = "resource_aws_backup_plan, backup_options cannot be empty for advanced_backup_setting."
  }
}

variable "tags" {
  description = "Metadata that you can assign to help organize the plans you create."
  type        = map(string)
  default     = {}
}