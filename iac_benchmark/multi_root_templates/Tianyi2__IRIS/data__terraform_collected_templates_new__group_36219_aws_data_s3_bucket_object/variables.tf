variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket to read the object from. Alternatively, an S3 access point ARN can be specified"
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "data_aws_s3_bucket_object, bucket must be a non-empty string."
  }
}

variable "key" {
  description = "Full path to the object inside the bucket"
  type        = string

  validation {
    condition     = length(var.key) > 0
    error_message = "data_aws_s3_bucket_object, key must be a non-empty string."
  }
}

variable "version_id" {
  description = "Specific version ID of the object returned (defaults to latest version)"
  type        = string
  default     = null
}