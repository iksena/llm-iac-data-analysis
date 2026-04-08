variable "user_name" {
  description = "IAM user name."
  type        = string

  validation {
    condition     = length(var.user_name) > 0
    error_message = "resource_aws_iam_user_policies_exclusive, user_name must not be empty."
  }
}

variable "policy_names" {
  description = "A list of inline policy names to be assigned to the user. Policies attached to this user but not configured in this argument will be removed."
  type        = list(string)

  validation {
    condition     = var.policy_names != null
    error_message = "resource_aws_iam_user_policies_exclusive, policy_names must be defined (can be empty list)."
  }
}