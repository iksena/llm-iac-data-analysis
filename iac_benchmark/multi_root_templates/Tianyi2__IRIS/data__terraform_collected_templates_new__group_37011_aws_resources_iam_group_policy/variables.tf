variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_iam_group_policy, policy must be a valid JSON string."
  }
}

variable "name" {
  description = "The name of the policy. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    error_message = "resource_aws_iam_group_policy, name must contain only alphanumeric characters and the following characters: +=,.@_-"
  }

  validation {
    condition     = var.name == null || length(var.name) <= 128
    error_message = "resource_aws_iam_group_policy, name must be 128 characters or fewer."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "resource_aws_iam_group_policy, name_prefix must contain only alphanumeric characters and the following characters: +=,.@_-"
  }

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) <= 96
    error_message = "resource_aws_iam_group_policy, name_prefix must be 96 characters or fewer."
  }
}

variable "group" {
  description = "The IAM group to attach to the policy."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_/-]+$", var.group))
    error_message = "resource_aws_iam_group_policy, group must contain only alphanumeric characters and the following characters: +=,.@_/-"
  }

  validation {
    condition     = length(var.group) >= 1 && length(var.group) <= 128
    error_message = "resource_aws_iam_group_policy, group must be between 1 and 128 characters."
  }
}