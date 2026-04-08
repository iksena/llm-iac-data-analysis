variable "assignment_name" {
  description = "Name of the assignment"
  type        = string

  validation {
    condition     = length(var.assignment_name) > 0
    error_message = "resource_aws_quicksight_iam_policy_assignment, assignment_name must not be empty."
  }
}

variable "assignment_status" {
  description = "Status of the assignment"
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED", "DRAFT"], var.assignment_status)
    error_message = "resource_aws_quicksight_iam_policy_assignment, assignment_status must be one of: ENABLED, DISABLED, DRAFT."
  }
}

variable "aws_account_id" {
  description = "AWS account ID. Defaults to automatically determined account ID of the Terraform AWS provider"
  type        = string
  default     = null

  validation {
    condition     = var.aws_account_id == null || can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_quicksight_iam_policy_assignment, aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "identities" {
  description = "Amazon QuickSight users, groups, or both to assign the policy to"
  type = object({
    group = optional(list(string))
    user  = optional(list(string))
  })
  default = null

  validation {
    condition = var.identities == null || (
      var.identities.group != null && length(var.identities.group) > 0
      ) || (
      var.identities.user != null && length(var.identities.user) > 0
    )
    error_message = "resource_aws_quicksight_iam_policy_assignment, identities must contain at least one group or user when specified."
  }
}

variable "namespace" {
  description = "Namespace that contains the assignment"
  type        = string
  default     = "default"

  validation {
    condition     = length(var.namespace) > 0
    error_message = "resource_aws_quicksight_iam_policy_assignment, namespace must not be empty."
  }
}

variable "policy_arn" {
  description = "ARN of the IAM policy to apply to the Amazon QuickSight users and groups specified in this assignment"
  type        = string
  default     = null

  validation {
    condition     = var.policy_arn == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:policy/.+$", var.policy_arn))
    error_message = "resource_aws_quicksight_iam_policy_assignment, policy_arn must be a valid IAM policy ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_quicksight_iam_policy_assignment, region must be a valid AWS region."
  }
}