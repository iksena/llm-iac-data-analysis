variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the repository."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+(?:[._-][a-z0-9]+)*$", var.name))
    error_message = "resource_aws_ecr_repository, name must contain only lowercase letters, numbers, hyphens, underscores, and periods."
  }
}

variable "encryption_configuration" {
  description = "Encryption configuration for the repository."
  type = object({
    encryption_type = optional(string, "AES256")
    kms_key         = optional(string)
  })
  default = null

  validation {
    condition     = var.encryption_configuration == null ? true : contains(["AES256", "KMS"], var.encryption_configuration.encryption_type)
    error_message = "resource_aws_ecr_repository, encryption_configuration.encryption_type must be either 'AES256' or 'KMS'."
  }

  validation {
    condition = var.encryption_configuration == null ? true : (
      var.encryption_configuration.encryption_type == "KMS" && var.encryption_configuration.kms_key != null ? can(regex("^arn:aws:kms:", var.encryption_configuration.kms_key)) : true
    )
    error_message = "resource_aws_ecr_repository, encryption_configuration.kms_key must be a valid KMS key ARN when encryption_type is 'KMS'."
  }
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images. Defaults to false."
  type        = bool
  default     = false
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION. Defaults to MUTABLE."
  type        = string
  default     = "MUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE", "IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], var.image_tag_mutability)
    error_message = "resource_aws_ecr_repository, image_tag_mutability must be one of: MUTABLE, IMMUTABLE, IMMUTABLE_WITH_EXCLUSION, or MUTABLE_WITH_EXCLUSION."
  }
}

variable "image_tag_mutability_exclusion_filter" {
  description = "Configuration block that defines filters to specify which image tags can override the default tag mutability setting. Only applicable when image_tag_mutability is set to IMMUTABLE_WITH_EXCLUSION or MUTABLE_WITH_EXCLUSION."
  type = list(object({
    filter      = string
    filter_type = string
  }))
  default = null

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null ? true : alltrue([
      for filter in var.image_tag_mutability_exclusion_filter :
      can(regex("^[a-zA-Z0-9._*-]+$", filter.filter)) && length(filter.filter) <= 128
    ])
    error_message = "resource_aws_ecr_repository, image_tag_mutability_exclusion_filter.filter must contain only letters, numbers, and special characters (._*-), be up to 128 characters long, and contain a maximum of 2 wildcards (*)."
  }

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null ? true : alltrue([
      for filter in var.image_tag_mutability_exclusion_filter :
      filter.filter_type == "WILDCARD"
    ])
    error_message = "resource_aws_ecr_repository, image_tag_mutability_exclusion_filter.filter_type must be 'WILDCARD'."
  }

  validation {
    condition = var.image_tag_mutability_exclusion_filter == null ? true : alltrue([
      for filter in var.image_tag_mutability_exclusion_filter :
      length(regex("\\*", filter.filter)) <= 2
    ])
    error_message = "resource_aws_ecr_repository, image_tag_mutability_exclusion_filter.filter can contain a maximum of 2 wildcards (*)."
  }

  validation {
    condition     = var.image_tag_mutability_exclusion_filter != null ? contains(["IMMUTABLE_WITH_EXCLUSION", "MUTABLE_WITH_EXCLUSION"], var.image_tag_mutability) : true
    error_message = "resource_aws_ecr_repository, image_tag_mutability_exclusion_filter can only be used when image_tag_mutability is set to IMMUTABLE_WITH_EXCLUSION or MUTABLE_WITH_EXCLUSION."
  }
}

variable "image_scanning_configuration" {
  description = "Configuration block that defines image scanning configuration for the repository. By default, image scanning must be manually triggered."
  type = object({
    scan_on_push = bool
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    delete = optional(string, "20m")
  })
  default = null
}