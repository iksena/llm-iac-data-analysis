variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Redshift event subscription."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_redshift_event_subscription, name must not be empty."
  }
}

variable "sns_topic_arn" {
  description = "The ARN of the SNS topic to send events to."
  type        = string

  validation {
    condition     = length(var.sns_topic_arn) > 0
    error_message = "resource_aws_redshift_event_subscription, sns_topic_arn must not be empty."
  }

  validation {
    condition     = can(regex("^arn:aws[a-z0-9-]*:sns:", var.sns_topic_arn))
    error_message = "resource_aws_redshift_event_subscription, sns_topic_arn must be a valid SNS topic ARN."
  }
}

variable "source_ids" {
  description = "A list of identifiers of the event sources for which events will be returned. If not specified, then all sources are included in the response. If specified, a source_type must also be specified."
  type        = list(string)
  default     = null
}

variable "source_type" {
  description = "The type of source that will be generating the events. Valid options are cluster, cluster-parameter-group, cluster-security-group, cluster-snapshot, or scheduled-action. If not set, all sources will be subscribed to."
  type        = string
  default     = null

  validation {
    condition = var.source_type == null || contains([
      "cluster",
      "cluster-parameter-group",
      "cluster-security-group",
      "cluster-snapshot",
      "scheduled-action"
    ], var.source_type)
    error_message = "resource_aws_redshift_event_subscription, source_type must be one of: cluster, cluster-parameter-group, cluster-security-group, cluster-snapshot, or scheduled-action."
  }
}

variable "severity" {
  description = "The event severity to be published by the notification subscription. Valid options are INFO or ERROR. Default value of INFO."
  type        = string
  default     = "INFO"

  validation {
    condition     = contains(["INFO", "ERROR"], var.severity)
    error_message = "resource_aws_redshift_event_subscription, severity must be either INFO or ERROR."
  }
}

variable "event_categories" {
  description = "A list of event categories for a SourceType that you want to subscribe to."
  type        = list(string)
  default     = null
}

variable "enabled" {
  description = "A boolean flag to enable/disable the subscription. Defaults to true."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}