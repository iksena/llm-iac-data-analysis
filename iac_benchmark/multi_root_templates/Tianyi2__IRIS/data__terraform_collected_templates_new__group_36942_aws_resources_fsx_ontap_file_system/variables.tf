variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "storage_capacity" {
  description = "The storage capacity (GiB) of the file system. Valid values between 1024 and 196608 for SINGLE_AZ_1 and MULTI_AZ_1. Valid values are between 1024 and 524288 for MULTI_AZ_2. Valid values between 1024 and 1048576 for SINGLE_AZ_2."
  type        = number

  validation {
    condition     = var.storage_capacity >= 1024 && var.storage_capacity <= 1048576
    error_message = "resource_aws_fsx_ontap_file_system, storage_capacity must be between 1024 and 1048576 GiB."
  }
}

variable "subnet_ids" {
  description = "A list of IDs for the subnets that the file system will be accessible from. Up to 2 subnets can be provided."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 1 && length(var.subnet_ids) <= 2
    error_message = "resource_aws_fsx_ontap_file_system, subnet_ids must contain between 1 and 2 subnet IDs."
  }
}

variable "preferred_subnet_id" {
  description = "The ID for a subnet. A subnet is a range of IP addresses in your virtual private cloud (VPC)."
  type        = string
}

variable "security_group_ids" {
  description = "A list of IDs for the security groups that apply to the specified network interfaces created for file system access."
  type        = list(string)
  default     = null
}

variable "weekly_maintenance_start_time" {
  description = "The preferred start time (in d:HH:MM format) to perform weekly maintenance, in the UTC time zone."
  type        = string
  default     = null

  validation {
    condition     = var.weekly_maintenance_start_time == null || can(regex("^[0-7]:[0-2][0-9]:[0-5][0-9]$", var.weekly_maintenance_start_time))
    error_message = "resource_aws_fsx_ontap_file_system, weekly_maintenance_start_time must be in d:HH:MM format."
  }
}

variable "deployment_type" {
  description = "The filesystem deployment type. Supports MULTI_AZ_1, MULTI_AZ_2, SINGLE_AZ_1, and SINGLE_AZ_2."
  type        = string
  default     = null

  validation {
    condition     = var.deployment_type == null || contains(["MULTI_AZ_1", "MULTI_AZ_2", "SINGLE_AZ_1", "SINGLE_AZ_2"], var.deployment_type)
    error_message = "resource_aws_fsx_ontap_file_system, deployment_type must be one of: MULTI_AZ_1, MULTI_AZ_2, SINGLE_AZ_1, SINGLE_AZ_2."
  }
}

variable "kms_key_id" {
  description = "ARN for the KMS Key to encrypt the file system at rest, Defaults to an AWS managed KMS Key."
  type        = string
  default     = null
}

variable "automatic_backup_retention_days" {
  description = "The number of days to retain automatic backups. Setting this to 0 disables automatic backups. You can retain automatic backups for a maximum of 90 days."
  type        = number
  default     = null

  validation {
    condition     = var.automatic_backup_retention_days == null || (var.automatic_backup_retention_days >= 0 && var.automatic_backup_retention_days <= 90)
    error_message = "resource_aws_fsx_ontap_file_system, automatic_backup_retention_days must be between 0 and 90."
  }
}

variable "daily_automatic_backup_start_time" {
  description = "A recurring daily time, in the format HH:MM. HH is the zero-padded hour of the day (0-23), and MM is the zero-padded minute of the hour."
  type        = string
  default     = null

  validation {
    condition     = var.daily_automatic_backup_start_time == null || can(regex("^([0-1][0-9]|2[0-3]):[0-5][0-9]$", var.daily_automatic_backup_start_time))
    error_message = "resource_aws_fsx_ontap_file_system, daily_automatic_backup_start_time must be in HH:MM format with valid hours (00-23) and minutes (00-59)."
  }
}

variable "disk_iops_configuration" {
  description = "The SSD IOPS configuration for the Amazon FSx for NetApp ONTAP file system."
  type = object({
    iops = optional(number)
    mode = optional(string)
  })
  default = null

  validation {
    condition     = var.disk_iops_configuration == null || var.disk_iops_configuration.mode == null || contains(["AUTOMATIC", "USER_PROVISIONED"], var.disk_iops_configuration.mode)
    error_message = "resource_aws_fsx_ontap_file_system, disk_iops_configuration.mode must be either AUTOMATIC or USER_PROVISIONED."
  }
}

variable "endpoint_ip_address_range" {
  description = "Specifies the IP address range in which the endpoints to access your file system will be created. By default, Amazon FSx selects an unused IP address range for you from the 198.19.* range."
  type        = string
  default     = null
}

variable "ha_pairs" {
  description = "The number of ha_pairs to deploy for the file system. Valid value is 1 for SINGLE_AZ_1 or MULTI_AZ_1 and MULTI_AZ_2. Valid values are 1 through 12 for SINGLE_AZ_2."
  type        = number
  default     = null

  validation {
    condition     = var.ha_pairs == null || (var.ha_pairs >= 1 && var.ha_pairs <= 12)
    error_message = "resource_aws_fsx_ontap_file_system, ha_pairs must be between 1 and 12."
  }
}

variable "storage_type" {
  description = "The filesystem storage type. Defaults to SSD."
  type        = string
  default     = null
}

variable "fsx_admin_password" {
  description = "The ONTAP administrative password for the fsxadmin user that you can use to administer your file system using the ONTAP CLI and REST API."
  type        = string
  default     = null
  sensitive   = true
}

variable "route_table_ids" {
  description = "Specifies the VPC route tables in which your file system's endpoints will be created. You should specify all VPC route tables associated with the subnets in which your clients are located."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the file system."
  type        = map(string)
  default     = {}
}

variable "throughput_capacity" {
  description = "Sets the throughput capacity (in MBps) for the file system that you're creating. Valid values are 128, 256, 512, 1024, 2048, and 4096. Either throughput_capacity or throughput_capacity_per_ha_pair must be specified."
  type        = number
  default     = null

  validation {
    condition     = var.throughput_capacity == null || contains([128, 256, 512, 1024, 2048, 4096], var.throughput_capacity)
    error_message = "resource_aws_fsx_ontap_file_system, throughput_capacity must be one of: 128, 256, 512, 1024, 2048, 4096."
  }
}

variable "throughput_capacity_per_ha_pair" {
  description = "Sets the per-HA-pair throughput capacity (in MBps) for the file system that you're creating. Valid values depend on deployment_type and ha_pairs. Either throughput_capacity or throughput_capacity_per_ha_pair must be specified."
  type        = number
  default     = null

  validation {
    condition     = var.throughput_capacity_per_ha_pair == null || contains([128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096, 6144], var.throughput_capacity_per_ha_pair)
    error_message = "resource_aws_fsx_ontap_file_system, throughput_capacity_per_ha_pair must be one of the valid values based on deployment_type and ha_pairs: 128, 256, 384, 512, 768, 1024, 1536, 2048, 3072, 4096, 6144."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
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