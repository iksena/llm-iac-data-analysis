variable "name" {
  description = "Name of the runtime environment. Must be unique within the account."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.name))
    error_message = "resource_aws_m2_environment, name must be a valid environment name containing only alphanumeric characters, hyphens, and underscores, and must start with an alphanumeric character."
  }
}

variable "engine_type" {
  description = "Engine type must be microfocus or bluage."
  type        = string

  validation {
    condition     = contains(["microfocus", "bluage"], var.engine_type)
    error_message = "resource_aws_m2_environment, engine_type must be either 'microfocus' or 'bluage'."
  }
}

variable "instance_type" {
  description = "M2 Instance Type."
  type        = string

  validation {
    condition     = can(regex("^M2\\.", var.instance_type))
    error_message = "resource_aws_m2_environment, instance_type must be a valid M2 instance type starting with 'M2.'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The specific version of the engine for the Environment."
  type        = string
  default     = null
}

variable "force_update" {
  description = "Force update the environment even if applications are running."
  type        = bool
  default     = null
}

variable "kms_key_id" {
  description = "ARN of the KMS key to use for the Environment."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^arn:aws:kms:", var.kms_key_id))
    error_message = "resource_aws_m2_environment, kms_key_id must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "preferred_maintenance_window" {
  description = "Configures the maintenance window that you want for the runtime environment. The maintenance window must have the format ddd:hh24:mi-ddd:hh24:mi and must be less than 24 hours."
  type        = string
  default     = null

  validation {
    condition     = var.preferred_maintenance_window == null || can(regex("^[a-z]{3}:[0-9]{2}:[0-9]{2}-[a-z]{3}:[0-9]{2}:[0-9]{2}$", var.preferred_maintenance_window))
    error_message = "resource_aws_m2_environment, preferred_maintenance_window must have the format 'ddd:hh24:mi-ddd:hh24:mi' (e.g., 'sun:23:00-mon:01:00')."
  }
}

variable "publicly_accessible" {
  description = "Allow applications deployed to this environment to be publicly accessible."
  type        = bool
  default     = null
}

variable "security_group_ids" {
  description = "List of security group ids."
  type        = list(string)
  default     = null

  validation {
    condition = var.security_group_ids == null || alltrue([
      for sg in var.security_group_ids : can(regex("^sg-[a-z0-9]+$", sg))
    ])
    error_message = "resource_aws_m2_environment, security_group_ids must be a list of valid security group IDs starting with 'sg-'."
  }
}

variable "subnet_ids" {
  description = "List of subnet ids to deploy environment to."
  type        = list(string)
  default     = null

  validation {
    condition = var.subnet_ids == null || alltrue([
      for subnet in var.subnet_ids : can(regex("^subnet-[a-z0-9]+$", subnet))
    ])
    error_message = "resource_aws_m2_environment, subnet_ids must be a list of valid subnet IDs starting with 'subnet-'."
  }
}

variable "tags" {
  description = "Key-value tags for the place index."
  type        = map(string)
  default     = null
}

variable "storage_configuration" {
  description = "Storage configuration for the environment."
  type = object({
    efs = optional(object({
      mount_point    = string
      file_system_id = string
    }))
    fsx = optional(object({
      mount_point    = string
      file_system_id = string
    }))
  })
  default = null

  validation {
    condition = var.storage_configuration == null || (
      var.storage_configuration.efs == null || can(regex("^/m2/mount/", var.storage_configuration.efs.mount_point))
    )
    error_message = "resource_aws_m2_environment, storage_configuration.efs.mount_point must start with '/m2/mount/'."
  }

  validation {
    condition = var.storage_configuration == null || (
      var.storage_configuration.efs == null || can(regex("^fs-[a-z0-9]+$", var.storage_configuration.efs.file_system_id))
    )
    error_message = "resource_aws_m2_environment, storage_configuration.efs.file_system_id must be a valid EFS file system ID starting with 'fs-'."
  }

  validation {
    condition = var.storage_configuration == null || (
      var.storage_configuration.fsx == null || can(regex("^/m2/mount/", var.storage_configuration.fsx.mount_point))
    )
    error_message = "resource_aws_m2_environment, storage_configuration.fsx.mount_point must start with '/m2/mount/'."
  }

  validation {
    condition = var.storage_configuration == null || (
      var.storage_configuration.fsx == null || can(regex("^fs-[a-z0-9]+$", var.storage_configuration.fsx.file_system_id))
    )
    error_message = "resource_aws_m2_environment, storage_configuration.fsx.file_system_id must be a valid FSX file system ID starting with 'fs-'."
  }
}

variable "high_availability_config" {
  description = "High availability configuration for the environment."
  type = object({
    desired_capacity = number
  })
  default = null

  validation {
    condition     = var.high_availability_config == null || var.high_availability_config.desired_capacity > 0
    error_message = "resource_aws_m2_environment, high_availability_config.desired_capacity must be greater than 0."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}