variable "name" {
  description = "The name of the Volume. You can use a maximum of 203 alphanumeric characters, plus the underscore (_) special character."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{1,203}$", var.name))
    error_message = "resource_aws_fsx_ontap_volume, name must be 1-203 alphanumeric characters or underscores."
  }
}

variable "storage_virtual_machine_id" {
  description = "Specifies the storage virtual machine in which to create the volume."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "aggregate_configuration" {
  description = "The Aggregate configuration only applies to FLEXGROUP volumes."
  type = object({
    aggregates                 = optional(list(string))
    constituents_per_aggregate = optional(number, 8)
  })
  default = null

  validation {
    condition = var.aggregate_configuration == null || (
      var.aggregate_configuration != null && (
        var.aggregate_configuration.aggregates == null ||
        alltrue([for agg in var.aggregate_configuration.aggregates : can(regex("^aggr\\d+$", agg))])
      )
    )
    error_message = "resource_aws_fsx_ontap_volume, aggregate_configuration.aggregates must be in format 'aggrX' where X is a number."
  }
}

variable "bypass_snaplock_enterprise_retention" {
  description = "Setting this to true allows a SnapLock administrator to delete an FSx for ONTAP SnapLock Enterprise volume with unexpired write once, read many (WORM) files."
  type        = bool
  default     = false
}

variable "copy_tags_to_backups" {
  description = "A boolean flag indicating whether tags for the volume should be copied to backups."
  type        = bool
  default     = false
}

variable "final_backup_tags" {
  description = "A map of tags to apply to the volume's final backup."
  type        = map(string)
  default     = null
}

variable "junction_path" {
  description = "Specifies the location in the storage virtual machine's namespace where the volume is mounted. The junction_path must have a leading forward slash, such as /vol3"
  type        = string
  default     = null

  validation {
    condition     = var.junction_path == null || can(regex("^/", var.junction_path))
    error_message = "resource_aws_fsx_ontap_volume, junction_path must have a leading forward slash."
  }
}

variable "ontap_volume_type" {
  description = "Specifies the type of volume, valid values are RW, DP. Default value is RW."
  type        = string
  default     = "RW"

  validation {
    condition     = contains(["RW", "DP"], var.ontap_volume_type)
    error_message = "resource_aws_fsx_ontap_volume, ontap_volume_type must be one of: RW, DP."
  }
}

variable "security_style" {
  description = "Specifies the volume security style, Valid values are UNIX, NTFS, and MIXED."
  type        = string
  default     = null

  validation {
    condition     = var.security_style == null || contains(["UNIX", "NTFS", "MIXED"], var.security_style)
    error_message = "resource_aws_fsx_ontap_volume, security_style must be one of: UNIX, NTFS, MIXED."
  }
}

variable "size_in_bytes" {
  description = "Specifies the size of the volume, in bytes, that you are creating. Can be used for any size but required for volumes over 2 PB."
  type        = number
  default     = null

  validation {
    condition     = var.size_in_bytes == null || var.size_in_bytes > 0
    error_message = "resource_aws_fsx_ontap_volume, size_in_bytes must be greater than 0."
  }
}

variable "size_in_megabytes" {
  description = "Specifies the size of the volume, in megabytes (MB), that you are creating. Supported when creating volumes under 2 PB."
  type        = number
  default     = null

  validation {
    condition     = var.size_in_megabytes == null || var.size_in_megabytes > 0
    error_message = "resource_aws_fsx_ontap_volume, size_in_megabytes must be greater than 0."
  }
}

variable "skip_final_backup" {
  description = "When enabled, will skip the default final backup taken when the volume is deleted."
  type        = bool
  default     = false
}

variable "snaplock_configuration" {
  description = "The SnapLock configuration for an FSx for ONTAP volume."
  type = object({
    snaplock_type              = string
    audit_log_volume           = optional(bool, false)
    privileged_delete          = optional(string, "DISABLED")
    volume_append_mode_enabled = optional(bool, false)
    autocommit_period = optional(object({
      type  = string
      value = optional(number)
    }))
    retention_period = optional(object({
      default_retention = object({
        type  = string
        value = optional(number)
      })
      maximum_retention = object({
        type  = string
        value = optional(number)
      })
      minimum_retention = object({
        type  = string
        value = optional(number)
      })
    }))
  })
  default = null

  validation {
    condition     = var.snaplock_configuration == null || contains(["COMPLIANCE", "ENTERPRISE"], var.snaplock_configuration.snaplock_type)
    error_message = "resource_aws_fsx_ontap_volume, snaplock_configuration.snaplock_type must be one of: COMPLIANCE, ENTERPRISE."
  }

  validation {
    condition = var.snaplock_configuration == null || (
      var.snaplock_configuration.privileged_delete == null ||
      contains(["DISABLED", "ENABLED", "PERMANENTLY_DISABLED"], var.snaplock_configuration.privileged_delete)
    )
    error_message = "resource_aws_fsx_ontap_volume, snaplock_configuration.privileged_delete must be one of: DISABLED, ENABLED, PERMANENTLY_DISABLED."
  }

  validation {
    condition = var.snaplock_configuration == null || (
      var.snaplock_configuration.autocommit_period == null ||
      contains(["MINUTES", "HOURS", "DAYS", "MONTHS", "YEARS", "NONE"], var.snaplock_configuration.autocommit_period.type)
    )
    error_message = "resource_aws_fsx_ontap_volume, snaplock_configuration.autocommit_period.type must be one of: MINUTES, HOURS, DAYS, MONTHS, YEARS, NONE."
  }

  validation {
    condition = var.snaplock_configuration == null || (
      var.snaplock_configuration.retention_period == null ||
      contains(["SECONDS", "MINUTES", "HOURS", "DAYS", "MONTHS", "YEARS", "INFINITE", "UNSPECIFIED"], var.snaplock_configuration.retention_period.default_retention.type)
    )
    error_message = "resource_aws_fsx_ontap_volume, snaplock_configuration.retention_period.default_retention.type must be one of: SECONDS, MINUTES, HOURS, DAYS, MONTHS, YEARS, INFINITE, UNSPECIFIED."
  }

  validation {
    condition = var.snaplock_configuration == null || (
      var.snaplock_configuration.retention_period == null ||
      contains(["SECONDS", "MINUTES", "HOURS", "DAYS", "MONTHS", "YEARS", "INFINITE", "UNSPECIFIED"], var.snaplock_configuration.retention_period.maximum_retention.type)
    )
    error_message = "resource_aws_fsx_ontap_volume, snaplock_configuration.retention_period.maximum_retention.type must be one of: SECONDS, MINUTES, HOURS, DAYS, MONTHS, YEARS, INFINITE, UNSPECIFIED."
  }

  validation {
    condition = var.snaplock_configuration == null || (
      var.snaplock_configuration.retention_period == null ||
      contains(["SECONDS", "MINUTES", "HOURS", "DAYS", "MONTHS", "YEARS", "INFINITE", "UNSPECIFIED"], var.snaplock_configuration.retention_period.minimum_retention.type)
    )
    error_message = "resource_aws_fsx_ontap_volume, snaplock_configuration.retention_period.minimum_retention.type must be one of: SECONDS, MINUTES, HOURS, DAYS, MONTHS, YEARS, INFINITE, UNSPECIFIED."
  }
}

variable "snapshot_policy" {
  description = "Specifies the snapshot policy for the volume."
  type        = string
  default     = null
}

variable "storage_efficiency_enabled" {
  description = "Set to true to enable deduplication, compression, and compaction storage efficiency features on the volume."
  type        = bool
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the volume."
  type        = map(string)
  default     = {}
}

variable "tiering_policy" {
  description = "The data tiering policy for an FSx for ONTAP volume."
  type = object({
    name           = string
    cooling_period = optional(number)
  })
  default = null

  validation {
    condition     = var.tiering_policy == null || contains(["SNAPSHOT_ONLY", "AUTO", "ALL", "NONE"], var.tiering_policy.name)
    error_message = "resource_aws_fsx_ontap_volume, tiering_policy.name must be one of: SNAPSHOT_ONLY, AUTO, ALL, NONE."
  }

  validation {
    condition = var.tiering_policy == null || (
      var.tiering_policy.cooling_period == null ||
      (var.tiering_policy.cooling_period >= 2 && var.tiering_policy.cooling_period <= 183)
    )
    error_message = "resource_aws_fsx_ontap_volume, tiering_policy.cooling_period must be between 2 and 183 days."
  }
}

variable "volume_style" {
  description = "Specifies the styles of volume, valid values are FLEXVOL, FLEXGROUP. Default value is FLEXVOL."
  type        = string
  default     = "FLEXVOL"

  validation {
    condition     = contains(["FLEXVOL", "FLEXGROUP"], var.volume_style)
    error_message = "resource_aws_fsx_ontap_volume, volume_style must be one of: FLEXVOL, FLEXGROUP."
  }
}