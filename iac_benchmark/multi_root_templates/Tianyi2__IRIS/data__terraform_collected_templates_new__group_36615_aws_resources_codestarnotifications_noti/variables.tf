variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "detail_type" {
  description = "The level of detail to include in the notifications for this resource"
  type        = string

  validation {
    condition     = contains(["BASIC", "FULL"], var.detail_type)
    error_message = "resource_aws_codestarnotifications_notification_rule, detail_type must be either 'BASIC' or 'FULL'."
  }
}

variable "event_type_ids" {
  description = "A list of event types associated with this notification rule"
  type        = list(string)

  validation {
    condition     = length(var.event_type_ids) > 0
    error_message = "resource_aws_codestarnotifications_notification_rule, event_type_ids must contain at least one event type."
  }
}

variable "name" {
  description = "The name of notification rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_codestarnotifications_notification_rule, name cannot be empty."
  }
}

variable "resource" {
  description = "The ARN of the resource to associate with the notification rule"
  type        = string

  validation {
    condition     = length(var.resource) > 0 && can(regex("^arn:", var.resource))
    error_message = "resource_aws_codestarnotifications_notification_rule, resource must be a valid ARN."
  }
}

variable "status" {
  description = "The status of the notification rule"
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.status)
    error_message = "resource_aws_codestarnotifications_notification_rule, status must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "targets" {
  description = "Configuration blocks containing notification target information"
  type = list(object({
    address = string
    type    = optional(string, "SNS")
  }))
  default = []

  validation {
    condition     = length(var.targets) > 0
    error_message = "resource_aws_codestarnotifications_notification_rule, targets must contain at least one target."
  }

  validation {
    condition = alltrue([
      for target in var.targets : length(target.address) > 0 && can(regex("^arn:", target.address))
    ])
    error_message = "resource_aws_codestarnotifications_notification_rule, targets each target address must be a valid ARN."
  }
}