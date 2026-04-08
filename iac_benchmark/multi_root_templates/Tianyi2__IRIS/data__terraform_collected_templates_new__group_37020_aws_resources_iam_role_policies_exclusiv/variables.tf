variable "role_name" {
  description = "IAM role name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role_name))
    error_message = "resource_aws_iam_role_policies_exclusive, role_name must be a valid IAM role name containing only alphanumeric characters and the following characters: +=,.@_-"
  }

  validation {
    condition     = length(var.role_name) >= 1 && length(var.role_name) <= 64
    error_message = "resource_aws_iam_role_policies_exclusive, role_name must be between 1 and 64 characters in length"
  }
}

variable "policy_names" {
  description = "A list of inline policy names to be assigned to the role. Policies attached to this role but not configured in this argument will be removed"
  type        = list(string)

  validation {
    condition = alltrue([
      for policy_name in var.policy_names : can(regex("^[a-zA-Z0-9+=,.@_-]+$", policy_name))
    ])
    error_message = "resource_aws_iam_role_policies_exclusive, policy_names must contain only valid IAM policy names with alphanumeric characters and the following characters: +=,.@_-"
  }

  validation {
    condition = alltrue([
      for policy_name in var.policy_names : length(policy_name) >= 1 && length(policy_name) <= 128
    ])
    error_message = "resource_aws_iam_role_policies_exclusive, policy_names must be between 1 and 128 characters in length"
  }
}