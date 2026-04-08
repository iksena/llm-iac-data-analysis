variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket))
    error_message = "resource_aws_s3_bucket_request_payment_configuration, bucket must be a valid S3 bucket name containing only lowercase letters, numbers, dots, and hyphens."
  }

  validation {
    condition     = length(var.bucket) >= 3 && length(var.bucket) <= 63
    error_message = "resource_aws_s3_bucket_request_payment_configuration, bucket name must be between 3 and 63 characters long."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_request_payment_configuration, expected_bucket_owner must be a valid 12-digit AWS account ID."
  }
}

variable "payer" {
  description = "Specifies who pays for the download and request fees. Valid values: BucketOwner, Requester."
  type        = string

  validation {
    condition     = contains(["BucketOwner", "Requester"], var.payer)
    error_message = "resource_aws_s3_bucket_request_payment_configuration, payer must be either 'BucketOwner' or 'Requester'."
  }
}