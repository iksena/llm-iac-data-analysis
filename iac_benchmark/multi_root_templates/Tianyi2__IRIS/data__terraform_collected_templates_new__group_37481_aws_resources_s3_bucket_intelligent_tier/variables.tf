variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket this intelligent tiering configuration is associated with."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket))
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, bucket must contain only lowercase letters, numbers, periods, and hyphens."
  }
}

variable "name" {
  description = "Unique name used to identify the S3 Intelligent-Tiering configuration for the bucket."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 1024
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, name must be between 1 and 1024 characters."
  }
}

variable "status" {
  description = "Specifies the status of the configuration. Valid values: Enabled, Disabled."
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.status)
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, status must be either 'Enabled' or 'Disabled'."
  }
}

variable "filter" {
  description = "Bucket filter. The configuration only includes objects that meet the filter's criteria."
  type = object({
    prefix = optional(string)
    tags   = optional(map(string))
  })
  default = null

  validation {
    condition = var.filter == null || (
      var.filter.prefix == null || can(regex("^[^\\x00-\\x1F\\x7F]*$", var.filter.prefix))
    )
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, filter prefix must not contain control characters."
  }
}

variable "tiering" {
  description = "S3 Intelligent-Tiering storage class tiers of the configuration."
  type = list(object({
    access_tier = string
    days        = number
  }))

  validation {
    condition     = length(var.tiering) > 0
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, tiering must contain at least one tiering configuration."
  }

  validation {
    condition = alltrue([
      for tier in var.tiering :
      contains(["ARCHIVE_ACCESS", "DEEP_ARCHIVE_ACCESS"], tier.access_tier)
    ])
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, tiering access_tier must be either 'ARCHIVE_ACCESS' or 'DEEP_ARCHIVE_ACCESS'."
  }

  validation {
    condition = alltrue([
      for tier in var.tiering :
      tier.days >= 1 && tier.days <= 2147483647
    ])
    error_message = "resource_aws_s3_bucket_intelligent_tiering_configuration, tiering days must be between 1 and 2147483647."
  }
}