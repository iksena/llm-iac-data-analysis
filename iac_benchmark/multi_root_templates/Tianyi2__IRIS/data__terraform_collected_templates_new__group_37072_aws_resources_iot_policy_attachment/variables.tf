variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_iot_policy_attachment, region must be a valid AWS region identifier or null."
  }
}

variable "policy" {
  description = "The name of the policy to attach."
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_iot_policy_attachment, policy cannot be empty."
  }
}

variable "target" {
  description = "The identity to which the policy is attached."
  type        = string

  validation {
    condition     = length(var.target) > 0
    error_message = "resource_aws_iot_policy_attachment, target cannot be empty."
  }
}