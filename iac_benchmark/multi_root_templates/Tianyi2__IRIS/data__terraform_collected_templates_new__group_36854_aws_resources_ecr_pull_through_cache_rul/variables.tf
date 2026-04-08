variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "credential_arn" {
  description = "ARN of the Secret which will be used to authenticate against the registry."
  type        = string
  default     = null

  validation {
    condition     = var.credential_arn == null || can(regex("^arn:aws:secretsmanager:[a-z0-9-]+:[0-9]{12}:secret:.+", var.credential_arn))
    error_message = "resource_aws_ecr_pull_through_cache_rule, credential_arn must be a valid AWS Secrets Manager ARN."
  }
}

variable "custom_role_arn" {
  description = "The ARN of the IAM role associated with the pull through cache rule. Must be specified if the upstream registry is a cross-account ECR private registry."
  type        = string
  default     = null

  validation {
    condition     = var.custom_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.custom_role_arn))
    error_message = "resource_aws_ecr_pull_through_cache_rule, custom_role_arn must be a valid AWS IAM role ARN."
  }
}

variable "ecr_repository_prefix" {
  description = "The repository name prefix to use when caching images from the source registry. Use ROOT as the prefix to apply a template to all repositories in your registry that don't have an associated pull through cache rule."
  type        = string

  validation {
    condition     = length(var.ecr_repository_prefix) > 0
    error_message = "resource_aws_ecr_pull_through_cache_rule, ecr_repository_prefix cannot be empty."
  }
}

variable "upstream_registry_url" {
  description = "The registry URL of the upstream registry to use as the source."
  type        = string

  validation {
    condition     = length(var.upstream_registry_url) > 0
    error_message = "resource_aws_ecr_pull_through_cache_rule, upstream_registry_url cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.upstream_registry_url))
    error_message = "resource_aws_ecr_pull_through_cache_rule, upstream_registry_url must be a valid registry URL."
  }
}

variable "upstream_repository_prefix" {
  description = "The upstream repository prefix associated with the pull through cache rule. Used if the upstream registry is an ECR private registry. If not specified, it's set to ROOT, which allows matching with any upstream repository."
  type        = string
  default     = null
}