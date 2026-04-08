variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "ecr_repository_prefix" {
  description = "The repository name prefix to use when caching images from the source registry."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", var.ecr_repository_prefix))
    error_message = "data_aws_ecr_pull_through_cache_rule, ecr_repository_prefix must contain only lowercase letters, numbers, hyphens, underscores, and periods."
  }
}