variable "role" {
  description = "The name of the IAM role to which the policy should be applied"
  type        = string

  validation {
    condition     = length(var.role) > 0
    error_message = "resource_aws_iam_role_policy_attachment, role must not be empty."
  }
}

variable "policy_arn" {
  description = "The ARN of the policy you want to apply"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.policy_arn))
    error_message = "resource_aws_iam_role_policy_attachment, policy_arn must be a valid IAM policy ARN starting with 'arn:aws:iam::'."
  }
}