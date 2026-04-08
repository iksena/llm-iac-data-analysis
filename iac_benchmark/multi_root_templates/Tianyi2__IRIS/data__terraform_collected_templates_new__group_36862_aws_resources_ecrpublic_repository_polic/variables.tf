variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ecrpublic_repository_policy, region must be a valid AWS region format or null."
  }
}

variable "repository_name" {
  description = "Name of the repository to apply the policy."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", var.repository_name))
    error_message = "resource_aws_ecrpublic_repository_policy, repository_name must be a valid ECR repository name containing only lowercase alphanumeric characters, hyphens, underscores, and periods."
  }

  validation {
    condition     = length(var.repository_name) >= 2 && length(var.repository_name) <= 256
    error_message = "resource_aws_ecrpublic_repository_policy, repository_name must be between 2 and 256 characters in length."
  }
}

variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_ecrpublic_repository_policy, policy must be a valid JSON formatted string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_ecrpublic_repository_policy, policy cannot be empty."
  }
}