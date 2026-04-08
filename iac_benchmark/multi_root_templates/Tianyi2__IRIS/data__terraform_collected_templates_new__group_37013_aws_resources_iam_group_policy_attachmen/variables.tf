variable "group_name" {
  description = "IAM group name"
  type        = string

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.group_name)) && length(var.group_name) >= 1 && length(var.group_name) <= 128
    error_message = "resource_aws_iam_group_policy_attachments_exclusive, group_name must be between 1 and 128 characters and can contain only alphanumeric characters, plus (+), equal (=), comma (,), period (.), at (@), underscore (_), and hyphen (-) characters."
  }
}

variable "policy_arns" {
  description = "A list of managed IAM policy ARNs to be attached to the group. Policies attached to this group but not configured in this argument will be removed."
  type        = list(string)

  validation {
    condition = alltrue([
      for arn in var.policy_arns : can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/.+$", arn))
    ])
    error_message = "resource_aws_iam_group_policy_attachments_exclusive, policy_arns must be valid IAM policy ARNs in the format 'arn:aws:iam::account-id:policy/policy-name'."
  }
}