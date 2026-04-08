variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of event subscription."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "resource_aws_dms_event_subscription, name must be a non-empty string."
  }
}

variable "enabled" {
  description = "Whether the event subscription should be enabled."
  type        = bool
  default     = true
}

variable "event_categories" {
  description = "List of event categories to listen for, see DescribeEventCategories for a canonical list."
  type        = list(string)
  default     = null
}

variable "sns_topic_arn" {
  description = "SNS topic arn to send events on."
  type        = string

  validation {
    condition     = var.sns_topic_arn != null && var.sns_topic_arn != ""
    error_message = "resource_aws_dms_event_subscription, sns_topic_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws:sns:", var.sns_topic_arn))
    error_message = "resource_aws_dms_event_subscription, sns_topic_arn must be a valid SNS topic ARN."
  }
}

variable "source_ids" {
  description = "Ids of sources to listen to. If you don't specify a value, notifications are provided for all sources."
  type        = list(string)
  default     = null
}

variable "source_type" {
  description = "Type of source for events. Valid values: replication-instance or replication-task."
  type        = string

  validation {
    condition     = var.source_type != null && var.source_type != ""
    error_message = "resource_aws_dms_event_subscription, source_type must be a non-empty string."
  }

  validation {
    condition     = contains(["replication-instance", "replication-task"], var.source_type)
    error_message = "resource_aws_dms_event_subscription, source_type must be either 'replication-instance' or 'replication-task'."
  }
}

variable "tags" {
  description = "Map of resource tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}