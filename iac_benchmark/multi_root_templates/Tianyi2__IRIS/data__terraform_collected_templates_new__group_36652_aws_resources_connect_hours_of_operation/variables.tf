variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "resource_aws_connect_hours_of_operation, instance_id must not be empty."
  }
}

variable "name" {
  description = "Specifies the name of the Hours of Operation."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_connect_hours_of_operation, name must not be empty."
  }
}

variable "description" {
  description = "Specifies the description of the Hours of Operation."
  type        = string
  default     = null
}

variable "time_zone" {
  description = "Specifies the time zone of the Hours of Operation."
  type        = string

  validation {
    condition     = length(var.time_zone) > 0
    error_message = "resource_aws_connect_hours_of_operation, time_zone must not be empty."
  }
}

variable "config" {
  description = "One or more config blocks which define the configuration information for the hours of operation: day, start time, and end time."
  type = list(object({
    day = string
    end_time = object({
      hours   = number
      minutes = number
    })
    start_time = object({
      hours   = number
      minutes = number
    })
  }))

  validation {
    condition     = length(var.config) > 0
    error_message = "resource_aws_connect_hours_of_operation, config must contain at least one configuration block."
  }

  validation {
    condition = alltrue([
      for c in var.config : contains([
        "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"
      ], c.day)
    ])
    error_message = "resource_aws_connect_hours_of_operation, config day must be one of: MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY."
  }

  validation {
    condition = alltrue([
      for c in var.config : c.start_time.hours >= 0 && c.start_time.hours <= 23
    ])
    error_message = "resource_aws_connect_hours_of_operation, config start_time hours must be between 0 and 23."
  }

  validation {
    condition = alltrue([
      for c in var.config : c.start_time.minutes >= 0 && c.start_time.minutes <= 59
    ])
    error_message = "resource_aws_connect_hours_of_operation, config start_time minutes must be between 0 and 59."
  }

  validation {
    condition = alltrue([
      for c in var.config : c.end_time.hours >= 0 && c.end_time.hours <= 23
    ])
    error_message = "resource_aws_connect_hours_of_operation, config end_time hours must be between 0 and 23."
  }

  validation {
    condition = alltrue([
      for c in var.config : c.end_time.minutes >= 0 && c.end_time.minutes <= 59
    ])
    error_message = "resource_aws_connect_hours_of_operation, config end_time minutes must be between 0 and 59."
  }
}

variable "tags" {
  description = "Tags to apply to the Hours of Operation."
  type        = map(string)
  default     = {}
}