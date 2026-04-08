variable "bucket" {
  description = "Name of the bucket"
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_accelerate_configuration, bucket must not be empty."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner"
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_accelerate_configuration, expected_bucket_owner must be a valid 12-digit AWS account ID."
  }
}

variable "status" {
  description = "Transfer acceleration state of the bucket"
  type        = string

  validation {
    condition     = contains(["Enabled", "Suspended"], var.status)
    error_message = "resource_aws_s3_bucket_accelerate_configuration, status must be either 'Enabled' or 'Suspended'."
  }
}