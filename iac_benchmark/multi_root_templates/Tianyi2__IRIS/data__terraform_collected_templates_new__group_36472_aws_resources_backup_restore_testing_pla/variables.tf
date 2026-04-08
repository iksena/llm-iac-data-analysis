variable "name" {
  description = "The name of the restore testing plan"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{1,50}$", var.name))
    error_message = "resource_aws_backup_restore_testing_plan, name must be between 1 and 50 characters long and contain only alphanumeric characters and underscores."
  }
}

variable "schedule_expression" {
  description = "The schedule expression for the restore testing plan"
  type        = string
}

variable "schedule_expression_timezone" {
  description = "The timezone for the schedule expression"
  type        = string
  default     = null
}

variable "start_window_hours" {
  description = "The number of hours in the start window for the restore testing plan"
  type        = number
  default     = null

  validation {
    condition     = var.start_window_hours == null || (var.start_window_hours >= 1 && var.start_window_hours <= 168)
    error_message = "resource_aws_backup_restore_testing_plan, start_window_hours must be between 1 and 168."
  }
}

variable "recovery_point_selection" {
  description = "Specifies the recovery point selection configuration"
  type = object({
    algorithm             = string
    include_vaults        = list(string)
    recovery_point_types  = list(string)
    exclude_vaults        = optional(list(string))
    selection_window_days = optional(number)
  })

  validation {
    condition     = contains(["RANDOM_WITHIN_WINDOW", "LATEST_WITHIN_WINDOW"], var.recovery_point_selection.algorithm)
    error_message = "resource_aws_backup_restore_testing_plan, recovery_point_selection.algorithm must be either 'RANDOM_WITHIN_WINDOW' or 'LATEST_WITHIN_WINDOW'."
  }

  validation {
    condition     = length(var.recovery_point_selection.include_vaults) > 0
    error_message = "resource_aws_backup_restore_testing_plan, recovery_point_selection.include_vaults must contain at least one vault."
  }

  validation {
    condition     = length(var.recovery_point_selection.recovery_point_types) > 0
    error_message = "resource_aws_backup_restore_testing_plan, recovery_point_selection.recovery_point_types must contain at least one recovery point type."
  }

  validation {
    condition = alltrue([
      for rpt in var.recovery_point_selection.recovery_point_types :
      contains(["CONTINUOUS", "SNAPSHOT"], rpt)
    ])
    error_message = "resource_aws_backup_restore_testing_plan, recovery_point_selection.recovery_point_types must contain only 'CONTINUOUS' or 'SNAPSHOT' values."
  }

  validation {
    condition     = var.recovery_point_selection.selection_window_days == null || (var.recovery_point_selection.selection_window_days >= 1 && var.recovery_point_selection.selection_window_days <= 365)
    error_message = "resource_aws_backup_restore_testing_plan, recovery_point_selection.selection_window_days must be between 1 and 365."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}