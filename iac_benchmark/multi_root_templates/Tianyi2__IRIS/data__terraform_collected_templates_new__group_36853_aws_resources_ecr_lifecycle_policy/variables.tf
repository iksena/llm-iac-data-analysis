variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_ecr_lifecycle_policy, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "repository" {
  description = "Name of the repository to apply the policy."
  type        = string

  validation {
    condition     = length(var.repository) > 0 && length(var.repository) <= 256
    error_message = "resource_aws_ecr_lifecycle_policy, repository name must be between 1 and 256 characters."
  }

  validation {
    condition     = can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", var.repository))
    error_message = "resource_aws_ecr_lifecycle_policy, repository name must contain only lowercase letters, numbers, hyphens, underscores, and periods."
  }
}

variable "policy" {
  description = "The policy document. This is a JSON formatted string. See more details about Policy Parameters in the official AWS docs."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_ecr_lifecycle_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_ecr_lifecycle_policy, policy cannot be empty."
  }
}