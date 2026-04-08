variable "source_file_system_id" {
  description = "The ID of the file system that is to be replicated"
  type        = string

  validation {
    condition     = length(var.source_file_system_id) > 0
    error_message = "resource_aws_efs_replication_configuration, source_file_system_id must be a non-empty string."
  }

  validation {
    condition     = can(regex("^fs-[a-f0-9]{8,40}$", var.source_file_system_id))
    error_message = "resource_aws_efs_replication_configuration, source_file_system_id must be a valid EFS file system ID format (fs-xxxxxxxx)."
  }
}

variable "destination" {
  description = "A destination configuration block"
  type = object({
    availability_zone_name = optional(string)
    file_system_id         = optional(string)
    kms_key_id             = optional(string)
    region                 = optional(string)
  })

  validation {
    condition     = var.destination != null
    error_message = "resource_aws_efs_replication_configuration, destination is required and cannot be null."
  }

  validation {
    condition     = var.destination.file_system_id == null || can(regex("^fs-[a-f0-9]{8,40}$", var.destination.file_system_id))
    error_message = "resource_aws_efs_replication_configuration, destination.file_system_id must be a valid EFS file system ID format (fs-xxxxxxxx) when specified."
  }

  validation {
    condition     = var.destination.availability_zone_name == null || can(regex("^[a-z0-9-]+[a-z]$", var.destination.availability_zone_name))
    error_message = "resource_aws_efs_replication_configuration, destination.availability_zone_name must be a valid availability zone name when specified."
  }

  validation {
    condition     = var.destination.kms_key_id == null || length(var.destination.kms_key_id) > 0
    error_message = "resource_aws_efs_replication_configuration, destination.kms_key_id must be a non-empty string when specified."
  }

  validation {
    condition     = var.destination.region == null || can(regex("^[a-z0-9-]+$", var.destination.region))
    error_message = "resource_aws_efs_replication_configuration, destination.region must be a valid AWS region format when specified."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = {
    create = "20m"
    delete = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_efs_replication_configuration, timeouts.create must be a valid duration format (e.g., '20m', '1h', '30s')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_efs_replication_configuration, timeouts.delete must be a valid duration format (e.g., '20m', '1h', '30s')."
  }
}