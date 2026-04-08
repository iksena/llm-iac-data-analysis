variable "autoscaling_group_name" {
  description = "The name of the Auto Scaling group"
  type        = string

  validation {
    condition     = length(var.autoscaling_group_name) > 0
    error_message = "resource_aws_autoscaling_schedule, autoscaling_group_name must not be empty."
  }
}

variable "scheduled_action_name" {
  description = "The name of this scaling action"
  type        = string

  validation {
    condition     = length(var.scheduled_action_name) > 0
    error_message = "resource_aws_autoscaling_schedule, scheduled_action_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "desired_capacity" {
  description = "The initial capacity of the Auto Scaling group after the scheduled action runs and the capacity it attempts to maintain. Set to -1 if you don't want to change the desired capacity at the scheduled time"
  type        = number
  default     = 0

  validation {
    condition     = var.desired_capacity >= -1
    error_message = "resource_aws_autoscaling_schedule, desired_capacity must be greater than or equal to -1."
  }
}

variable "end_time" {
  description = "The date and time for the recurring schedule to end, in UTC with the format YYYY-MM-DDThh:mm:ssZ"
  type        = string
  default     = null

  validation {
    condition     = var.end_time == null || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.end_time))
    error_message = "resource_aws_autoscaling_schedule, end_time must be in the format YYYY-MM-DDThh:mm:ssZ (e.g., 2021-06-01T00:00:00Z)."
  }
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling group. Set to -1 if you don't want to change the maximum size at the scheduled time"
  type        = number
  default     = 0

  validation {
    condition     = var.max_size >= -1
    error_message = "resource_aws_autoscaling_schedule, max_size must be greater than or equal to -1."
  }
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling group. Set to -1 if you don't want to change the minimum size at the scheduled time"
  type        = number
  default     = 0

  validation {
    condition     = var.min_size >= -1
    error_message = "resource_aws_autoscaling_schedule, min_size must be greater than or equal to -1."
  }
}

variable "recurrence" {
  description = "The recurring schedule for this action specified using the Unix cron syntax format"
  type        = string
  default     = null
}

variable "start_time" {
  description = "The date and time for the recurring schedule to start, in UTC with the format YYYY-MM-DDThh:mm:ssZ"
  type        = string
  default     = null

  validation {
    condition     = var.start_time == null || can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.start_time))
    error_message = "resource_aws_autoscaling_schedule, start_time must be in the format YYYY-MM-DDThh:mm:ssZ (e.g., 2021-06-01T00:00:00Z)."
  }
}

variable "time_zone" {
  description = "Specifies the time zone for a cron expression. Valid values are the canonical names of the IANA time zones"
  type        = string
  default     = null
}