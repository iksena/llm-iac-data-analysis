variable "sns_topic_arn" {
  description = "Amazon Resource Name (ARN) of an Amazon Simple Notification Service topic"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9-_]+$", var.sns_topic_arn))
    error_message = "resource_aws_devopsguru_notification_channel, sns_topic_arn must be a valid SNS topic ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "filters" {
  description = "Filter configurations for the Amazon SNS notification topic"
  type = object({
    message_types = optional(list(string))
    severities    = optional(list(string))
  })
  default = null

  validation {
    condition = var.filters == null || (
      var.filters.message_types == null ||
      alltrue([
        for mt in var.filters.message_types :
        contains(["NEW_INSIGHT", "CLOSED_INSIGHT", "NEW_ASSOCIATION", "SEVERITY_UPGRADED", "NEW_RECOMMENDATION"], mt)
      ])
    )
    error_message = "resource_aws_devopsguru_notification_channel, message_types must contain only valid values: NEW_INSIGHT, CLOSED_INSIGHT, NEW_ASSOCIATION, SEVERITY_UPGRADED, NEW_RECOMMENDATION."
  }

  validation {
    condition = var.filters == null || (
      var.filters.severities == null ||
      alltrue([
        for s in var.filters.severities :
        contains(["LOW", "MEDIUM", "HIGH"], s)
      ])
    )
    error_message = "resource_aws_devopsguru_notification_channel, severities must contain only valid values: LOW, MEDIUM, HIGH."
  }
}