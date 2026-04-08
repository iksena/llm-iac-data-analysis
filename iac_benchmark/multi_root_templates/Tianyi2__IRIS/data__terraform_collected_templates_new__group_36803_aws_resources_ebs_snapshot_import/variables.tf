variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "client_data" {
  description = "The client-specific data"
  type = object({
    comment      = optional(string)
    upload_start = optional(string)
    upload_end   = optional(string)
    upload_size  = optional(number)
  })
  default = null
}

variable "description" {
  description = "The description string for the import snapshot task"
  type        = string
  default     = null
}

variable "disk_container" {
  description = "Information about the disk container"
  type = object({
    description = optional(string)
    format      = string
    url         = optional(string)
    user_bucket = optional(object({
      s3_bucket = string
      s3_key    = string
    }))
  })

  validation {
    condition     = contains(["VHD", "VMDK"], var.disk_container.format)
    error_message = "resource_aws_ebs_snapshot_import, disk_container.format must be one of 'VHD' or 'VMDK'."
  }

  validation {
    condition     = (var.disk_container.url != null && var.disk_container.user_bucket == null) || (var.disk_container.url == null && var.disk_container.user_bucket != null)
    error_message = "resource_aws_ebs_snapshot_import, disk_container must have either 'url' or 'user_bucket' set, but not both."
  }
}

variable "encrypted" {
  description = "Specifies whether the destination snapshot of the imported image should be encrypted"
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "An identifier for the symmetric KMS key to use when creating the encrypted snapshot"
  type        = string
  default     = null
}

variable "storage_tier" {
  description = "The name of the storage tier"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["archive", "standard"], var.storage_tier)
    error_message = "resource_aws_ebs_snapshot_import, storage_tier must be one of 'archive' or 'standard'."
  }
}

variable "permanent_restore" {
  description = "Indicates whether to permanently restore an archived snapshot"
  type        = bool
  default     = null
}

variable "temporary_restore_days" {
  description = "Specifies the number of days for which to temporarily restore an archived snapshot"
  type        = number
  default     = null

  validation {
    condition     = var.temporary_restore_days == null || var.temporary_restore_days > 0
    error_message = "resource_aws_ebs_snapshot_import, temporary_restore_days must be greater than 0."
  }
}

variable "role_name" {
  description = "The name of the IAM Role the VM Import/Export service will assume"
  type        = string
  default     = "vmimport"
}

variable "tags" {
  description = "A map of tags to assign to the snapshot"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeouts for the resource operations"
  type = object({
    create = optional(string, "60m")
    delete = optional(string, "10m")
  })
  default = null
}