variable "subnet_ids" {
  description = "A list of IDs for the subnets that the file system will be accessible from. To specify more than a single subnet set deployment_type to MULTI_AZ_1."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) > 0
    error_message = "resource_aws_fsx_windows_file_system, subnet_ids must contain at least one subnet ID."
  }
}

variable "throughput_capacity" {
  description = "Throughput (megabytes per second) of the file system. For valid values, refer to the AWS documentation."
  type        = number
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "active_directory_id" {
  description = "The ID for an existing Microsoft Active Directory instance that the file system should join when it's created. Cannot be specified with self_managed_active_directory."
  type        = string
  default     = null
}

variable "aliases" {
  description = "An array DNS alias names that you want to associate with the Amazon FSx file system. For more information, see Working with DNS Aliases."
  type        = list(string)
  default     = null
}

variable "audit_log_configuration" {
  description = "The configuration that Amazon FSx for Windows File Server uses to audit and log user accesses of files, folders, and file shares on the Amazon FSx for Windows File Server file system."
  type = object({
    audit_log_destination             = optional(string)
    file_access_audit_log_level       = optional(string, "DISABLED")
    file_share_access_audit_log_level = optional(string, "DISABLED")
  })
  default = null

  validation {
    condition = var.audit_log_configuration == null || (
      contains(["SUCCESS_ONLY", "FAILURE_ONLY", "SUCCESS_AND_FAILURE", "DISABLED"], var.audit_log_configuration.file_access_audit_log_level)
    )
    error_message = "resource_aws_fsx_windows_file_system, file_access_audit_log_level must be one of: SUCCESS_ONLY, FAILURE_ONLY, SUCCESS_AND_FAILURE, DISABLED."
  }

  validation {
    condition = var.audit_log_configuration == null || (
      contains(["SUCCESS_ONLY", "FAILURE_ONLY", "SUCCESS_AND_FAILURE", "DISABLED"], var.audit_log_configuration.file_share_access_audit_log_level)
    )
    error_message = "resource_aws_fsx_windows_file_system, file_share_access_audit_log_level must be one of: SUCCESS_ONLY, FAILURE_ONLY, SUCCESS_AND_FAILURE, DISABLED."
  }
}

variable "automatic_backup_retention_days" {
  description = "The number of days to retain automatic backups. Minimum of 0 and maximum of 90. Defaults to 7. Set to 0 to disable."
  type        = number
  default     = 7

  validation {
    condition     = var.automatic_backup_retention_days >= 0 && var.automatic_backup_retention_days <= 90
    error_message = "resource_aws_fsx_windows_file_system, automatic_backup_retention_days must be between 0 and 90."
  }
}

variable "backup_id" {
  description = "The ID of the source backup to create the filesystem from."
  type        = string
  default     = null
}

variable "copy_tags_to_backups" {
  description = "A boolean flag indicating whether tags on the file system should be copied to backups. Defaults to false."
  type        = bool
  default     = false
}

variable "daily_automatic_backup_start_time" {
  description = "The preferred time (in HH:MM format) to take daily automatic backups, in the UTC time zone."
  type        = string
  default     = null

  validation {
    condition     = var.daily_automatic_backup_start_time == null || can(regex("^([01][0-9]|2[0-3]):[0-5][0-9]$", var.daily_automatic_backup_start_time))
    error_message = "resource_aws_fsx_windows_file_system, daily_automatic_backup_start_time must be in HH:MM format."
  }
}

variable "deployment_type" {
  description = "Specifies the file system deployment type, valid values are MULTI_AZ_1, SINGLE_AZ_1 and SINGLE_AZ_2. Default value is SINGLE_AZ_1."
  type        = string
  default     = "SINGLE_AZ_1"

  validation {
    condition     = contains(["MULTI_AZ_1", "SINGLE_AZ_1", "SINGLE_AZ_2"], var.deployment_type)
    error_message = "resource_aws_fsx_windows_file_system, deployment_type must be one of: MULTI_AZ_1, SINGLE_AZ_1, SINGLE_AZ_2."
  }
}

variable "disk_iops_configuration" {
  description = "The SSD IOPS configuration for the Amazon FSx for Windows File Server file system."
  type = object({
    iops = optional(number)
    mode = optional(string, "AUTOMATIC")
  })
  default = null

  validation {
    condition = var.disk_iops_configuration == null || (
      contains(["AUTOMATIC", "USER_PROVISIONED"], var.disk_iops_configuration.mode)
    )
    error_message = "resource_aws_fsx_windows_file_system, disk_iops_configuration mode must be one of: AUTOMATIC, USER_PROVISIONED."
  }
}

variable "final_backup_tags" {
  description = "A map of tags to apply to the file system's final backup."
  type        = map(string)
  default     = null
}

variable "kms_key_id" {
  description = "ARN for the KMS Key to encrypt the file system at rest. Defaults to an AWS managed KMS Key."
  type        = string
  default     = null
}

variable "preferred_subnet_id" {
  description = "Specifies the subnet in which you want the preferred file server to be located. Required for when deployment type is MULTI_AZ_1."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "A list of IDs for the security groups that apply to the specified network interfaces created for file system access. These security groups will apply to all network interfaces."
  type        = list(string)
  default     = null
}

variable "self_managed_active_directory" {
  description = "Configuration block that Amazon FSx uses to join the Windows File Server instance to your self-managed (including on-premises) Microsoft Active Directory (AD) directory. Cannot be specified with active_directory_id."
  type = object({
    dns_ips                                = list(string)
    domain_name                            = string
    password                               = string
    username                               = string
    file_system_administrators_group       = optional(string, "Domain Admins")
    organizational_unit_distinguished_name = optional(string)
  })
  default = null

  validation {
    condition = var.self_managed_active_directory == null || (
      length(var.self_managed_active_directory.dns_ips) >= 1 && length(var.self_managed_active_directory.dns_ips) <= 2
    )
    error_message = "resource_aws_fsx_windows_file_system, self_managed_active_directory dns_ips must contain 1 to 2 IP addresses."
  }
}

variable "skip_final_backup" {
  description = "When enabled, will skip the default final backup taken when the file system is deleted. This configuration must be applied separately before attempting to delete the resource to have the desired behavior. Defaults to false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the file system. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "storage_capacity" {
  description = "Storage capacity (GiB) of the file system. Minimum of 32 and maximum of 65536. If the storage type is set to HDD the minimum value is 2000. Required when not creating filesystem for a backup."
  type        = number
  default     = null

  validation {
    condition = var.storage_capacity == null || (
      var.storage_capacity >= 32 && var.storage_capacity <= 65536
    )
    error_message = "resource_aws_fsx_windows_file_system, storage_capacity must be between 32 and 65536 GiB."
  }
}

variable "storage_type" {
  description = "Specifies the storage type, Valid values are SSD and HDD. HDD is supported on SINGLE_AZ_2 and MULTI_AZ_1 Windows file system deployment types. Default value is SSD."
  type        = string
  default     = "SSD"

  validation {
    condition     = contains(["SSD", "HDD"], var.storage_type)
    error_message = "resource_aws_fsx_windows_file_system, storage_type must be one of: SSD, HDD."
  }
}

variable "weekly_maintenance_start_time" {
  description = "The preferred start time (in d:HH:MM format) to perform weekly maintenance, in the UTC time zone."
  type        = string
  default     = null

  validation {
    condition     = var.weekly_maintenance_start_time == null || can(regex("^[1-7]:(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$", var.weekly_maintenance_start_time))
    error_message = "resource_aws_fsx_windows_file_system, weekly_maintenance_start_time must be in d:HH:MM format."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "45m")
    delete = optional(string, "30m")
    update = optional(string, "45m")
  })
  default = {
    create = "45m"
    delete = "30m"
    update = "45m"
  }
}