variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the scheduled action."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appautoscaling_scheduled_action, name must not be empty."
  }
}

variable "service_namespace" {
  description = "Namespace of the AWS service. Example: ecs"
  type        = string

  validation {
    condition     = length(var.service_namespace) > 0
    error_message = "resource_aws_appautoscaling_scheduled_action, service_namespace must not be empty."
  }
}

variable "resource_id" {
  description = "Identifier of the resource associated with the scheduled action."
  type        = string

  validation {
    condition     = length(var.resource_id) > 0
    error_message = "resource_aws_appautoscaling_scheduled_action, resource_id must not be empty."
  }
}

variable "scalable_dimension" {
  description = "Scalable dimension. Example: ecs:service:DesiredCount"
  type        = string

  validation {
    condition     = length(var.scalable_dimension) > 0
    error_message = "resource_aws_appautoscaling_scheduled_action, scalable_dimension must not be empty."
  }
}

variable "scalable_target_action" {
  description = "New minimum and maximum capacity. You can set both values or just one."
  type = object({
    max_capacity = optional(number)
    min_capacity = optional(number)
  })

  validation {
    condition = (
      var.scalable_target_action.max_capacity != null ||
      var.scalable_target_action.min_capacity != null
    )
    error_message = "resource_aws_appautoscaling_scheduled_action, scalable_target_action must have at least one of max_capacity or min_capacity set."
  }
}

variable "schedule" {
  description = "Schedule for this action. Supported formats: At expressions - at(yyyy-mm-ddThh:mm:ss), Rate expressions - rate(valueunit), Cron expressions - cron(fields)."
  type        = string

  validation {
    condition     = length(var.schedule) > 0
    error_message = "resource_aws_appautoscaling_scheduled_action, schedule must not be empty."
  }
}

variable "start_time" {
  description = "Date and time for the scheduled action to start in RFC 3339 format."
  type        = string
  default     = null

  validation {
    condition     = var.start_time == null || can(formatdate("RFC3339", var.start_time))
    error_message = "resource_aws_appautoscaling_scheduled_action, start_time must be in RFC 3339 format."
  }
}

variable "end_time" {
  description = "Date and time for the scheduled action to end in RFC 3339 format."
  type        = string
  default     = null

  validation {
    condition     = var.end_time == null || can(formatdate("RFC3339", var.end_time))
    error_message = "resource_aws_appautoscaling_scheduled_action, end_time must be in RFC 3339 format."
  }
}

variable "timezone" {
  description = "Time zone used when setting a scheduled action by using an at or cron expression. Valid values are the canonical names of the IANA time zones."
  type        = string
  default     = "UTC"

  validation {
    condition     = length(var.timezone) > 0
    error_message = "resource_aws_appautoscaling_scheduled_action, timezone must not be empty."
  }
}