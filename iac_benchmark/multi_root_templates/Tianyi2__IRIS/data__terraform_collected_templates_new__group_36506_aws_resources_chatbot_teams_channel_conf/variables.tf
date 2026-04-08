variable "channel_id" {
  description = "ID of the Microsoft Teams channel"
  type        = string

  validation {
    condition     = length(var.channel_id) > 0
    error_message = "resource_aws_chatbot_teams_channel_configuration, channel_id must not be empty."
  }
}

variable "configuration_name" {
  description = "Name of the Microsoft Teams channel configuration"
  type        = string

  validation {
    condition     = length(var.configuration_name) > 0
    error_message = "resource_aws_chatbot_teams_channel_configuration, configuration_name must not be empty."
  }
}

variable "iam_role_arn" {
  description = "ARN of the IAM role that defines the permissions for AWS Chatbot"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "resource_aws_chatbot_teams_channel_configuration, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "team_id" {
  description = "ID of the Microsoft Team authorized with AWS Chatbot"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.team_id))
    error_message = "resource_aws_chatbot_teams_channel_configuration, team_id must be a valid UUID format."
  }
}

variable "tenant_id" {
  description = "ID of the Microsoft Teams tenant"
  type        = string

  validation {
    condition     = length(var.tenant_id) > 0
    error_message = "resource_aws_chatbot_teams_channel_configuration, tenant_id must not be empty."
  }
}

variable "channel_name" {
  description = "Name of the Microsoft Teams channel"
  type        = string
  default     = null
}

variable "guardrail_policy_arns" {
  description = "List of IAM policy ARNs that are applied as channel guardrails"
  type        = list(string)
  default     = null

  validation {
    condition = var.guardrail_policy_arns == null ? true : alltrue([
      for arn in var.guardrail_policy_arns : can(regex("^arn:aws:iam::(aws|[0-9]{12}):policy/.+", arn))
    ])
    error_message = "resource_aws_chatbot_teams_channel_configuration, guardrail_policy_arns must be valid IAM policy ARNs."
  }
}

variable "logging_level" {
  description = "Logging levels include ERROR, INFO, or NONE"
  type        = string
  default     = null

  validation {
    condition     = var.logging_level == null ? true : contains(["ERROR", "INFO", "NONE"], var.logging_level)
    error_message = "resource_aws_chatbot_teams_channel_configuration, logging_level must be one of: ERROR, INFO, NONE."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "sns_topic_arns" {
  description = "ARNs of the SNS topics that deliver notifications to AWS Chatbot"
  type        = list(string)
  default     = null

  validation {
    condition = var.sns_topic_arns == null ? true : alltrue([
      for arn in var.sns_topic_arns : can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:.+", arn))
    ])
    error_message = "resource_aws_chatbot_teams_channel_configuration, sns_topic_arns must be valid SNS topic ARNs."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "team_name" {
  description = "Name of the Microsoft Teams team"
  type        = string
  default     = null
}

variable "user_authorization_required" {
  description = "Enables use of a user role requirement in your chat configuration"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = {}
}