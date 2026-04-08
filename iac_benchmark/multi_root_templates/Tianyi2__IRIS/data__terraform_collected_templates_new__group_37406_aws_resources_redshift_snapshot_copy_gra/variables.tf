variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_redshift_snapshot_copy_grant, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "snapshot_copy_grant_name" {
  description = "A friendly name for identifying the grant. Forces new resource."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,254}$", var.snapshot_copy_grant_name))
    error_message = "resource_aws_redshift_snapshot_copy_grant, snapshot_copy_grant_name must be 1-255 characters, start with a letter, and contain only letters, numbers, and hyphens."
  }
}

variable "kms_key_id" {
  description = "The unique identifier for the customer master key (CMK) that the grant applies to. Specify the key ID or the Amazon Resource Name (ARN) of the CMK. Forces new resource."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^(arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]{36}|[a-f0-9-]{36}|alias/.+)$", var.kms_key_id))
    error_message = "resource_aws_redshift_snapshot_copy_grant, kms_key_id must be a valid KMS key ID, ARN, or alias format, or null."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_redshift_snapshot_copy_grant, tags cannot exceed 50 key-value pairs."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 128 && length(v) <= 256
    ])
    error_message = "resource_aws_redshift_snapshot_copy_grant, tags keys cannot exceed 128 characters and values cannot exceed 256 characters."
  }
}