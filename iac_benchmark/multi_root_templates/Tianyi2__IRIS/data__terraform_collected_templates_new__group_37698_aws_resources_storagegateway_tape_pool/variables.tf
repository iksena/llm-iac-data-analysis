variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "pool_name" {
  description = "The name of the new custom tape pool."
  type        = string

  validation {
    condition     = length(var.pool_name) > 0
    error_message = "resource_aws_storagegateway_tape_pool, pool_name must not be empty."
  }
}

variable "storage_class" {
  description = "The storage class that is associated with the new custom pool. When you use your backup application to eject the tape, the tape is archived directly into the storage class that corresponds to the pool. Possible values are DEEP_ARCHIVE or GLACIER."
  type        = string

  validation {
    condition     = contains(["DEEP_ARCHIVE", "GLACIER"], var.storage_class)
    error_message = "resource_aws_storagegateway_tape_pool, storage_class must be either DEEP_ARCHIVE or GLACIER."
  }
}

variable "retention_lock_type" {
  description = "Tape retention lock can be configured in two modes. When configured in governance mode, AWS accounts with specific IAM permissions are authorized to remove the tape retention lock from archived virtual tapes. When configured in compliance mode, the tape retention lock cannot be removed by any user, including the root AWS account. Possible values are COMPLIANCE, GOVERNANCE, and NONE. Default value is NONE."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["COMPLIANCE", "GOVERNANCE", "NONE"], var.retention_lock_type)
    error_message = "resource_aws_storagegateway_tape_pool, retention_lock_type must be one of COMPLIANCE, GOVERNANCE, or NONE."
  }
}

variable "retention_lock_time_in_days" {
  description = "Tape retention lock time is set in days. Tape retention lock can be enabled for up to 100 years (36,500 days). Default value is 0."
  type        = number
  default     = 0

  validation {
    condition     = var.retention_lock_time_in_days >= 0 && var.retention_lock_time_in_days <= 36500
    error_message = "resource_aws_storagegateway_tape_pool, retention_lock_time_in_days must be between 0 and 36500 days."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}