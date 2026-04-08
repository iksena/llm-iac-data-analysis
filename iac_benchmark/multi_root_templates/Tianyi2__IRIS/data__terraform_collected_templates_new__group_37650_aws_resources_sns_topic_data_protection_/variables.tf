variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "arn" {
  type        = string
  description = "The ARN of the SNS topic"

  validation {
    condition     = can(regex("^arn:aws:sns:", var.arn))
    error_message = "resource_aws_sns_topic_data_protection_policy, arn must be a valid SNS topic ARN starting with 'arn:aws:sns:'."
  }
}

variable "policy" {
  type        = string
  description = "The fully-formed AWS policy as JSON. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_sns_topic_data_protection_policy, policy must be a valid JSON string."
  }
}