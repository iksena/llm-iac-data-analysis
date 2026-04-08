variable "bucket" {
  description = "Bucket name"
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "data_aws_s3_bucket_policy, bucket must not be empty."
  }

  validation {
    condition     = length(var.bucket) >= 3 && length(var.bucket) <= 63
    error_message = "data_aws_s3_bucket_policy, bucket name must be between 3 and 63 characters long."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket))
    error_message = "data_aws_s3_bucket_policy, bucket name must contain only lowercase letters, numbers, hyphens, and periods, and must start and end with a letter or number."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_s3_bucket_policy, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}