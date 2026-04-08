variable "name" {
  description = "The name of the policy. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    error_message = "resource_aws_iam_user_policy, name must contain only alphanumeric characters and +=,.@_- symbols."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "resource_aws_iam_user_policy, name_prefix must contain only alphanumeric characters and +=,.@_- symbols."
  }

  validation {
    condition     = !(var.name != null && var.name_prefix != null)
    error_message = "resource_aws_iam_user_policy, name_prefix conflicts with name. Only one can be specified."
  }
}

variable "user" {
  description = "IAM user to which to attach this policy."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.user))
    error_message = "resource_aws_iam_user_policy, user must contain only alphanumeric characters and +=,.@_- symbols."
  }
}

variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_iam_user_policy, policy must be a valid JSON string."
  }
}