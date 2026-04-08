variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Amazon Resource Name (ARN) of the bucket."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3-outposts:", var.bucket))
    error_message = "resource_aws_s3control_bucket_lifecycle_configuration, bucket must be a valid S3 Outposts bucket ARN starting with 'arn:aws:s3-outposts:'."
  }
}

variable "rule" {
  description = "Configuration block(s) containing lifecycle rules for the bucket."
  type = list(object({
    id     = string
    status = optional(string, "Enabled")
    abort_incomplete_multipart_upload = optional(object({
      days_after_initiation = number
    }))
    expiration = optional(object({
      date                         = optional(string)
      days                         = optional(number)
      expired_object_delete_marker = optional(bool)
    }))
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
  }))

  validation {
    condition = alltrue([
      for r in var.rule : r.status == null || contains(["Enabled", "Disabled"], r.status)
    ])
    error_message = "resource_aws_s3control_bucket_lifecycle_configuration, rule.status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.expiration == null || (
        r.expiration.expired_object_delete_marker == null ||
        (r.expiration.date == null && r.expiration.days == null)
      )
    ])
    error_message = "resource_aws_s3control_bucket_lifecycle_configuration, rule.expiration.expired_object_delete_marker cannot be specified with date or days."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.expiration == null || r.expiration.date == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", r.expiration.date))
    ])
    error_message = "resource_aws_s3control_bucket_lifecycle_configuration, rule.expiration.date must be in YYYY-MM-DD format."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.abort_incomplete_multipart_upload == null || r.abort_incomplete_multipart_upload.days_after_initiation > 0
    ])
    error_message = "resource_aws_s3control_bucket_lifecycle_configuration, rule.abort_incomplete_multipart_upload.days_after_initiation must be greater than 0."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.expiration == null || r.expiration.days == null || r.expiration.days > 0
    ])
    error_message = "resource_aws_s3control_bucket_lifecycle_configuration, rule.expiration.days must be greater than 0."
  }
}