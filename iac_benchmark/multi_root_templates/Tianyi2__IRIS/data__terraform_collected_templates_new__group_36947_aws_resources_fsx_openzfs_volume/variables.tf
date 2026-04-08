variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Volume. You can use a maximum of 203 alphanumeric characters, plus the underscore (_) special character."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_]{1,203}$", var.name))
    error_message = "resource_aws_fsx_openzfs_volume, name must be 1-203 characters long and contain only alphanumeric characters and underscores."
  }
}

variable "parent_volume_id" {
  description = "The volume id of volume that will be the parent volume for the volume being created, this could be the root volume created from the aws_fsx_openzfs_file_system resource with the root_volume_id or the id property of another aws_fsx_openzfs_volume."
  type        = string
}

variable "copy_tags_to_snapshots" {
  description = "A boolean flag indicating whether tags for the file system should be copied to snapshots. The default value is false."
  type        = bool
  default     = false
}

variable "data_compression_type" {
  description = "Method used to compress the data on the volume. Valid values are NONE or ZSTD. Child volumes that don't specify compression option will inherit from parent volume."
  type        = string
  default     = null

  validation {
    condition     = var.data_compression_type == null || contains(["NONE", "ZSTD"], var.data_compression_type)
    error_message = "resource_aws_fsx_openzfs_volume, data_compression_type must be either 'NONE' or 'ZSTD'."
  }
}

variable "delete_volume_options" {
  description = "Whether to delete all child volumes and snapshots. Valid values: DELETE_CHILD_VOLUMES_AND_SNAPSHOTS. This configuration must be applied separately before attempting to delete the resource to have the desired behavior."
  type        = string
  default     = null

  validation {
    condition     = var.delete_volume_options == null || var.delete_volume_options == "DELETE_CHILD_VOLUMES_AND_SNAPSHOTS"
    error_message = "resource_aws_fsx_openzfs_volume, delete_volume_options must be 'DELETE_CHILD_VOLUMES_AND_SNAPSHOTS'."
  }
}

variable "nfs_exports" {
  description = "NFS export configuration for the root volume. Exactly 1 item."
  type = object({
    client_configurations = list(object({
      clients = string
      options = list(string)
    }))
  })
  default = null

  validation {
    condition = var.nfs_exports == null || (
      var.nfs_exports != null &&
      length(var.nfs_exports.client_configurations) <= 25 &&
      alltrue([
        for config in var.nfs_exports.client_configurations :
        length(config.options) <= 20
      ])
    )
    error_message = "resource_aws_fsx_openzfs_volume, nfs_exports client_configurations must have maximum of 25 items, and each configuration must have maximum of 20 options."
  }
}

variable "read_only" {
  description = "Specifies whether the volume is read-only. Default is false."
  type        = bool
  default     = false
}

variable "record_size_kib" {
  description = "The record size of an OpenZFS volume, in kibibytes (KiB). Valid values are 4, 8, 16, 32, 64, 128, 256, 512, or 1024 KiB. The default is 128 KiB."
  type        = number
  default     = 128

  validation {
    condition     = contains([4, 8, 16, 32, 64, 128, 256, 512, 1024], var.record_size_kib)
    error_message = "resource_aws_fsx_openzfs_volume, record_size_kib must be one of: 4, 8, 16, 32, 64, 128, 256, 512, or 1024."
  }
}

variable "origin_snapshot" {
  description = "Specifies the configuration to use when creating the OpenZFS volume."
  type = object({
    copy_strategy = string
    snapshot_arn  = string
  })
  default = null

  validation {
    condition = var.origin_snapshot == null || (
      var.origin_snapshot != null &&
      contains(["CLONE", "FULL_COPY", "INCREMENTAL_COPY"], var.origin_snapshot.copy_strategy)
    )
    error_message = "resource_aws_fsx_openzfs_volume, origin_snapshot copy_strategy must be one of: 'CLONE', 'FULL_COPY', 'INCREMENTAL_COPY'."
  }
}

variable "storage_capacity_quota_gib" {
  description = "The maximum amount of storage in gibibytes (GiB) that the volume can use from its parent."
  type        = number
  default     = null

  validation {
    condition     = var.storage_capacity_quota_gib == null || var.storage_capacity_quota_gib >= 0
    error_message = "resource_aws_fsx_openzfs_volume, storage_capacity_quota_gib must be a non-negative number."
  }
}

variable "storage_capacity_reservation_gib" {
  description = "The amount of storage in gibibytes (GiB) to reserve from the parent volume."
  type        = number
  default     = null

  validation {
    condition     = var.storage_capacity_reservation_gib == null || var.storage_capacity_reservation_gib >= 0
    error_message = "resource_aws_fsx_openzfs_volume, storage_capacity_reservation_gib must be a non-negative number."
  }
}

variable "user_and_group_quotas" {
  description = "Specify how much storage users or groups can use on the volume. Maximum number of items defined by FSx for OpenZFS Resource quota."
  type = list(object({
    id                         = number
    storage_capacity_quota_gib = number
    Type                       = string
  }))
  default = null

  validation {
    condition = var.user_and_group_quotas == null || (
      var.user_and_group_quotas != null &&
      alltrue([
        for quota in var.user_and_group_quotas :
        quota.id >= 0 && quota.id <= 2147483647 &&
        quota.storage_capacity_quota_gib >= 0 && quota.storage_capacity_quota_gib <= 2147483647 &&
        contains(["USER", "GROUP"], quota.Type)
      ])
    )
    error_message = "resource_aws_fsx_openzfs_volume, user_and_group_quotas id and storage_capacity_quota_gib must be between 0 and 2147483647, and Type must be 'USER' or 'GROUP'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the file system."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}
}