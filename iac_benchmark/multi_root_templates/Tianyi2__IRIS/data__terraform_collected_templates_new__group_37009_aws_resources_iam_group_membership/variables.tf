variable "name" {
  description = "The name to identify the Group Membership"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_iam_group_membership, name must not be empty."
  }
}

variable "users" {
  description = "A list of IAM User names to associate with the Group"
  type        = list(string)

  validation {
    condition     = length(var.users) > 0
    error_message = "resource_aws_iam_group_membership, users must contain at least one user."
  }

  validation {
    condition     = alltrue([for user in var.users : length(user) > 0])
    error_message = "resource_aws_iam_group_membership, users must not contain empty strings."
  }
}

variable "group" {
  description = "The IAM Group name to attach the list of users to"
  type        = string

  validation {
    condition     = length(var.group) > 0
    error_message = "resource_aws_iam_group_membership, group must not be empty."
  }
}