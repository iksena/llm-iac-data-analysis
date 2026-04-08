variable "window_id" {
  description = "The Id of the maintenance window to register the task with"
  type        = string

  validation {
    condition     = length(var.window_id) > 0
    error_message = "resource_aws_ssm_maintenance_window_task, window_id must be a non-empty string."
  }
}

variable "task_type" {
  description = "The type of task being registered"
  type        = string

  validation {
    condition     = contains(["AUTOMATION", "LAMBDA", "RUN_COMMAND", "STEP_FUNCTIONS"], var.task_type)
    error_message = "resource_aws_ssm_maintenance_window_task, task_type must be one of: AUTOMATION, LAMBDA, RUN_COMMAND, STEP_FUNCTIONS."
  }
}

variable "task_arn" {
  description = "The ARN of the task to execute"
  type        = string

  validation {
    condition     = length(var.task_arn) > 0
    error_message = "resource_aws_ssm_maintenance_window_task, task_arn must be a non-empty string."
  }
}

variable "max_concurrency" {
  description = "The maximum number of targets this task can be run for in parallel"
  type        = string
  default     = null
}

variable "max_errors" {
  description = "The maximum number of errors allowed before this task stops being scheduled"
  type        = string
  default     = null
}

variable "cutoff_behavior" {
  description = "Indicates whether tasks should continue to run after the cutoff time specified in the maintenance windows is reached"
  type        = string
  default     = null

  validation {
    condition     = var.cutoff_behavior == null || contains(["CONTINUE_TASK", "CANCEL_TASK"], var.cutoff_behavior)
    error_message = "resource_aws_ssm_maintenance_window_task, cutoff_behavior must be one of: CONTINUE_TASK, CANCEL_TASK."
  }
}

variable "service_role_arn" {
  description = "The role that should be assumed when executing the task"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the maintenance window task"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the maintenance window task"
  type        = string
  default     = null
}

variable "priority" {
  description = "The priority of the task in the Maintenance Window"
  type        = number
  default     = null
}

variable "targets" {
  description = "The targets (either instances or window target ids)"
  type = list(object({
    key    = string
    values = list(string)
  }))
  default = []
}

variable "task_invocation_parameters" {
  description = "Configuration block with parameters for task execution"
  type = object({
    automation_parameters = optional(object({
      document_version = optional(string)
      parameter = optional(list(object({
        name   = string
        values = list(string)
      })))
    }))
    lambda_parameters = optional(object({
      client_context = optional(string)
      payload        = optional(string)
      qualifier      = optional(string)
    }))
    run_command_parameters = optional(object({
      comment              = optional(string)
      document_hash        = optional(string)
      document_hash_type   = optional(string)
      output_s3_bucket     = optional(string)
      output_s3_key_prefix = optional(string)
      service_role_arn     = optional(string)
      timeout_seconds      = optional(number)
      notification_config = optional(object({
        notification_arn    = optional(string)
        notification_events = optional(list(string))
        notification_type   = optional(string)
      }))
      cloudwatch_config = optional(object({
        cloudwatch_log_group_name = optional(string)
        cloudwatch_output_enabled = optional(bool)
      }))
      parameter = optional(list(object({
        name   = string
        values = list(string)
      })))
    }))
    step_functions_parameters = optional(object({
      input = optional(string)
      name  = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.task_invocation_parameters == null || (
      var.task_invocation_parameters.run_command_parameters == null ||
      var.task_invocation_parameters.run_command_parameters.document_hash_type == null ||
      contains(["Sha256", "Sha1"], var.task_invocation_parameters.run_command_parameters.document_hash_type)
    )
    error_message = "resource_aws_ssm_maintenance_window_task, document_hash_type must be one of: Sha256, Sha1."
  }

  validation {
    condition = var.task_invocation_parameters == null || (
      var.task_invocation_parameters.run_command_parameters == null ||
      var.task_invocation_parameters.run_command_parameters.notification_config == null ||
      var.task_invocation_parameters.run_command_parameters.notification_config.notification_events == null ||
      length([
        for event in var.task_invocation_parameters.run_command_parameters.notification_config.notification_events :
        event if contains(["All", "InProgress", "Success", "TimedOut", "Cancelled", "Failed"], event)
      ]) == length(var.task_invocation_parameters.run_command_parameters.notification_config.notification_events)
    )
    error_message = "resource_aws_ssm_maintenance_window_task, notification_events must contain only valid values: All, InProgress, Success, TimedOut, Cancelled, Failed."
  }

  validation {
    condition = var.task_invocation_parameters == null || (
      var.task_invocation_parameters.run_command_parameters == null ||
      var.task_invocation_parameters.run_command_parameters.notification_config == null ||
      var.task_invocation_parameters.run_command_parameters.notification_config.notification_type == null ||
      contains(["Command", "Invocation"], var.task_invocation_parameters.run_command_parameters.notification_config.notification_type)
    )
    error_message = "resource_aws_ssm_maintenance_window_task, notification_type must be one of: Command, Invocation."
  }
}