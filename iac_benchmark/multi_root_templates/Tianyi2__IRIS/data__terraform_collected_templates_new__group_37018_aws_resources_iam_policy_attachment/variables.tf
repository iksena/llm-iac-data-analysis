variable "name" {
  description = "Name of the attachment. This cannot be an empty string."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_iam_policy_attachment, name cannot be an empty string."
  }
}

variable "users" {
  description = "User(s) the policy should be applied to."
  type        = list(string)
  default     = null
}

variable "roles" {
  description = "Role(s) the policy should be applied to."
  type        = list(string)
  default     = null
}

variable "groups" {
  description = "Group(s) the policy should be applied to."
  type        = list(string)
  default     = null
}

variable "policy_arn" {
  description = "ARN of the policy you want to apply. Typically this should be a reference to the ARN of another resource to ensure dependency ordering, such as aws_iam_policy.example.arn."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.policy_arn))
    error_message = "resource_aws_iam_policy_attachment, policy_arn must be a valid IAM policy ARN starting with 'arn:aws:iam::'."
  }
}