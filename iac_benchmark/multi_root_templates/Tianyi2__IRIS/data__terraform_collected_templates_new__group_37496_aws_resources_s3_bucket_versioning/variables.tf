variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the S3 bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket)) && length(var.bucket) >= 3 && length(var.bucket) <= 63
    error_message = "resource_aws_s3_bucket_versioning, bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens only)."
  }
}

variable "versioning_configuration" {
  description = "Configuration block for the versioning parameters."
  type = object({
    status     = string
    mfa_delete = optional(string)
  })

  validation {
    condition     = contains(["Enabled", "Suspended", "Disabled"], var.versioning_configuration.status)
    error_message = "resource_aws_s3_bucket_versioning, versioning_configuration.status must be one of: Enabled, Suspended, or Disabled."
  }

  validation {
    condition     = var.versioning_configuration.mfa_delete == null || contains(["Enabled", "Disabled"], var.versioning_configuration.mfa_delete)
    error_message = "resource_aws_s3_bucket_versioning, versioning_configuration.mfa_delete must be either Enabled or Disabled."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_versioning, expected_bucket_owner must be a valid 12-digit AWS account ID."
  }
}

variable "mfa" {
  description = "Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. Required if versioning_configuration mfa_delete is enabled."
  type        = string
  default     = null

  validation {
    condition     = var.mfa == null || can(regex("^arn:aws:iam::[0-9]{12}:mfa/.+ [0-9]{6}$", var.mfa))
    error_message = "resource_aws_s3_bucket_versioning, mfa must be in the format 'arn:aws:iam::account-id:mfa/device-name token-code'."
  }
}