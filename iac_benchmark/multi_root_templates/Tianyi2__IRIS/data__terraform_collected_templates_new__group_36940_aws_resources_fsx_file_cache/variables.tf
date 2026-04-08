variable "file_cache_type" {
  description = "The type of cache that you're creating. The only supported value is LUSTRE."
  type        = string
  validation {
    condition     = var.file_cache_type == "LUSTRE"
    error_message = "resource_aws_fsx_file_cache, file_cache_type must be LUSTRE."
  }
}

variable "file_cache_type_version" {
  description = "The version for the type of cache that you're creating. The only supported value is 2.12."
  type        = string
  validation {
    condition     = var.file_cache_type_version == "2.12"
    error_message = "resource_aws_fsx_file_cache, file_cache_type_version must be 2.12."
  }
}

variable "storage_capacity" {
  description = "The storage capacity of the cache in gibibytes (GiB). Valid values are 1200 GiB, 2400 GiB, and increments of 2400 GiB."
  type        = number
  validation {
    condition     = var.storage_capacity == 1200 || var.storage_capacity == 2400 || (var.storage_capacity > 2400 && var.storage_capacity % 2400 == 0)
    error_message = "resource_aws_fsx_file_cache, storage_capacity must be 1200 GiB, 2400 GiB, or increments of 2400 GiB."
  }
}

variable "subnet_ids" {
  description = "A list of subnet IDs that the cache will be accessible from. You can specify only one subnet ID."
  type        = list(string)
  validation {
    condition     = length(var.subnet_ids) == 1
    error_message = "resource_aws_fsx_file_cache, subnet_ids must contain exactly one subnet ID."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "copy_tags_to_data_repository_associations" {
  description = "A boolean flag indicating whether tags for the cache should be copied to data repository associations. This value defaults to false."
  type        = bool
  default     = false
}

variable "data_repository_associations" {
  description = "A list of up to 8 configurations for data repository associations (DRAs) to be created during the cache creation."
  type = list(object({
    file_cache_path                = string
    data_repository_path           = optional(string)
    data_repository_subdirectories = optional(list(string))
    nfs = optional(object({
      version = string
      dns_ips = optional(list(string))
    }))
  }))
  default = []
  validation {
    condition     = length(var.data_repository_associations) <= 8
    error_message = "resource_aws_fsx_file_cache, data_repository_associations can have a maximum of 8 configurations."
  }
  validation {
    condition = alltrue([
      for dra in var.data_repository_associations :
      dra.nfs == null || (dra.nfs.version == "NFS3")
    ])
    error_message = "resource_aws_fsx_file_cache, data_repository_associations nfs version must be NFS3 when specified."
  }
  validation {
    condition = alltrue([
      for dra in var.data_repository_associations :
      dra.nfs == null || (dra.nfs.dns_ips == null || length(dra.nfs.dns_ips) <= 2)
    ])
    error_message = "resource_aws_fsx_file_cache, data_repository_associations nfs dns_ips can have a maximum of 2 IP addresses."
  }
  validation {
    condition = alltrue([
      for dra in var.data_repository_associations :
      dra.data_repository_subdirectories == null || length(dra.data_repository_subdirectories) <= 500
    ])
    error_message = "resource_aws_fsx_file_cache, data_repository_associations data_repository_subdirectories can have a maximum of 500 entries."
  }
}

variable "kms_key_id" {
  description = "Specifies the ID of the AWS Key Management Service (AWS KMS) key to use for encrypting data on an Amazon File Cache."
  type        = string
  default     = null
}

variable "lustre_configuration" {
  description = "Lustre configuration block. Required when file_cache_type is LUSTRE."
  type = object({
    deployment_type               = string
    per_unit_storage_throughput   = number
    weekly_maintenance_start_time = optional(string)
    metadata_configuration = object({
      storage_capacity = number
    })
  })
  default = null
  validation {
    condition     = var.lustre_configuration == null || var.lustre_configuration.deployment_type == "CACHE_1"
    error_message = "resource_aws_fsx_file_cache, lustre_configuration deployment_type must be CACHE_1."
  }
  validation {
    condition     = var.lustre_configuration == null || var.lustre_configuration.per_unit_storage_throughput == 1000
    error_message = "resource_aws_fsx_file_cache, lustre_configuration per_unit_storage_throughput must be 1000."
  }
  validation {
    condition     = var.lustre_configuration == null || var.lustre_configuration.metadata_configuration.storage_capacity == 2400
    error_message = "resource_aws_fsx_file_cache, lustre_configuration metadata_configuration storage_capacity must be 2400 GiB."
  }
  validation {
    condition     = var.lustre_configuration == null || var.lustre_configuration.weekly_maintenance_start_time == null || can(regex("^[1-7]:(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$", var.lustre_configuration.weekly_maintenance_start_time))
    error_message = "resource_aws_fsx_file_cache, lustre_configuration weekly_maintenance_start_time must be in format D:HH:MM where D is 1-7, HH is 00-23, MM is 00-59."
  }
}

variable "security_group_ids" {
  description = "A list of IDs specifying the security groups to apply to all network interfaces created for Amazon File Cache access."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the file cache."
  type        = map(string)
  default     = {}
}