variable "user" {
  description = "The name of the IAM User to add to groups"
  type        = string

  validation {
    condition     = length(var.user) > 0
    error_message = "resource_aws_iam_user_group_membership, user must not be empty."
  }

  validation {
    condition     = can(regex("^[\\w+=,.@-]+$", var.user))
    error_message = "resource_aws_iam_user_group_membership, user must contain only valid IAM user name characters (alphanumeric characters plus '+=,.@-')."
  }
}

variable "groups" {
  description = "A list of IAM Groups to add the user to"
  type        = list(string)

  validation {
    condition     = length(var.groups) > 0
    error_message = "resource_aws_iam_user_group_membership, groups must contain at least one group."
  }

  validation {
    condition = alltrue([
      for group in var.groups : length(group) > 0
    ])
    error_message = "resource_aws_iam_user_group_membership, groups cannot contain empty group names."
  }

  validation {
    condition = alltrue([
      for group in var.groups : can(regex("^[\\w+=,.@-]+$", group))
    ])
    error_message = "resource_aws_iam_user_group_membership, groups must contain only valid IAM group name characters (alphanumeric characters plus '+=,.@-')."
  }
}