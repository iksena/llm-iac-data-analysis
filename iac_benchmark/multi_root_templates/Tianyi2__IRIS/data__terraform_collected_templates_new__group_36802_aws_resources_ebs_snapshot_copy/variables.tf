variable "source_snapshot_id" {
  description = "The ARN for the snapshot to be copied."
  type        = string
}

variable "source_region" {
  description = "The region of the source snapshot."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "A description of what the snapshot is."
  type        = string
  default     = null
}

variable "encrypted" {
  description = "Whether the snapshot is encrypted."
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = null
}

variable "storage_tier" {
  description = "The name of the storage tier. Valid values are archive and standard."
  type        = string
  default     = "standard"

  validation {
    condition     = var.storage_tier == null || contains(["archive", "standard"], var.storage_tier)
    error_message = "resource_aws_ebs_snapshot_copy, storage_tier must be either 'archive' or 'standard'."
  }
}

variable "permanent_restore" {
  description = "Indicates whether to permanently restore an archived snapshot."
  type        = bool
  default     = null
}

variable "temporary_restore_days" {
  description = "Specifies the number of days for which to temporarily restore an archived snapshot. Required for temporary restores only. The snapshot will be automatically re-archived after this period."
  type        = number
  default     = null
}

variable "completion_duration_minutes" {
  description = "Specifies a completion duration to initiate a time-based snapshot copy. Time-based snapshot copy operations complete within the specified duration. Value must be between 15 and 2880 minutes, in 15 minute increments only."
  type        = number
  default     = null

  validation {
    condition = var.completion_duration_minutes == null || (
      var.completion_duration_minutes >= 15 &&
      var.completion_duration_minutes <= 2880 &&
      var.completion_duration_minutes % 15 == 0
    )
    error_message = "resource_aws_ebs_snapshot_copy, completion_duration_minutes must be between 15 and 2880 minutes, in 15 minute increments only."
  }
}

variable "tags" {
  description = "A map of tags for the snapshot. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null
}