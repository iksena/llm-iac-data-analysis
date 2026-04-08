variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "ID (name) of the bucket."
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_server_side_encryption_configuration, bucket must not be empty."
  }
}

variable "expected_bucket_owner" {
  description = "Account ID of the expected bucket owner."
  type        = string
  default     = null

  validation {
    condition     = var.expected_bucket_owner == null || can(regex("^[0-9]{12}$", var.expected_bucket_owner))
    error_message = "resource_aws_s3_bucket_server_side_encryption_configuration, expected_bucket_owner must be a 12-digit AWS account ID."
  }
}

variable "rule" {
  description = "Set of server-side encryption configuration rules. Currently, only a single rule is supported."
  type = list(object({
    bucket_key_enabled = optional(bool)
    apply_server_side_encryption_by_default = optional(object({
      sse_algorithm     = string
      kms_master_key_id = optional(string)
    }))
  }))

  validation {
    condition     = length(var.rule) > 0
    error_message = "resource_aws_s3_bucket_server_side_encryption_configuration, rule must contain at least one rule."
  }

  validation {
    condition     = length(var.rule) == 1
    error_message = "resource_aws_s3_bucket_server_side_encryption_configuration, rule currently only supports a single rule."
  }

  validation {
    condition = alltrue([
      for rule in var.rule : rule.apply_server_side_encryption_by_default == null || contains(["AES256", "aws:kms", "aws:kms:dsse"], rule.apply_server_side_encryption_by_default.sse_algorithm)
    ])
    error_message = "resource_aws_s3_bucket_server_side_encryption_configuration, rule.apply_server_side_encryption_by_default.sse_algorithm must be one of: AES256, aws:kms, aws:kms:dsse."
  }

  validation {
    condition = alltrue([
      for rule in var.rule : rule.apply_server_side_encryption_by_default == null || (
        rule.apply_server_side_encryption_by_default.sse_algorithm != "aws:kms" && rule.apply_server_side_encryption_by_default.sse_algorithm != "aws:kms:dsse"
      ) || rule.apply_server_side_encryption_by_default.kms_master_key_id != null || rule.apply_server_side_encryption_by_default.kms_master_key_id == null
    ])
    error_message = "resource_aws_s3_bucket_server_side_encryption_configuration, rule.apply_server_side_encryption_by_default.kms_master_key_id can only be used when sse_algorithm is aws:kms or aws:kms:dsse."
  }
}