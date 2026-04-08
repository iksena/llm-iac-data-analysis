variable "name" {
  type        = string
  description = "The name of the maintenance window."
}

variable "schedule" {
  type        = string
  description = "The schedule of the Maintenance Window in the form of a cron or rate expression."
}

variable "cutoff" {
  type        = number
  description = "The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution."
}

variable "duration" {
  type        = number
  description = "The duration of the Maintenance Window in hours."
}

variable "description" {
  type        = string
  default     = null
  description = "A description for the maintenance window."
}

variable "allow_unassociated_targets" {
  type        = bool
  default     = null
  description = "Whether targets must be registered with the Maintenance Window before tasks can be defined for those targets."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the maintenance window is enabled."
}

variable "end_date" {
  type        = string
  default     = null
  description = "Timestamp in ISO-8601 extended format when to no longer run the maintenance window."

  validation {
    condition     = var.end_date == null || can(formatdate("2006-01-02T15:04:05Z", var.end_date))
    error_message = "resource_aws_ssm_maintenance_window, end_date must be a valid ISO-8601 timestamp."
  }
}

variable "schedule_timezone" {
  type        = string
  default     = null
  description = "Timezone for schedule in Internet Assigned Numbers Authority (IANA) Time Zone Database format."
}

variable "schedule_offset" {
  type        = number
  default     = null
  description = "The number of days to wait after the date and time specified by a CRON expression before running the maintenance window."

  validation {
    condition     = var.schedule_offset == null || (var.schedule_offset >= 1 && var.schedule_offset <= 6)
    error_message = "resource_aws_ssm_maintenance_window, schedule_offset must be between 1 and 6."
  }
}

variable "start_date" {
  type        = string
  default     = null
  description = "Timestamp in ISO-8601 extended format when to begin the maintenance window."

  validation {
    condition     = var.start_date == null || can(formatdate("2006-01-02T15:04:05Z", var.start_date))
    error_message = "resource_aws_ssm_maintenance_window, start_date must be a valid ISO-8601 timestamp."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the resource."
}