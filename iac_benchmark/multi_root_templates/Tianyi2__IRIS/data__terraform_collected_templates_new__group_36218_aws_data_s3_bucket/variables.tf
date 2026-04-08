variable "bucket" {
  description = "Name of the bucket"
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "data_aws_s3_bucket, bucket must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}