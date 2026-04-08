variable "event_pattern" {
  description = "JSON string defining the event pattern to match. Maximum length is 4096 characters."
  type        = string
  default     = null

  validation {
    condition     = var.event_pattern == null || length(var.event_pattern) <= 4096
    error_message = "resource_aws_notifications_event_rule, event_pattern must be at most 4096 characters."
  }
}

variable "event_type" {
  description = "Type of event to match. Must be between 1 and 128 characters, and match the pattern ([a-zA-Z0-9 \\-\\(\\)])+."
  type        = string

  validation {
    condition     = length(var.event_type) >= 1 && length(var.event_type) <= 128
    error_message = "resource_aws_notifications_event_rule, event_type must be between 1 and 128 characters."
  }

  validation {
    condition     = can(regex("^([a-zA-Z0-9 \\-\\(\\)])+$", var.event_type))
    error_message = "resource_aws_notifications_event_rule, event_type must match the pattern ([a-zA-Z0-9 \\-\\(\\)])+."
  }
}

variable "notification_configuration_arn" {
  description = "ARN of the notification configuration to associate with this event rule. Must match the pattern arn:aws:notifications::[0-9]{12}:configuration/[a-z0-9]{27}."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:notifications::[0-9]{12}:configuration/[a-z0-9]{27}$", var.notification_configuration_arn))
    error_message = "resource_aws_notifications_event_rule, notification_configuration_arn must match the pattern arn:aws:notifications::[0-9]{12}:configuration/[a-z0-9]{27}."
  }
}

variable "regions" {
  description = "Set of AWS regions where the event rule will be applied. Each region must be between 2 and 25 characters, and match the pattern ([a-z]{1,2})-([a-z]{1,15}-)+([0-9])."
  type        = set(string)

  validation {
    condition     = length(var.regions) > 0
    error_message = "resource_aws_notifications_event_rule, regions must contain at least one region."
  }

  validation {
    condition = alltrue([
      for region in var.regions :
      length(region) >= 2 && length(region) <= 25
    ])
    error_message = "resource_aws_notifications_event_rule, regions each region must be between 2 and 25 characters."
  }

  validation {
    condition = alltrue([
      for region in var.regions :
      can(regex("^([a-z]{1,2})-([a-z]{1,15}-)+([0-9])$", region))
    ])
    error_message = "resource_aws_notifications_event_rule, regions each region must match the pattern ([a-z]{1,2})-([a-z]{1,15}-)+([0-9])."
  }
}

variable "event_source" {
  description = "Source of the event. Must be between 1 and 36 characters, and match the pattern aws.([a-z0-9\\-])+."
  type        = string

  validation {
    condition     = length(var.event_source) >= 1 && length(var.event_source) <= 36
    error_message = "resource_aws_notifications_event_rule, event_source must be between 1 and 36 characters."
  }

  validation {
    condition     = can(regex("^aws\\.([a-z0-9\\-])+$", var.event_source))
    error_message = "resource_aws_notifications_event_rule, event_source must match the pattern aws.([a-z0-9\\-])+."
  }
}

