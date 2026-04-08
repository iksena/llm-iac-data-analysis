variable "name" {
  description = "Name of the security configuration"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "cloudwatch_encryption_mode" {
  description = "Encryption mode to use for CloudWatch data. Valid values: DISABLED, SSE-KMS"
  type        = string
  default     = "DISABLED"

  validation {
    condition     = contains(["DISABLED", "SSE-KMS"], var.cloudwatch_encryption_mode)
    error_message = "resource_aws_glue_security_configuration, cloudwatch_encryption_mode must be one of: DISABLED, SSE-KMS."
  }
}

variable "cloudwatch_kms_key_arn" {
  description = "Amazon Resource Name (ARN) of the KMS key to be used to encrypt the CloudWatch data"
  type        = string
  default     = null
}

variable "job_bookmarks_encryption_mode" {
  description = "Encryption mode to use for job bookmarks data. Valid values: CSE-KMS, DISABLED"
  type        = string
  default     = "DISABLED"

  validation {
    condition     = contains(["CSE-KMS", "DISABLED"], var.job_bookmarks_encryption_mode)
    error_message = "resource_aws_glue_security_configuration, job_bookmarks_encryption_mode must be one of: CSE-KMS, DISABLED."
  }
}

variable "job_bookmarks_kms_key_arn" {
  description = "Amazon Resource Name (ARN) of the KMS key to be used to encrypt the job bookmarks data"
  type        = string
  default     = null
}

variable "s3_encryption_mode" {
  description = "Encryption mode to use for S3 data. Valid values: DISABLED, SSE-KMS, SSE-S3"
  type        = string
  default     = "DISABLED"

  validation {
    condition     = contains(["DISABLED", "SSE-KMS", "SSE-S3"], var.s3_encryption_mode)
    error_message = "resource_aws_glue_security_configuration, s3_encryption_mode must be one of: DISABLED, SSE-KMS, SSE-S3."
  }
}

variable "s3_kms_key_arn" {
  description = "Amazon Resource Name (ARN) of the KMS key to be used to encrypt the S3 data"
  type        = string
  default     = null
}