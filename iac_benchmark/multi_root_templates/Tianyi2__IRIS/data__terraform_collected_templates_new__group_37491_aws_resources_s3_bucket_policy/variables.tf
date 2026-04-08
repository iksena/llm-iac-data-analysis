variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket to which to apply the policy."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_policy, bucket cannot be empty."
  }
}

variable "policy" {
  description = "Text of the policy. Bucket policies are limited to 20 KB in size."
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_s3_bucket_policy, policy cannot be empty."
  }

  validation {
    condition     = length(var.policy) <= 20480
    error_message = "resource_aws_s3_bucket_policy, policy cannot exceed 20 KB (20480 characters) in size."
  }
}