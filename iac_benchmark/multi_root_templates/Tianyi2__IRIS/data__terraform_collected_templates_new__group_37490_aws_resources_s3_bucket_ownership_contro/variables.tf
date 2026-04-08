variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "bucket" {
  type        = string
  description = "Name of the bucket that you want to associate this access point with."

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_ownership_controls, bucket must not be empty."
  }
}

variable "object_ownership" {
  type        = string
  description = "Object ownership. Valid values: BucketOwnerPreferred, ObjectWriter or BucketOwnerEnforced"

  validation {
    condition = contains([
      "BucketOwnerPreferred",
      "ObjectWriter",
      "BucketOwnerEnforced"
    ], var.object_ownership)
    error_message = "resource_aws_s3_bucket_ownership_controls, object_ownership must be one of: BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced."
  }
}