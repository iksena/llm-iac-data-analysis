variable "group_name" {
  description = "IAM group name"
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.group_name))
    error_message = "resource_aws_iam_group_policies_exclusive, group_name must be a valid IAM group name containing only alphanumeric characters and +=,.@- characters."
  }
}

variable "policy_names" {
  description = "A list of inline policy names to be assigned to the group. Policies attached to this group but not configured in this argument will be removed"
  type        = list(string)

  validation {
    condition = alltrue([
      for policy_name in var.policy_names : can(regex("^[\\w+=,.@-]+$", policy_name))
    ])
    error_message = "resource_aws_iam_group_policies_exclusive, policy_names must contain valid IAM policy names with only alphanumeric characters and +=,.@- characters."
  }
}