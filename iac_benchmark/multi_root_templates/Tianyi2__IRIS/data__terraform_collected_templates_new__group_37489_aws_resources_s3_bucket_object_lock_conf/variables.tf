variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket))
    error_message = "resource_aws_s3_bucket_object_lock_configuration, bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens only)."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_object_lock_configuration, expected_bucket_owner must be a valid 12-digit AWS account ID."
  }
}

variable "object_lock_enabled" {
  description = "Indicates whether this bucket has an Object Lock configuration enabled. Valid values: Enabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = var.object_lock_enabled == "Enabled"
    error_message = "resource_aws_s3_bucket_object_lock_configuration, object_lock_enabled must be 'Enabled'."
  }
}

variable "rule" {
  description = "Configuration block for specifying the Object Lock rule for the specified object."
  type = object({
    default_retention = object({
      days  = optional(number)
      mode  = string
      years = optional(number)
    })
  })
  default = null

  validation {
    condition = var.rule == null || (
      var.rule.default_retention != null &&
      contains(["COMPLIANCE", "GOVERNANCE"], var.rule.default_retention.mode) &&
      (var.rule.default_retention.days != null || var.rule.default_retention.years != null) &&
      !(var.rule.default_retention.days != null && var.rule.default_retention.years != null)
    )
    error_message = "resource_aws_s3_bucket_object_lock_configuration, rule.default_retention.mode must be 'COMPLIANCE' or 'GOVERNANCE', and either 'days' or 'years' must be specified (but not both)."
  }

  validation {
    condition = var.rule == null || (
      var.rule.default_retention == null ||
      var.rule.default_retention.days == null ||
      var.rule.default_retention.days > 0
    )
    error_message = "resource_aws_s3_bucket_object_lock_configuration, rule.default_retention.days must be a positive number when specified."
  }

  validation {
    condition = var.rule == null || (
      var.rule.default_retention == null ||
      var.rule.default_retention.years == null ||
      var.rule.default_retention.years > 0
    )
    error_message = "resource_aws_s3_bucket_object_lock_configuration, rule.default_retention.years must be a positive number when specified."
  }
}

variable "token" {
  description = "This argument is deprecated and no longer needed to enable Object Lock."
  type        = string
  default     = null
}