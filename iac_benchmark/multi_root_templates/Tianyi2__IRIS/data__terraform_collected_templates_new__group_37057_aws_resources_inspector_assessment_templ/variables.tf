variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the assessment template."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_inspector_assessment_template, name must not be empty."
  }
}

variable "target_arn" {
  description = "The assessment target ARN to attach the template to."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:inspector:", var.target_arn))
    error_message = "resource_aws_inspector_assessment_template, target_arn must be a valid Inspector target ARN."
  }
}

variable "duration" {
  description = "The duration of the inspector run."
  type        = number

  validation {
    condition     = var.duration > 0
    error_message = "resource_aws_inspector_assessment_template, duration must be greater than 0."
  }
}

variable "rules_package_arns" {
  description = "The rules to be used during the run."
  type        = list(string)

  validation {
    condition     = length(var.rules_package_arns) > 0
    error_message = "resource_aws_inspector_assessment_template, rules_package_arns must contain at least one rule package ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.rules_package_arns : can(regex("^arn:aws:inspector:", arn))
    ])
    error_message = "resource_aws_inspector_assessment_template, rules_package_arns must contain valid Inspector rule package ARNs."
  }
}

variable "event_subscription" {
  description = "A block that enables sending notifications about a specified assessment template event to a designated SNS topic."
  type = object({
    event     = string
    topic_arn = string
  })
  default = null

  validation {
    condition = var.event_subscription == null || contains([
      "ASSESSMENT_RUN_STARTED",
      "ASSESSMENT_RUN_COMPLETED",
      "ASSESSMENT_RUN_STATE_CHANGED",
      "FINDING_REPORTED"
    ], var.event_subscription.event)
    error_message = "resource_aws_inspector_assessment_template, event_subscription.event must be one of: ASSESSMENT_RUN_STARTED, ASSESSMENT_RUN_COMPLETED, ASSESSMENT_RUN_STATE_CHANGED, FINDING_REPORTED."
  }

  validation {
    condition     = var.event_subscription == null || can(regex("^arn:aws:sns:", var.event_subscription.topic_arn))
    error_message = "resource_aws_inspector_assessment_template, event_subscription.topic_arn must be a valid SNS topic ARN."
  }
}

variable "tags" {
  description = "Key-value map of tags for the Inspector assessment template."
  type        = map(string)
  default     = {}
}