variable "contact_ids" {
  description = "Amazon Resource Names (ARNs) of the contacts to add to the rotation. The order in which you list the contacts is their shift order in the rotation schedule."
  type        = list(string)

  validation {
    condition     = length(var.contact_ids) > 0
    error_message = "resource_aws_ssmcontacts_rotation, contact_ids must contain at least one contact ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.contact_ids : can(regex("^arn:aws:ssm-contacts:", arn))
    ])
    error_message = "resource_aws_ssmcontacts_rotation, contact_ids must be valid SSM Contacts ARNs."
  }
}

variable "name" {
  description = "The name for the rotation."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "resource_aws_ssmcontacts_rotation, name must be between 1 and 255 characters."
  }
}

variable "time_zone_id" {
  description = "The time zone to base the rotation's activity on in Internet Assigned Numbers Authority (IANA) format."
  type        = string

  validation {
    condition     = length(var.time_zone_id) > 0
    error_message = "resource_aws_ssmcontacts_rotation, time_zone_id must be a valid IANA time zone identifier."
  }
}

variable "recurrence" {
  description = "Information about when an on-call rotation is in effect and how long the rotation period lasts. Exactly one of either daily_settings, monthly_settings, or weekly_settings must be populated."
  type = object({
    number_of_on_calls    = number
    recurrence_multiplier = number
    daily_settings = optional(object({
      hour_of_day    = number
      minute_of_hour = number
    }))
    monthly_settings = optional(list(object({
      day_of_month = number
      hand_off_time = object({
        hour_of_day    = number
        minute_of_hour = number
      })
    })))
    weekly_settings = optional(list(object({
      day_of_week = string
      hand_off_time = object({
        hour_of_day    = number
        minute_of_hour = number
      })
    })))
    shift_coverages = optional(list(object({
      map_block_key = string
      coverage_times = list(object({
        start = object({
          hour_of_day    = number
          minute_of_hour = number
        })
        end = object({
          hour_of_day    = number
          minute_of_hour = number
        })
      }))
    })))
  })

  validation {
    condition     = var.recurrence.number_of_on_calls > 0
    error_message = "resource_aws_ssmcontacts_rotation, recurrence number_of_on_calls must be greater than 0."
  }

  validation {
    condition     = var.recurrence.recurrence_multiplier > 0
    error_message = "resource_aws_ssmcontacts_rotation, recurrence recurrence_multiplier must be greater than 0."
  }

  validation {
    condition = (
      (var.recurrence.daily_settings != null ? 1 : 0) +
      (var.recurrence.monthly_settings != null ? 1 : 0) +
      (var.recurrence.weekly_settings != null ? 1 : 0)
    ) == 1
    error_message = "resource_aws_ssmcontacts_rotation, recurrence must have exactly one of daily_settings, monthly_settings, or weekly_settings specified."
  }

  validation {
    condition = var.recurrence.daily_settings == null || (
      var.recurrence.daily_settings.hour_of_day >= 0 &&
      var.recurrence.daily_settings.hour_of_day <= 23
    )
    error_message = "resource_aws_ssmcontacts_rotation, recurrence daily_settings hour_of_day must be between 0 and 23."
  }

  validation {
    condition = var.recurrence.daily_settings == null || (
      var.recurrence.daily_settings.minute_of_hour >= 0 &&
      var.recurrence.daily_settings.minute_of_hour <= 59
    )
    error_message = "resource_aws_ssmcontacts_rotation, recurrence daily_settings minute_of_hour must be between 0 and 59."
  }

  validation {
    condition = var.recurrence.monthly_settings == null || alltrue([
      for ms in var.recurrence.monthly_settings : (
        ms.day_of_month >= 1 && ms.day_of_month <= 31
      )
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence monthly_settings day_of_month must be between 1 and 31."
  }

  validation {
    condition = var.recurrence.monthly_settings == null || alltrue([
      for ms in var.recurrence.monthly_settings : (
        ms.hand_off_time.hour_of_day >= 0 && ms.hand_off_time.hour_of_day <= 23
      )
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence monthly_settings hand_off_time hour_of_day must be between 0 and 23."
  }

  validation {
    condition = var.recurrence.monthly_settings == null || alltrue([
      for ms in var.recurrence.monthly_settings : (
        ms.hand_off_time.minute_of_hour >= 0 && ms.hand_off_time.minute_of_hour <= 59
      )
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence monthly_settings hand_off_time minute_of_hour must be between 0 and 59."
  }

  validation {
    condition = var.recurrence.weekly_settings == null || alltrue([
      for ws in var.recurrence.weekly_settings : contains([
        "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"
      ], ws.day_of_week)
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence weekly_settings day_of_week must be one of: SUN, MON, TUE, WED, THU, FRI, SAT."
  }

  validation {
    condition = var.recurrence.weekly_settings == null || alltrue([
      for ws in var.recurrence.weekly_settings : (
        ws.hand_off_time.hour_of_day >= 0 && ws.hand_off_time.hour_of_day <= 23
      )
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence weekly_settings hand_off_time hour_of_day must be between 0 and 23."
  }

  validation {
    condition = var.recurrence.weekly_settings == null || alltrue([
      for ws in var.recurrence.weekly_settings : (
        ws.hand_off_time.minute_of_hour >= 0 && ws.hand_off_time.minute_of_hour <= 59
      )
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence weekly_settings hand_off_time minute_of_hour must be between 0 and 59."
  }

  validation {
    condition = var.recurrence.shift_coverages == null || alltrue([
      for sc in var.recurrence.shift_coverages : contains([
        "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"
      ], sc.map_block_key)
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence shift_coverages map_block_key must be one of: SUN, MON, TUE, WED, THU, FRI, SAT."
  }

  validation {
    condition = var.recurrence.shift_coverages == null || alltrue([
      for sc in var.recurrence.shift_coverages : alltrue([
        for ct in sc.coverage_times : (
          ct.start.hour_of_day >= 0 && ct.start.hour_of_day <= 23 &&
          ct.start.minute_of_hour >= 0 && ct.start.minute_of_hour <= 59 &&
          ct.end.hour_of_day >= 0 && ct.end.hour_of_day <= 23 &&
          ct.end.minute_of_hour >= 0 && ct.end.minute_of_hour <= 59
        )
      ])
    ])
    error_message = "resource_aws_ssmcontacts_rotation, recurrence shift_coverages coverage_times start and end hour_of_day must be between 0 and 23, minute_of_hour must be between 0 and 59."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "start_time" {
  description = "The date and time, in RFC 3339 format, that the rotation goes into effect."
  type        = string
  default     = null

  validation {
    condition = var.start_time == null || can(
      formatdate("2006-01-02T15:04:05Z07:00", var.start_time)
    )
    error_message = "resource_aws_ssmcontacts_rotation, start_time must be in RFC 3339 format (YYYY-MM-DDTHH:MM:SS±HH:MM)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 128 && length(v) <= 256
    ])
    error_message = "resource_aws_ssmcontacts_rotation, tags keys must be <= 128 characters and values must be <= 256 characters."
  }
}