variable "role_name" {
  description = "IAM role name"
  type        = string

  validation {
    condition     = length(var.role_name) > 0 && length(var.role_name) <= 64
    error_message = "resource_aws_iam_role_policy_attachments_exclusive, role_name must be between 1 and 64 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_name))
    error_message = "resource_aws_iam_role_policy_attachments_exclusive, role_name must contain only alphanumeric characters and the following special characters: +=,.@_-"
  }
}

variable "policy_arns" {
  description = "A list of managed IAM policy ARNs to be attached to the role. Policies attached to this role but not configured in this argument will be removed."
  type        = list(string)

  validation {
    condition = alltrue([
      for arn in var.policy_arns : can(regex("^arn:aws[a-z0-9-]*:iam::[0-9]{12}:policy/.+$", arn)) || can(regex("^arn:aws[a-z0-9-]*:iam::aws:policy/.+$", arn))
    ])
    error_message = "resource_aws_iam_role_policy_attachments_exclusive, policy_arns must contain valid IAM policy ARNs."
  }
}