variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the source S3 bucket you want Amazon S3 to monitor"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, bucket must be a valid S3 bucket name between 3 and 63 characters long, containing only lowercase letters, numbers, dots, and hyphens."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner"
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, expected_bucket_owner must be a 12-digit AWS account ID."
  }
}

variable "transition_default_minimum_object_size" {
  description = "The default minimum object size behavior applied to the lifecycle configuration"
  type        = string
  default     = "all_storage_classes_128K"

  validation {
    condition     = contains(["all_storage_classes_128K", "varies_by_storage_class"], var.transition_default_minimum_object_size)
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, transition_default_minimum_object_size must be either 'all_storage_classes_128K' or 'varies_by_storage_class'."
  }
}

variable "rules" {
  description = "List of configuration blocks describing the rules managing the lifecycle"
  type = list(object({
    id     = string
    prefix = optional(string)
    status = string

    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))

    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))

    filter = optional(object({
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      prefix                   = optional(string)

      and = optional(object({
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        prefix                   = optional(string)
        tags                     = optional(map(string))
      }))

      tag = optional(object({
        key   = string
        value = string
      }))
    }))

    noncurrent_version_expiration = optional(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = number
    }))

    noncurrent_version_transitions = optional(list(object({
      newer_noncurrent_versions = optional(number)
      noncurrent_days           = number
      storage_class             = string
    })))

    transitions = optional(list(object({
      date          = optional(string)
      days          = optional(number)
      storage_class = string
    })))
  }))

  validation {
    condition = alltrue([
      for rule in var.rules : length(rule.id) <= 255
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, id must not be longer than 255 characters."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : contains(["Enabled", "Disabled"], rule.status)
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.abort_incomplete_multipart_upload == null || rule.abort_incomplete_multipart_upload.days_after_initiation > 0
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, days_after_initiation must be a positive integer."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.expiration == null || (
        rule.expiration.days == null || rule.expiration.days > 0
      )
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, expiration days must be a non-zero positive integer."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.expiration == null || (
        rule.expiration.date == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", rule.expiration.date))
      )
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, expiration date must be in RFC3339 full-date format (YYYY-MM-DD)."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.filter == null || rule.filter.object_size_greater_than == null || rule.filter.object_size_greater_than >= 0
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, object_size_greater_than must be at least 0."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.filter == null || rule.filter.object_size_less_than == null || rule.filter.object_size_less_than >= 1
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, object_size_less_than must be at least 1."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.filter == null || rule.filter.and == null || rule.filter.and.object_size_greater_than == null || rule.filter.and.object_size_greater_than >= 0
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, and.object_size_greater_than must be at least 0."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.filter == null || rule.filter.and == null || rule.filter.and.object_size_less_than == null || rule.filter.and.object_size_less_than >= 1
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, and.object_size_less_than must be at least 1."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.filter == null || rule.filter.and == null || rule.filter.and.tags == null || length(rule.filter.and.tags) >= 1
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, and.tags must contain at least one key-value pair if specified."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.noncurrent_version_expiration == null || rule.noncurrent_version_expiration.noncurrent_days > 0
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, noncurrent_version_expiration.noncurrent_days must be a positive integer."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.noncurrent_version_expiration == null || rule.noncurrent_version_expiration.newer_noncurrent_versions == null || rule.noncurrent_version_expiration.newer_noncurrent_versions > 0
    ])
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, noncurrent_version_expiration.newer_noncurrent_versions must be a non-zero positive integer."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for transition in coalesce(rule.noncurrent_version_transitions, []) :
        contains(["GLACIER", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING", "DEEP_ARCHIVE", "GLACIER_IR"], transition.storage_class)
      ]
    ]))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, noncurrent_version_transition.storage_class must be one of: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for transition in coalesce(rule.noncurrent_version_transitions, []) :
        transition.noncurrent_days >= 0
      ]
    ]))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, noncurrent_version_transition.noncurrent_days must be a positive integer."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for transition in coalesce(rule.noncurrent_version_transitions, []) :
        transition.newer_noncurrent_versions == null || transition.newer_noncurrent_versions > 0
      ]
    ]))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, noncurrent_version_transition.newer_noncurrent_versions must be a non-zero positive integer."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for transition in coalesce(rule.transitions, []) :
        contains(["GLACIER", "STANDARD_IA", "ONEZONE_IA", "INTELLIGENT_TIERING", "DEEP_ARCHIVE", "GLACIER_IR"], transition.storage_class)
      ]
    ]))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, transition.storage_class must be one of: GLACIER, STANDARD_IA, ONEZONE_IA, INTELLIGENT_TIERING, DEEP_ARCHIVE, GLACIER_IR."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for transition in coalesce(rule.transitions, []) :
        transition.days == null || transition.days >= 0
      ]
    ]))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, transition.days must be a positive integer."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for transition in coalesce(rule.transitions, []) :
        transition.date == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", transition.date))
      ]
    ]))
    error_message = "resource_aws_s3_bucket_lifecycle_configuration, transition.date must be in RFC3339 full-date format (YYYY-MM-DD)."
  }
}