variable "configuration_name" {
  description = "Name of the Slack channel configuration"
  type        = string

  validation {
    condition     = length(var.configuration_name) > 0
    error_message = "resource_aws_chatbot_slack_channel_configuration, configuration_name must not be empty."
  }
}

variable "iam_role_arn" {
  description = "User-defined role that AWS Chatbot assumes. This is not the service-linked role"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.iam_role_arn))
    error_message = "resource_aws_chatbot_slack_channel_configuration, iam_role_arn must be a valid IAM role ARN."
  }
}

variable "slack_channel_id" {
  description = "ID of the Slack channel. For example, C07EZ1ABC23"
  type        = string

  validation {
    condition     = length(var.slack_channel_id) > 0
    error_message = "resource_aws_chatbot_slack_channel_configuration, slack_channel_id must not be empty."
  }
}

variable "slack_team_id" {
  description = "ID of the Slack workspace authorized with AWS Chatbot. For example, T07EA123LEP"
  type        = string

  validation {
    condition     = length(var.slack_team_id) > 0
    error_message = "resource_aws_chatbot_slack_channel_configuration, slack_team_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "guardrail_policy_arns" {
  description = "List of IAM policy ARNs that are applied as channel guardrails. The AWS managed AdministratorAccess policy is applied by default if this is not set"
  type        = list(string)
  default     = null

  validation {
    condition = var.guardrail_policy_arns == null || alltrue([
      for arn in var.guardrail_policy_arns : can(regex("^arn:aws:iam::", arn))
    ])
    error_message = "resource_aws_chatbot_slack_channel_configuration, guardrail_policy_arns must contain valid IAM policy ARNs."
  }
}

variable "logging_level" {
  description = "Logging levels include ERROR, INFO, or NONE"
  type        = string
  default     = null

  validation {
    condition     = var.logging_level == null || contains(["ERROR", "INFO", "NONE"], var.logging_level)
    error_message = "resource_aws_chatbot_slack_channel_configuration, logging_level must be one of: ERROR, INFO, or NONE."
  }
}

variable "sns_topic_arns" {
  description = "ARNs of the SNS topics that deliver notifications to AWS Chatbot"
  type        = list(string)
  default     = null

  validation {
    condition = var.sns_topic_arns == null || alltrue([
      for arn in var.sns_topic_arns : can(regex("^arn:aws:sns:", arn))
    ])
    error_message = "resource_aws_chatbot_slack_channel_configuration, sns_topic_arns must contain valid SNS topic ARNs."
  }
}

variable "tags" {
  description = "Map of tags assigned to the resource"
  type        = map(string)
  default     = {}
}

variable "user_authorization_required" {
  description = "Enables use of a user role requirement in your chat configuration"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}