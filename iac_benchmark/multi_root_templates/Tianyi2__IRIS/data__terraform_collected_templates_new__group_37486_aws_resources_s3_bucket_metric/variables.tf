variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket to put metric configuration."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_metric, bucket must be a non-empty string."
  }
}

variable "name" {
  description = "Unique identifier of the metrics configuration for the bucket. Must be less than or equal to 64 characters in length."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_s3_bucket_metric, name must be between 1 and 64 characters in length."
  }
}

variable "filter" {
  description = "Object filtering that accepts a prefix, tags, or a logical AND of prefix and tags."
  type = object({
    access_point = optional(string)
    prefix       = optional(string)
    tags         = optional(map(string))
  })
  default = null

  validation {
    condition = var.filter == null || (
      var.filter.access_point != null ||
      var.filter.prefix != null ||
      var.filter.tags != null
    )
    error_message = "resource_aws_s3_bucket_metric, filter requires at least one of access_point, prefix, or tags when specified."
  }

  validation {
    condition     = var.filter == null || var.filter.tags == null || length(var.filter.tags) <= 10
    error_message = "resource_aws_s3_bucket_metric, filter tags can have up to 10 key-value pairs."
  }
}