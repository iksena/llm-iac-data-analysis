variable "arn" {
  description = "The ARN of the SNS topic"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sns:", var.arn))
    error_message = "resource_aws_sns_topic_policy, arn must be a valid SNS topic ARN starting with 'arn:aws:sns:'."
  }
}

variable "policy" {
  description = "The fully-formed AWS policy as JSON"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_sns_topic_policy, policy must be valid JSON."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_sns_topic_policy, region must be a valid AWS region format or null."
  }
}