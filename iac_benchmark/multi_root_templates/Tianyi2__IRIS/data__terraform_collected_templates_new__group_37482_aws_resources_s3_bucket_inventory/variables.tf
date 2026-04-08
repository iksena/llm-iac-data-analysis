variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the source bucket that inventory lists the objects for."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_inventory, bucket must not be empty."
  }
}

variable "name" {
  description = "Unique identifier of the inventory configuration for the bucket."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_s3_bucket_inventory, name must not be empty."
  }
}

variable "included_object_versions" {
  description = "Object versions to include in the inventory list. Valid values: All, Current."
  type        = string

  validation {
    condition     = contains(["All", "Current"], var.included_object_versions)
    error_message = "resource_aws_s3_bucket_inventory, included_object_versions must be one of: All, Current."
  }
}

variable "schedule" {
  description = "Specifies the schedule for generating inventory results."
  type = object({
    frequency = string
  })

  validation {
    condition     = contains(["Daily", "Weekly"], var.schedule.frequency)
    error_message = "resource_aws_s3_bucket_inventory, schedule.frequency must be one of: Daily, Weekly."
  }
}

variable "destination" {
  description = "Contains information about where to publish the inventory results."
  type = object({
    bucket = object({
      bucket_arn = string
      format     = string
      account_id = optional(string)
      prefix     = optional(string)
      encryption = optional(object({
        sse_kms = optional(object({
          key_id = string
        }))
        sse_s3 = optional(object({}))
      }))
    })
  })

  validation {
    condition     = length(var.destination.bucket.bucket_arn) > 0
    error_message = "resource_aws_s3_bucket_inventory, destination.bucket.bucket_arn must not be empty."
  }

  validation {
    condition     = contains(["CSV", "ORC", "Parquet"], var.destination.bucket.format)
    error_message = "resource_aws_s3_bucket_inventory, destination.bucket.format must be one of: CSV, ORC, Parquet."
  }

  validation {
    condition = var.destination.bucket.encryption == null || (
      (var.destination.bucket.encryption.sse_kms == null) != (var.destination.bucket.encryption.sse_s3 == null)
    )
    error_message = "resource_aws_s3_bucket_inventory, destination.bucket.encryption must specify either sse_kms or sse_s3, not both."
  }

  validation {
    condition = var.destination.bucket.encryption == null || var.destination.bucket.encryption.sse_kms == null || (
      var.destination.bucket.encryption.sse_kms != null && length(var.destination.bucket.encryption.sse_kms.key_id) > 0
    )
    error_message = "resource_aws_s3_bucket_inventory, destination.bucket.encryption.sse_kms.key_id must not be empty when sse_kms is specified."
  }
}

variable "enabled" {
  description = "Specifies whether the inventory is enabled or disabled."
  type        = bool
  default     = true
}

variable "filter" {
  description = "Specifies an inventory filter. The inventory only includes objects that meet the filter's criteria."
  type = object({
    prefix = optional(string)
  })
  default = null
}

variable "optional_fields" {
  description = "List of optional fields that are included in the inventory results."
  type        = list(string)
  default     = null
}