variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "A list of IDs for the subnets that the file system will be accessible from. File systems currently support only one subnet."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_fsx_lustre_file_system, subnet_ids must contain at least one subnet ID."
  }
}

variable "auto_import_policy" {
  description = "How Amazon FSx keeps your file and directory listings up to date as you add or modify objects in your linked S3 bucket. Only supported on PERSISTENT_1 deployment types."
  type        = string
  default     = null

  validation {
    condition = var.auto_import_policy == null ? true : contains([
      "NONE", "NEW", "NEW_CHANGED", "NEW_CHANGED_DELETED"
    ], var.auto_import_policy)
    error_message = "resource_aws_fsx_lustre_file_system, auto_import_policy must be one of: NONE, NEW, NEW_CHANGED, NEW_CHANGED_DELETED."
  }
}

variable "automatic_backup_retention_days" {
  description = "The number of days to retain automatic backups. Setting this to 0 disables automatic backups. You can retain automatic backups for a maximum of 90 days. Only valid for PERSISTENT_1 and PERSISTENT_2 deployment_type."
  type        = number
  default     = null

  validation {
    condition     = var.automatic_backup_retention_days == null ? true : (var.automatic_backup_retention_days >= 0 && var.automatic_backup_retention_days <= 90)
    error_message = "resource_aws_fsx_lustre_file_system, automatic_backup_retention_days must be between 0 and 90."
  }
}

variable "backup_id" {
  description = "The ID of the source backup to create the filesystem from."
  type        = string
  default     = null
}

variable "copy_tags_to_backups" {
  description = "A boolean flag indicating whether tags for the file system should be copied to backups. Applicable for PERSISTENT_1 and PERSISTENT_2 deployment_type."
  type        = bool
  default     = false
}

variable "daily_automatic_backup_start_time" {
  description = "A recurring daily time, in the format HH:MM. HH is the zero-padded hour of the day (0-23), and MM is the zero-padded minute of the hour. Only valid for PERSISTENT_1 and PERSISTENT_2 deployment_type. Requires automatic_backup_retention_days to be set."
  type        = string
  default     = null

  validation {
    condition     = var.daily_automatic_backup_start_time == null ? true : can(regex("^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$", var.daily_automatic_backup_start_time))
    error_message = "resource_aws_fsx_lustre_file_system, daily_automatic_backup_start_time must be in the format HH:MM where HH is 0-23 and MM is 0-59."
  }
}

variable "drive_cache_type" {
  description = "The type of drive cache used by PERSISTENT_1 filesystems that are provisioned with HDD storage_type. Required for HDD storage_type, set to either READ or NONE."
  type        = string
  default     = null

  validation {
    condition     = var.drive_cache_type == null ? true : contains(["READ", "NONE"], var.drive_cache_type)
    error_message = "resource_aws_fsx_lustre_file_system, drive_cache_type must be either READ or NONE."
  }
}

variable "data_compression_type" {
  description = "Sets the data compression configuration for the file system. Valid values are LZ4 and NONE. Default value is NONE."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["LZ4", "NONE"], var.data_compression_type)
    error_message = "resource_aws_fsx_lustre_file_system, data_compression_type must be either LZ4 or NONE."
  }
}

variable "deployment_type" {
  description = "The filesystem deployment type. One of: SCRATCH_1, SCRATCH_2, PERSISTENT_1, PERSISTENT_2."
  type        = string
  default     = null

  validation {
    condition     = var.deployment_type == null ? true : contains(["SCRATCH_1", "SCRATCH_2", "PERSISTENT_1", "PERSISTENT_2"], var.deployment_type)
    error_message = "resource_aws_fsx_lustre_file_system, deployment_type must be one of: SCRATCH_1, SCRATCH_2, PERSISTENT_1, PERSISTENT_2."
  }
}

variable "efa_enabled" {
  description = "Adds support for Elastic Fabric Adapter (EFA) and GPUDirect Storage (GDS) to Lustre. This must be set at creation. Only supported when deployment_type is set to PERSISTENT_2, metadata_configuration is used, and an EFA-enabled security group is attached."
  type        = bool
  default     = null
}

variable "export_path" {
  description = "S3 URI (with optional prefix) where the root of your Amazon FSx file system is exported. Can only be specified with import_path argument. Only supported on PERSISTENT_1 deployment types."
  type        = string
  default     = null
}

variable "file_system_type_version" {
  description = "Sets the Lustre version for the file system that you're creating. Valid values are 2.10 for SCRATCH_1, SCRATCH_2 and PERSISTENT_1 deployment types. Valid values for 2.12 include all deployment types."
  type        = string
  default     = null

  validation {
    condition     = var.file_system_type_version == null ? true : contains(["2.10", "2.12"], var.file_system_type_version)
    error_message = "resource_aws_fsx_lustre_file_system, file_system_type_version must be either 2.10 or 2.12."
  }
}

variable "final_backup_tags" {
  description = "A map of tags to apply to the file system's final backup."
  type        = map(string)
  default     = {}
}

variable "imported_file_chunk_size" {
  description = "For files imported from a data repository, this value determines the stripe count and maximum amount of data per file (in MiB) stored on a single physical disk. Can only be specified with import_path argument. Defaults to 1024. Minimum of 1 and maximum of 512000. Only supported on PERSISTENT_1 deployment types."
  type        = number
  default     = 1024

  validation {
    condition     = var.imported_file_chunk_size >= 1 && var.imported_file_chunk_size <= 512000
    error_message = "resource_aws_fsx_lustre_file_system, imported_file_chunk_size must be between 1 and 512000."
  }
}

variable "import_path" {
  description = "S3 URI (with optional prefix) that you're using as the data repository for your FSx for Lustre file system. For example, s3://example-bucket/optional-prefix/. Only supported on PERSISTENT_1 deployment types."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "ARN for the KMS Key to encrypt the file system at rest, applicable for PERSISTENT_1 and PERSISTENT_2 deployment_type. Defaults to an AWS managed KMS Key."
  type        = string
  default     = null
}

variable "log_configuration" {
  description = "The Lustre logging configuration used when creating an Amazon FSx for Lustre file system."
  type = object({
    destination = optional(string)
    level       = optional(string, "DISABLED")
  })
  default = null

  validation {
    condition = var.log_configuration == null ? true : (
      var.log_configuration.level == null ? true : contains([
        "WARN_ONLY", "FAILURE_ONLY", "ERROR_ONLY", "WARN_ERROR", "DISABLED"
      ], var.log_configuration.level)
    )
    error_message = "resource_aws_fsx_lustre_file_system, log_configuration.level must be one of: WARN_ONLY, FAILURE_ONLY, ERROR_ONLY, WARN_ERROR, DISABLED."
  }
}

variable "metadata_configuration" {
  description = "The Lustre metadata configuration used when creating an Amazon FSx for Lustre file system. This can be used to specify a user provisioned metadata scale. This is only supported when deployment_type is set to PERSISTENT_2."
  type = object({
    iops = optional(number)
    mode = optional(string, "AUTOMATIC")
  })
  default = null

  validation {
    condition = var.metadata_configuration == null ? true : (
      var.metadata_configuration.mode == null ? true : contains(["AUTOMATIC", "USER_PROVISIONED"], var.metadata_configuration.mode)
    )
    error_message = "resource_aws_fsx_lustre_file_system, metadata_configuration.mode must be either AUTOMATIC or USER_PROVISIONED."
  }

  validation {
    condition = var.metadata_configuration == null ? true : (
      var.metadata_configuration.iops == null ? true : (
        var.metadata_configuration.iops == 1500 ||
        var.metadata_configuration.iops == 3000 ||
        var.metadata_configuration.iops == 6000 ||
        (var.metadata_configuration.iops >= 12000 && var.metadata_configuration.iops <= 192000 && var.metadata_configuration.iops % 12000 == 0)
      )
    )
    error_message = "resource_aws_fsx_lustre_file_system, metadata_configuration.iops must be 1500, 3000, 6000, or between 12000 and 192000 in increments of 12000."
  }
}

variable "per_unit_storage_throughput" {
  description = "Describes the amount of read and write throughput for each 1 tebibyte of storage, in MB/s/TiB, required for the PERSISTENT_1 and PERSISTENT_2 deployment_type."
  type        = number
  default     = null

  validation {
    condition = var.per_unit_storage_throughput == null ? true : contains([
      12, 40, 50, 100, 125, 200, 250, 500, 1000
    ], var.per_unit_storage_throughput)
    error_message = "resource_aws_fsx_lustre_file_system, per_unit_storage_throughput must be one of: 12, 40 (for HDD), 50, 100, 200 (for PERSISTENT_1 SSD), 125, 250, 500, 1000 (for PERSISTENT_2 SSD)."
  }
}

variable "root_squash_configuration" {
  description = "The Lustre root squash configuration used when creating an Amazon FSx for Lustre file system. When enabled, root squash restricts root-level access from clients that try to access your file system as a root user."
  type = object({
    no_squash_nids = optional(list(string))
    root_squash    = optional(string)
  })
  default = null

  validation {
    condition = var.root_squash_configuration == null ? true : (
      var.root_squash_configuration.root_squash == null ? true : can(regex("^[0-9]+:[0-9]+$", var.root_squash_configuration.root_squash))
    )
    error_message = "resource_aws_fsx_lustre_file_system, root_squash_configuration.root_squash must be in the format UID:GID (e.g., 365534:65534)."
  }
}

variable "security_group_ids" {
  description = "A list of IDs for the security groups that apply to the specified network interfaces created for file system access."
  type        = list(string)
  default     = []
}

variable "skip_final_backup" {
  description = "When enabled, will skip the default final backup taken when the file system is deleted. This configuration must be applied separately before attempting to delete the resource to have the desired behavior."
  type        = bool
  default     = true
}

variable "storage_capacity" {
  description = "The storage capacity (GiB) of the file system. Minimum of 1200. Required when not creating filesystem for a backup."
  type        = number
  default     = null

  validation {
    condition     = var.storage_capacity == null ? true : var.storage_capacity >= 1200
    error_message = "resource_aws_fsx_lustre_file_system, storage_capacity must be at least 1200 GiB."
  }
}

variable "storage_type" {
  description = "The filesystem storage type. One of SSD, HDD or INTELLIGENT_TIERING, defaults to SSD. HDD is only supported on PERSISTENT_1 deployment types. INTELLIGENT_TIERING requires data_read_cache_configuration and metadata_configuration to be set and is only supported for PERSISTENT_2 deployment types."
  type        = string
  default     = "SSD"

  validation {
    condition     = contains(["SSD", "HDD", "INTELLIGENT_TIERING"], var.storage_type)
    error_message = "resource_aws_fsx_lustre_file_system, storage_type must be one of: SSD, HDD, INTELLIGENT_TIERING."
  }
}

variable "tags" {
  description = "A map of tags to assign to the file system."
  type        = map(string)
  default     = {}
}

variable "throughput_capacity" {
  description = "Throughput in MBps required for the INTELLIGENT_TIERING storage type. Must be 4000 or multiples of 4000."
  type        = number
  default     = null

  validation {
    condition     = var.throughput_capacity == null ? true : (var.throughput_capacity >= 4000 && var.throughput_capacity % 4000 == 0)
    error_message = "resource_aws_fsx_lustre_file_system, throughput_capacity must be 4000 or multiples of 4000."
  }
}

variable "weekly_maintenance_start_time" {
  description = "The preferred start time (in d:HH:MM format) to perform weekly maintenance, in the UTC time zone."
  type        = string
  default     = null

  validation {
    condition     = var.weekly_maintenance_start_time == null ? true : can(regex("^[1-7]:[0-2][0-9]:[0-5][0-9]$", var.weekly_maintenance_start_time))
    error_message = "resource_aws_fsx_lustre_file_system, weekly_maintenance_start_time must be in the format d:HH:MM where d is 1-7, HH is 00-23, and MM is 00-59."
  }
}

variable "data_read_cache_configuration" {
  description = "The data read cache configuration for the file system."
  type = object({
    size        = optional(number)
    sizing_mode = string
  })
  default = null

  validation {
    condition = var.data_read_cache_configuration == null ? true : contains([
      "NO_CACHE", "USER_PROVISIONED", "PROPORTIONAL_TO_THROUGHPUT_CAPACITY"
    ], var.data_read_cache_configuration.sizing_mode)
    error_message = "resource_aws_fsx_lustre_file_system, data_read_cache_configuration.sizing_mode must be one of: NO_CACHE, USER_PROVISIONED, PROPORTIONAL_TO_THROUGHPUT_CAPACITY."
  }
}