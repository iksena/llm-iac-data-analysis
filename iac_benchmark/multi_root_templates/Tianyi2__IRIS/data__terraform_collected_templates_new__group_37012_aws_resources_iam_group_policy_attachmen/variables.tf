variable "group" {
  description = "The group the policy should be applied to"
  type        = string

  validation {
    condition     = length(var.group) > 0
    error_message = "resource_aws_iam_group_policy_attachment, group must be a non-empty string."
  }
}

variable "policy_arn" {
  description = "The ARN of the policy you want to apply"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.policy_arn))
    error_message = "resource_aws_iam_group_policy_attachment, policy_arn must be a valid IAM policy ARN starting with 'arn:aws:iam::'."
  }
}