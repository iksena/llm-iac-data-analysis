variable "deployment_type" {
  description = "Filesystem deployment type"
  type        = string

  validation {
    condition     = contains(["SINGLE_AZ_1", "SINGLE_AZ_2", "MULTI_AZ_1"], var.deployment_type)
    error_message = "resource_aws_fsx_openzfs_file_system, deployment_type must be one of: SINGLE_AZ_1, SINGLE_AZ_2, MULTI_AZ_1."
  }
}

variable "storage_capacity" {
  description = "The storage capacity (GiB) of the file system"
  type        = number

  validation {
    condition     = var.storage_capacity >= 64 && var.storage_capacity <= 524288
    error_message = "resource_aws_fsx_openzfs_file_system, storage_capacity must be between 64 and 524288."
  }
}

variable "subnet_ids" {
  description = "A list of IDs for the subnets that the file system will be accessible from"
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_fsx_openzfs_file_system, subnet_ids must contain at least one subnet ID."
  }
}

variable "throughput_capacity" {
  description = "Throughput (MB/s) of the file system"
  type        = number
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "automatic_backup_retention_days" {
  description = "The number of days to retain automatic backups"
  type        = number
  default     = null

  validation {
    condition     = var.automatic_backup_retention_days == null || (var.automatic_backup_retention_days >= 0 && var.automatic_backup_retention_days <= 90)
    error_message = "resource_aws_fsx_openzfs_file_system, automatic_backup_retention_days must be between 0 and 90."
  }
}

variable "backup_id" {
  description = "The ID of the source backup to create the filesystem from"
  type        = string
  default     = null
}

variable "copy_tags_to_backups" {
  description = "A boolean flag indicating whether tags for the file system should be copied to backups"
  type        = bool
  default     = false
}

variable "copy_tags_to_volumes" {
  description = "A boolean flag indicating whether tags for the file system should be copied to snapshots"
  type        = bool
  default     = false
}

variable "daily_automatic_backup_start_time" {
  description = "A recurring daily time, in the format HH:MM"
  type        = string
  default     = null

  validation {
    condition     = var.daily_automatic_backup_start_time == null || can(regex("^([01]?[0-9]|2[0-3]):[0-5][0-9]$", var.daily_automatic_backup_start_time))
    error_message = "resource_aws_fsx_openzfs_file_system, daily_automatic_backup_start_time must be in HH:MM format where HH is 00-23 and MM is 00-59."
  }
}

variable "delete_options" {
  description = "List of delete options"
  type        = list(string)
  default     = null

  validation {
    condition = var.delete_options == null || alltrue([
      for option in var.delete_options : contains(["DELETE_CHILD_VOLUMES_AND_SNAPSHOTS"], option)
    ])
    error_message = "resource_aws_fsx_openzfs_file_system, delete_options must contain only valid values: DELETE_CHILD_VOLUMES_AND_SNAPSHOTS."
  }
}

variable "disk_iops_configuration" {
  description = "The SSD IOPS configuration for the Amazon FSx for OpenZFS file system"
  type = object({
    iops = optional(number)
    mode = optional(string)
  })
  default = null

  validation {
    condition = var.disk_iops_configuration == null || (
      var.disk_iops_configuration.mode == null ||
      contains(["AUTOMATIC", "USER_PROVISIONED"], var.disk_iops_configuration.mode)
    )
    error_message = "resource_aws_fsx_openzfs_file_system, disk_iops_configuration.mode must be one of: AUTOMATIC, USER_PROVISIONED."
  }
}

variable "endpoint_ip_address_range" {
  description = "Specifies the IP address range in which the endpoints to access your file system will be created"
  type        = string
  default     = null
}

variable "final_backup_tags" {
  description = "A map of tags to apply to the file system's final backup"
  type        = map(string)
  default     = null
}

variable "kms_key_id" {
  description = "ARN for the KMS Key to encrypt the file system at rest"
  type        = string
  default     = null
}

variable "preferred_subnet_id" {
  description = "Required when deployment_type is set to MULTI_AZ_1"
  type        = string
  default     = null
}

variable "root_volume_configuration" {
  description = "The configuration for the root volume of the file system"
  type = object({
    copy_tags_to_snapshots = optional(bool)
    data_compression_type  = optional(string)
    read_only              = optional(bool)
    record_size_kib        = optional(number)
    nfs_exports = optional(object({
      client_configurations = list(object({
        clients = string
        options = list(string)
      }))
    }))
    user_and_group_quotas = optional(list(object({
      id                         = number
      storage_capacity_quota_gib = number
      type                       = string
    })))
  })
  default = null

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.data_compression_type == null ||
      contains(["LZ4", "NONE", "ZSTD"], var.root_volume_configuration.data_compression_type)
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.data_compression_type must be one of: LZ4, NONE, ZSTD."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.record_size_kib == null ||
      contains([4, 8, 16, 32, 64, 128, 256, 512, 1024], var.root_volume_configuration.record_size_kib)
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.record_size_kib must be one of: 4, 8, 16, 32, 64, 128, 256, 512, 1024."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.nfs_exports == null ||
      length(var.root_volume_configuration.nfs_exports.client_configurations) <= 25
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.nfs_exports.client_configurations maximum of 25 items allowed."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.nfs_exports == null ||
      alltrue([
        for config in var.root_volume_configuration.nfs_exports.client_configurations :
        length(config.options) <= 20
      ])
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.nfs_exports.client_configurations.options maximum of 20 items allowed."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.user_and_group_quotas == null ||
      length(var.root_volume_configuration.user_and_group_quotas) <= 100
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.user_and_group_quotas maximum of 100 items allowed."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.user_and_group_quotas == null ||
      alltrue([
        for quota in var.root_volume_configuration.user_and_group_quotas :
        quota.id >= 0 && quota.id <= 2147483647
      ])
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.user_and_group_quotas.id must be between 0 and 2147483647."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.user_and_group_quotas == null ||
      alltrue([
        for quota in var.root_volume_configuration.user_and_group_quotas :
        quota.storage_capacity_quota_gib >= 0 && quota.storage_capacity_quota_gib <= 2147483647
      ])
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.user_and_group_quotas.storage_capacity_quota_gib must be between 0 and 2147483647."
  }

  validation {
    condition = var.root_volume_configuration == null || (
      var.root_volume_configuration.user_and_group_quotas == null ||
      alltrue([
        for quota in var.root_volume_configuration.user_and_group_quotas :
        contains(["USER", "GROUP"], quota.type)
      ])
    )
    error_message = "resource_aws_fsx_openzfs_file_system, root_volume_configuration.user_and_group_quotas.type must be one of: USER, GROUP."
  }
}

variable "route_table_ids" {
  description = "Specifies the route tables in which Amazon FSx creates the rules for routing traffic to the correct file server"
  type        = list(string)
  default     = null
}

variable "security_group_ids" {
  description = "A list of IDs for the security groups that apply to the specified network interfaces created for file system access"
  type        = list(string)
  default     = null
}

variable "skip_final_backup" {
  description = "When enabled, will skip the default final backup taken when the file system is deleted"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The filesystem storage type"
  type        = string
  default     = null

  validation {
    condition     = var.storage_type == null || var.storage_type == "SSD"
    error_message = "resource_aws_fsx_openzfs_file_system, storage_type must be SSD."
  }
}

variable "tags" {
  description = "A map of tags to assign to the file system"
  type        = map(string)
  default     = null
}

variable "user_and_group_quotas" {
  description = "Specify how much storage users or groups can use on the filesystem"
  type = list(object({
    id                         = number
    storage_capacity_quota_gib = number
    type                       = string
  }))
  default = null

  validation {
    condition = var.user_and_group_quotas == null || alltrue([
      for quota in var.user_and_group_quotas :
      quota.id >= 0 && quota.id <= 2147483647
    ])
    error_message = "resource_aws_fsx_openzfs_file_system, user_and_group_quotas.id must be between 0 and 2147483647."
  }

  validation {
    condition = var.user_and_group_quotas == null || alltrue([
      for quota in var.user_and_group_quotas :
      quota.storage_capacity_quota_gib >= 0 && quota.storage_capacity_quota_gib <= 2147483647
    ])
    error_message = "resource_aws_fsx_openzfs_file_system, user_and_group_quotas.storage_capacity_quota_gib must be between 0 and 2147483647."
  }

  validation {
    condition = var.user_and_group_quotas == null || alltrue([
      for quota in var.user_and_group_quotas :
      contains(["USER", "GROUP"], quota.type)
    ])
    error_message = "resource_aws_fsx_openzfs_file_system, user_and_group_quotas.type must be one of: USER, GROUP."
  }
}

variable "weekly_maintenance_start_time" {
  description = "The preferred start time (in d:HH:MM format) to perform weekly maintenance, in the UTC time zone"
  type        = string
  default     = null

  validation {
    condition     = var.weekly_maintenance_start_time == null || can(regex("^[1-7]:([01]?[0-9]|2[0-3]):[0-5][0-9]$", var.weekly_maintenance_start_time))
    error_message = "resource_aws_fsx_openzfs_file_system, weekly_maintenance_start_time must be in d:HH:MM format where d is 1-7, HH is 00-23 and MM is 00-59."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "60m")
  })
  default = {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}