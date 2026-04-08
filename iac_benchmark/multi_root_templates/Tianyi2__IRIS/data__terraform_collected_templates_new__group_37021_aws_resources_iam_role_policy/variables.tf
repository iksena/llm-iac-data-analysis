variable "name" {
  description = "The name of the role policy. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    error_message = "resource_aws_iam_role_policy, name must contain only alphanumeric characters and +=,.@_-"
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name_prefix))
    error_message = "resource_aws_iam_role_policy, name_prefix must contain only alphanumeric characters and +=,.@_-"
  }
}

variable "policy" {
  description = "The inline policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_iam_role_policy, policy must be a valid JSON string"
  }
}

variable "role" {
  description = "The name of the IAM role to attach to the policy."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.role))
    error_message = "resource_aws_iam_role_policy, role must contain only alphanumeric characters and +=,.@_-"
  }
}