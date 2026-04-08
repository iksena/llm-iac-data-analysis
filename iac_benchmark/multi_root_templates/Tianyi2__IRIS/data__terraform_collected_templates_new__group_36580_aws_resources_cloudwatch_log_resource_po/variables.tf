variable "policy_document" {
  description = "Details of the resource policy, including the identity of the principal that is enabled to put logs to this account. This is formatted as a JSON string. Maximum length of 5120 characters."
  type        = string

  validation {
    condition     = length(var.policy_document) <= 5120
    error_message = "resource_aws_cloudwatch_log_resource_policy, policy_document must be 5120 characters or less."
  }

  validation {
    condition     = can(jsondecode(var.policy_document))
    error_message = "resource_aws_cloudwatch_log_resource_policy, policy_document must be valid JSON."
  }
}

variable "policy_name" {
  description = "Name of the resource policy."
  type        = string

  validation {
    condition     = length(var.policy_name) > 0
    error_message = "resource_aws_cloudwatch_log_resource_policy, policy_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}