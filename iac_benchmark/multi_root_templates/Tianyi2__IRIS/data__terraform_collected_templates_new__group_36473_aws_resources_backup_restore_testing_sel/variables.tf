variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the backup restore testing selection."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_backup_restore_testing_selection, name must be a non-empty string."
  }
}

variable "restore_testing_plan_name" {
  description = "The name of the restore testing plan."
  type        = string

  validation {
    condition     = length(var.restore_testing_plan_name) > 0
    error_message = "resource_aws_backup_restore_testing_selection, restore_testing_plan_name must be a non-empty string."
  }
}

variable "protected_resource_type" {
  description = "The type of the protected resource."
  type        = string

  validation {
    condition     = length(var.protected_resource_type) > 0
    error_message = "resource_aws_backup_restore_testing_selection, protected_resource_type must be a non-empty string."
  }
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.iam_role_arn))
    error_message = "resource_aws_backup_restore_testing_selection, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "protected_resource_arns" {
  description = "The ARNs for the protected resources."
  type        = list(string)
  default     = null
}

variable "protected_resource_conditions" {
  description = "The conditions for the protected resource."
  type = object({
    string_equals = optional(list(object({
      key   = string
      value = string
    })))
    string_not_equals = optional(list(object({
      key   = string
      value = string
    })))
  })
  default = null

  validation {
    condition = var.protected_resource_conditions == null || (
      var.protected_resource_conditions.string_equals == null ||
      alltrue([
        for se in var.protected_resource_conditions.string_equals :
        can(regex("^aws:ResourceTag/", se.key)) &&
        length(se.key) >= 1 && length(se.key) <= 128 &&
        length(se.value) <= 256
      ])
    )
    error_message = "resource_aws_backup_restore_testing_selection, protected_resource_conditions string_equals key must start with 'aws:ResourceTag/', be 1-128 characters, and value must be <= 256 characters."
  }

  validation {
    condition = var.protected_resource_conditions == null || (
      var.protected_resource_conditions.string_not_equals == null ||
      alltrue([
        for sne in var.protected_resource_conditions.string_not_equals :
        can(regex("^aws:ResourceTag/", sne.key)) &&
        length(sne.key) >= 1 && length(sne.key) <= 128 &&
        length(sne.value) <= 256
      ])
    )
    error_message = "resource_aws_backup_restore_testing_selection, protected_resource_conditions string_not_equals key must start with 'aws:ResourceTag/', be 1-128 characters, and value must be <= 256 characters."
  }
}

variable "restore_metadata_overrides" {
  description = "Override certain restore metadata keys."
  type        = map(string)
  default     = null
}

variable "validation_window_hours" {
  description = "The amount of hours available to run a validation script on the data. Valid range is 1 to 168."
  type        = number
  default     = null

  validation {
    condition     = var.validation_window_hours == null || (var.validation_window_hours >= 1 && var.validation_window_hours <= 168)
    error_message = "resource_aws_backup_restore_testing_selection, validation_window_hours must be between 1 and 168."
  }
}