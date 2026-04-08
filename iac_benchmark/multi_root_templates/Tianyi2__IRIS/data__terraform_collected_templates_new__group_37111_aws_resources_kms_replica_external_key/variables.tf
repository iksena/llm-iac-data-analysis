variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the key policy lockout safety check. Setting this value to true increases the risk that the KMS key becomes unmanageable."
  type        = bool
  default     = false
}

variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days == null || (var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30)
    error_message = "resource_aws_kms_replica_external_key, deletion_window_in_days must be between 7 and 30, inclusive."
  }
}

variable "description" {
  description = "A description of the KMS key."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Specifies whether the replica key is enabled. Disabled KMS keys cannot be used in cryptographic operations. Keys pending import can only be false. Imported keys default to true unless expired."
  type        = bool
  default     = null
}

variable "key_material_base64" {
  description = "Base64 encoded 256-bit symmetric encryption key material to import. The KMS key is permanently associated with this key material."
  type        = string
  default     = null
  sensitive   = true
}

variable "policy" {
  description = "The key policy to attach to the KMS key. If you do not specify a key policy, AWS KMS attaches the default key policy to the KMS key."
  type        = string
  default     = null
}

variable "primary_key_arn" {
  description = "The ARN of the multi-Region primary key to replicate. The primary key must be in a different AWS Region of the same AWS Partition."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.primary_key_arn))
    error_message = "resource_aws_kms_replica_external_key, primary_key_arn must be a valid KMS key ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the replica key."
  type        = map(string)
  default     = {}
}

variable "valid_to" {
  description = "Time at which the imported key material expires. When the key material expires, AWS KMS deletes the key material and the key becomes unusable. Valid values: RFC3339 time string (YYYY-MM-DDTHH:MM:SSZ)."
  type        = string
  default     = null

  validation {
    condition     = var.valid_to == null || can(regex("^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$", var.valid_to))
    error_message = "resource_aws_kms_replica_external_key, valid_to must be a valid RFC3339 time string in format YYYY-MM-DDTHH:MM:SSZ."
  }
}