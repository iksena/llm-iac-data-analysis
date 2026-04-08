variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ecr_repository_policy, region must be a valid AWS region format."
  }
}

variable "repository" {
  description = "Name of the repository to apply the policy."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9._/-]+$", var.repository)) && length(var.repository) >= 2 && length(var.repository) <= 256
    error_message = "resource_aws_ecr_repository_policy, repository must be a valid ECR repository name (2-256 characters, lowercase letters, numbers, hyphens, underscores, periods, and forward slashes)."
  }
}

variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_ecr_repository_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_ecr_repository_policy, policy cannot be empty."
  }
}