variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "prefix" {
  description = "The repository name prefix to match against. Use ROOT to match any prefix that doesn't explicitly match another template."
  type        = string

  validation {
    condition     = length(var.prefix) > 0
    error_message = "resource_aws_ecr_repository_creation_template, prefix must not be empty."
  }
}

variable "applied_for" {
  description = "Which features this template applies to. Must contain one or more of PULL_THROUGH_CACHE or REPLICATION."
  type        = list(string)

  validation {
    condition     = length(var.applied_for) > 0
    error_message = "resource_aws_ecr_repository_creation_template, applied_for must contain at least one value."
  }

  validation {
    condition = alltrue([
      for feature in var.applied_for : contains(["PULL_THROUGH_CACHE", "REPLICATION"], feature)
    ])
    error_message = "resource_aws_ecr_repository_creation_template, applied_for must contain only PULL_THROUGH_CACHE or REPLICATION values."
  }
}

variable "custom_role_arn" {
  description = "A custom IAM role to use for repository creation. Required if using repository tags or KMS encryption."
  type        = string
  default     = null

  validation {
    condition     = var.custom_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.custom_role_arn))
    error_message = "resource_aws_ecr_repository_creation_template, custom_role_arn must be a valid IAM role ARN."
  }
}

variable "description" {
  description = "The description for this template."
  type        = string
  default     = null
}

variable "encryption_configuration" {
  description = "Encryption configuration for any created repositories."
  type = object({
    encryption_type = optional(string, "AES256")
    kms_key         = optional(string)
  })
  default = null

  validation {
    condition     = var.encryption_configuration == null || contains(["AES256", "KMS"], var.encryption_configuration.encryption_type)
    error_message = "resource_aws_ecr_repository_creation_template, encryption_configuration.encryption_type must be AES256 or KMS."
  }

  validation {
    condition     = var.encryption_configuration == null || var.encryption_configuration.encryption_type != "KMS" || var.encryption_configuration.kms_key != null
    error_message = "resource_aws_ecr_repository_creation_template, encryption_configuration.kms_key is required when encryption_type is KMS."
  }

  validation {
    condition     = var.encryption_configuration == null || var.encryption_configuration.kms_key == null || can(regex("^arn:aws:kms:", var.encryption_configuration.kms_key))
    error_message = "resource_aws_ecr_repository_creation_template, encryption_configuration.kms_key must be a valid KMS key ARN."
  }
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for any created repositories. Must be one of: MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE", "IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], var.image_tag_mutability)
    error_message = "resource_aws_ecr_repository_creation_template, image_tag_mutability must be MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION."
  }
}

variable "image_tag_mutability_exclusion_filter" {
  description = "Configuration block that defines filters to specify which image tags can override the default tag mutability setting."
  type = list(object({
    filter      = string
    filter_type = string
  }))
  default = null

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null || alltrue([
      for filter in var.image_tag_mutability_exclusion_filter : filter.filter_type == "WILDCARD"
    ])
    error_message = "resource_aws_ecr_repository_creation_template, image_tag_mutability_exclusion_filter.filter_type must be WILDCARD."
  }

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null || alltrue([
      for filter in var.image_tag_mutability_exclusion_filter : can(regex("^[a-zA-Z0-9._*-]+$", filter.filter))
    ])
    error_message = "resource_aws_ecr_repository_creation_template, image_tag_mutability_exclusion_filter.filter must contain only letters, numbers, and special characters (._*-)."
  }

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null || alltrue([
      for filter in var.image_tag_mutability_exclusion_filter : length(filter.filter) <= 128
    ])
    error_message = "resource_aws_ecr_repository_creation_template, image_tag_mutability_exclusion_filter.filter must be up to 128 characters long."
  }

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null || alltrue([
      for filter in var.image_tag_mutability_exclusion_filter : length(regexall("\\*", filter.filter)) <= 2
    ])
    error_message = "resource_aws_ecr_repository_creation_template, image_tag_mutability_exclusion_filter.filter can contain a maximum of 2 wildcards (*)."
  }
}

variable "lifecycle_policy" {
  description = "The lifecycle policy document to apply to any created repositories. JSON formatted string."
  type        = string
  default     = null

  validation {
    condition     = var.lifecycle_policy == null || can(jsondecode(var.lifecycle_policy))
    error_message = "resource_aws_ecr_repository_creation_template, lifecycle_policy must be valid JSON."
  }
}

variable "repository_policy" {
  description = "The registry policy document to apply to any created repositories. JSON formatted string."
  type        = string
  default     = null

  validation {
    condition     = var.repository_policy == null || can(jsondecode(var.repository_policy))
    error_message = "resource_aws_ecr_repository_creation_template, repository_policy must be valid JSON."
  }
}

variable "resource_tags" {
  description = "A map of tags to assign to any created repositories."
  type        = map(string)
  default     = null
}