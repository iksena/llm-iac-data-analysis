variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "data_set_id" {
  description = "The ID of the dataset."
  type        = string
}

variable "schedule_id" {
  description = "The ID of the refresh schedule."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "schedule" {
  description = "The refresh schedule configuration."
  type = object({
    refresh_type          = string
    start_after_date_time = optional(string)
    schedule_frequency = object({
      interval        = string
      time_of_the_day = string
      timezone        = string
      refresh_on_day = optional(object({
        day_of_month = string
        day_of_week  = string
      }))
    })
  })

  validation {
    condition     = contains(["INCREMENTAL_REFRESH", "FULL_REFRESH"], var.schedule.refresh_type)
    error_message = "resource_aws_quicksight_refresh_schedule, refresh_type must be one of: INCREMENTAL_REFRESH, FULL_REFRESH."
  }

  validation {
    condition     = contains(["MINUTE15", "MINUTE30", "HOURLY", "DAILY", "WEEKLY", "MONTHLY"], var.schedule.schedule_frequency.interval)
    error_message = "resource_aws_quicksight_refresh_schedule, interval must be one of: MINUTE15, MINUTE30, HOURLY, DAILY, WEEKLY, MONTHLY."
  }

  validation {
    condition     = var.schedule.schedule_frequency.refresh_on_day == null || var.schedule.schedule_frequency.refresh_on_day.day_of_week == null || contains(["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"], var.schedule.schedule_frequency.refresh_on_day.day_of_week)
    error_message = "resource_aws_quicksight_refresh_schedule, day_of_week must be one of: SUNDAY, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY."
  }

  validation {
    condition     = var.schedule.start_after_date_time == null || can(formatdate("YYYY-MM-DDTHH:mm:ss", var.schedule.start_after_date_time))
    error_message = "resource_aws_quicksight_refresh_schedule, start_after_date_time must be in YYYY-MM-DDTHH:MM:SS format."
  }

  validation {
    condition     = can(regex("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", var.schedule.schedule_frequency.time_of_the_day))
    error_message = "resource_aws_quicksight_refresh_schedule, time_of_the_day must be in HH:MM format."
  }
}