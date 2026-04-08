variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable. Do not set this value to true indiscriminately."
  type        = bool
  default     = false

  validation {
    condition     = can(tobool(var.bypass_policy_lockout_safety_check))
    error_message = "resource_aws_kms_replica_key, bypass_policy_lockout_safety_check must be a boolean value."
  }
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive. If you do not specify a value, it defaults to 30."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "resource_aws_kms_replica_key, deletion_window_in_days must be between 7 and 30, inclusive."
  }
}

variable "description" {
  description = "A description of the KMS key."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Specifies whether the replica key is enabled. Disabled KMS keys cannot be used in cryptographic operations. The default value is true."
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.enabled))
    error_message = "resource_aws_kms_replica_key, enabled must be a boolean value."
  }
}

variable "policy" {
  description = "The key policy to attach to the KMS key. If you do not specify a key policy, AWS KMS attaches the default key policy to the KMS key."
  type        = string
  default     = null
}

variable "primary_key_arn" {
  description = "The ARN of the multi-Region primary key to replicate. The primary key must be in a different AWS Region of the same AWS Partition. You can create only one replica of a given primary key in each AWS Region."
  type        = string

  validation {
    condition     = length(var.primary_key_arn) > 0
    error_message = "resource_aws_kms_replica_key, primary_key_arn is required and cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws[a-z0-9-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.primary_key_arn))
    error_message = "resource_aws_kms_replica_key, primary_key_arn must be a valid KMS key ARN format."
  }
}

variable "tags" {
  description = "A map of tags to assign to the replica key. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = can(keys(var.tags))
    error_message = "resource_aws_kms_replica_key, tags must be a map of strings."
  }
}