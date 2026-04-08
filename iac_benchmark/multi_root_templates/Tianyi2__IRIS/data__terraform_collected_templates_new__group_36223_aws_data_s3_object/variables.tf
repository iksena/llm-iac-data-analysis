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
    error_message = "data_aws_s3_object, bucket cannot be empty."
  }
}

variable "checksum_mode" {
  description = "To retrieve the object's checksum, this argument must be ENABLED. If you enable checksum_mode and the object is encrypted with KMS, you must have permission to use the kms:Decrypt action."
  type        = string
  default     = null

  validation {
    condition     = var.checksum_mode == null || var.checksum_mode == "ENABLED"
    error_message = "data_aws_s3_object, checksum_mode must be ENABLED when specified."
  }
}

variable "key" {
  description = "Full path to the object inside the bucket"
  type        = string

  validation {
    condition     = length(var.key) > 0
    error_message = "data_aws_s3_object, key cannot be empty."
  }
}

variable "version_id" {
  description = "Specific version ID of the object returned (defaults to latest version)"
  type        = string
  default     = null
}