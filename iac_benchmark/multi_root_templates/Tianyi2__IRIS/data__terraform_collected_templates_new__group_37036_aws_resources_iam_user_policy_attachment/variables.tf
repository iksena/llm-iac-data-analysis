variable "user_name" {
  description = "IAM user name."
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.user_name))
    error_message = "resource_aws_iam_user_policy_attachments_exclusive, user_name must be a valid IAM user name containing only alphanumeric characters and/or the following: +=,.@-"
  }

  validation {
    condition     = length(var.user_name) >= 1 && length(var.user_name) <= 64
    error_message = "resource_aws_iam_user_policy_attachments_exclusive, user_name must be between 1 and 64 characters in length."
  }
}

variable "policy_arns" {
  description = "A list of managed IAM policy ARNs to be attached to the user. Policies attached to this user but not configured in this argument will be removed."
  type        = list(string)

  validation {
    condition = alltrue([
      for arn in var.policy_arns : can(regex("^arn:aws:iam::[0-9]{12}:policy/[\\w+=,.@-]+$", arn)) || can(regex("^arn:aws:iam::aws:policy/[\\w+=,.@-]+$", arn))
    ])
    error_message = "resource_aws_iam_user_policy_attachments_exclusive, policy_arns must contain valid IAM policy ARNs."
  }

  validation {
    condition     = length(var.policy_arns) == length(distinct(var.policy_arns))
    error_message = "resource_aws_iam_user_policy_attachments_exclusive, policy_arns must not contain duplicate values."
  }
}