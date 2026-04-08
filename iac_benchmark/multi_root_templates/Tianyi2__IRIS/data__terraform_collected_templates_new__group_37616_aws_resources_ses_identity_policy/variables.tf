variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "identity" {
  description = "Name or Amazon Resource Name (ARN) of the SES Identity."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.identity)) || can(regex("^arn:aws:ses:", var.identity))
    error_message = "resource_aws_ses_identity_policy, identity must be a valid identity name or ARN."
  }
}

variable "name" {
  description = "Name of the policy."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_ses_identity_policy, name must be between 1 and 64 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_ses_identity_policy, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "policy" {
  description = "JSON string of the policy."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_ses_identity_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_ses_identity_policy, policy cannot be empty."
  }
}