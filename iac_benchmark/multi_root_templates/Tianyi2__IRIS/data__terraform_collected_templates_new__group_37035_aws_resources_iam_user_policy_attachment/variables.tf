variable "user" {
  description = "The user the policy should be applied to"
  type        = string

  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_iam_user_policy_attachment, user must not be empty."
  }
}

variable "policy_arn" {
  description = "The ARN of the policy you want to apply"
  type        = string

  validation {
    condition     = length(var.policy_arn) > 0
    error_message = "resource_aws_iam_user_policy_attachment, policy_arn must not be empty."
  }

  validation {
    condition     = can(regex("^arn:aws:iam::", var.policy_arn))
    error_message = "resource_aws_iam_user_policy_attachment, policy_arn must be a valid IAM policy ARN starting with 'arn:aws:iam::'."
  }
}