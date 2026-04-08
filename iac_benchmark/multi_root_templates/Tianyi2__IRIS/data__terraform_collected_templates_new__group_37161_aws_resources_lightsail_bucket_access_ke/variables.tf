variable "bucket_name" {
  description = "Name of the bucket that the access key will belong to and grant access to."
  type        = string

  validation {
    condition     = length(var.bucket_name) > 0
    error_message = "resource_aws_lightsail_bucket_access_key, bucket_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_lightsail_bucket_access_key, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}