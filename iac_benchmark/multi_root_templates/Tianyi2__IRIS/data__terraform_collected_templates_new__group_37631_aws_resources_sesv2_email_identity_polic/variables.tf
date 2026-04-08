variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "email_identity" {
  type        = string
  description = "The email identity."

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$|^[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9]*\\.[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9]*$", var.email_identity))
    error_message = "resource_aws_sesv2_email_identity_policy, email_identity must be a valid email address or domain name."
  }
}

variable "policy_name" {
  type        = string
  description = "The name of the policy."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-_]*[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.policy_name))
    error_message = "resource_aws_sesv2_email_identity_policy, policy_name must be a valid policy name containing only alphanumeric characters, hyphens, and underscores."
  }

  validation {
    condition     = length(var.policy_name) >= 1 && length(var.policy_name) <= 64
    error_message = "resource_aws_sesv2_email_identity_policy, policy_name must be between 1 and 64 characters long."
  }
}

variable "policy" {
  type        = string
  description = "The text of the policy in JSON format."

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_sesv2_email_identity_policy, policy must be valid JSON."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_sesv2_email_identity_policy, policy cannot be empty."
  }
}