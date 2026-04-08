variable "associate_default_security_group" {
  description = "Whether to associate the default Elastic Disaster Recovery Security group with the Replication Configuration Template"
  type        = bool
  validation {
    condition     = can(var.associate_default_security_group)
    error_message = "resource_aws_drs_replication_configuration_template, associate_default_security_group must be a boolean value."
  }
}

variable "bandwidth_throttling" {
  description = "Configure bandwidth throttling for the outbound data transfer rate of the Source Server in Mbps"
  type        = number
  validation {
    condition     = var.bandwidth_throttling > 0
    error_message = "resource_aws_drs_replication_configuration_template, bandwidth_throttling must be a positive number."
  }
}

variable "create_public_ip" {
  description = "Whether to create a Public IP for the Recovery Instance by default"
  type        = bool
  validation {
    condition     = can(var.create_public_ip)
    error_message = "resource_aws_drs_replication_configuration_template, create_public_ip must be a boolean value."
  }
}

variable "data_plane_routing" {
  description = "Data plane routing mechanism that will be used for replication"
  type        = string
  validation {
    condition     = contains(["PUBLIC_IP", "PRIVATE_IP"], var.data_plane_routing)
    error_message = "resource_aws_drs_replication_configuration_template, data_plane_routing must be either PUBLIC_IP or PRIVATE_IP."
  }
}

variable "default_large_staging_disk_type" {
  description = "Staging Disk EBS volume type to be used during replication"
  type        = string
  validation {
    condition     = contains(["GP2", "GP3", "ST1", "AUTO"], var.default_large_staging_disk_type)
    error_message = "resource_aws_drs_replication_configuration_template, default_large_staging_disk_type must be one of GP2, GP3, ST1, or AUTO."
  }
}

variable "ebs_encryption" {
  description = "Type of EBS encryption to be used during replication"
  type        = string
  validation {
    condition     = contains(["DEFAULT", "CUSTOM"], var.ebs_encryption)
    error_message = "resource_aws_drs_replication_configuration_template, ebs_encryption must be either DEFAULT or CUSTOM."
  }
}

variable "ebs_encryption_key_arn" {
  description = "ARN of the EBS encryption key to be used during replication"
  type        = string
  validation {
    condition     = can(regex("^arn:aws:kms:", var.ebs_encryption_key_arn))
    error_message = "resource_aws_drs_replication_configuration_template, ebs_encryption_key_arn must be a valid KMS key ARN."
  }
}

variable "pit_policy" {
  description = "Configuration block for Point in time (PIT) policy to manage snapshots taken during replication"
  type = list(object({
    enabled            = optional(bool, true)
    interval           = number
    retention_duration = number
    rule_id            = optional(number)
    units              = string
  }))
  validation {
    condition = alltrue([
      for policy in var.pit_policy : contains(["MINUTE", "HOUR", "DAY"], policy.units)
    ])
    error_message = "resource_aws_drs_replication_configuration_template, pit_policy units must be one of MINUTE, HOUR, or DAY."
  }
  validation {
    condition = alltrue([
      for policy in var.pit_policy : policy.interval > 0
    ])
    error_message = "resource_aws_drs_replication_configuration_template, pit_policy interval must be a positive number."
  }
  validation {
    condition = alltrue([
      for policy in var.pit_policy : policy.retention_duration > 0
    ])
    error_message = "resource_aws_drs_replication_configuration_template, pit_policy retention_duration must be a positive number."
  }
}

variable "replication_server_instance_type" {
  description = "Instance type to be used for the replication server"
  type        = string
  validation {
    condition     = length(var.replication_server_instance_type) > 0
    error_message = "resource_aws_drs_replication_configuration_template, replication_server_instance_type cannot be empty."
  }
}

variable "replication_servers_security_groups_ids" {
  description = "Security group IDs that will be used by the replication server"
  type        = list(string)
  validation {
    condition     = length(var.replication_servers_security_groups_ids) > 0
    error_message = "resource_aws_drs_replication_configuration_template, replication_servers_security_groups_ids must contain at least one security group ID."
  }
  validation {
    condition = alltrue([
      for sg_id in var.replication_servers_security_groups_ids : can(regex("^sg-", sg_id))
    ])
    error_message = "resource_aws_drs_replication_configuration_template, replication_servers_security_groups_ids must contain valid security group IDs starting with 'sg-'."
  }
}

variable "staging_area_subnet_id" {
  description = "Subnet to be used by the replication staging area"
  type        = string
  validation {
    condition     = can(regex("^subnet-", var.staging_area_subnet_id))
    error_message = "resource_aws_drs_replication_configuration_template, staging_area_subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "staging_area_tags" {
  description = "Set of tags to be associated with all resources created in the replication staging area: EC2 replication server, EBS volumes, EBS snapshots, etc"
  type        = map(string)
  default     = {}
  validation {
    condition     = can(var.staging_area_tags)
    error_message = "resource_aws_drs_replication_configuration_template, staging_area_tags must be a valid map of strings."
  }
}

variable "use_dedicated_replication_server" {
  description = "Whether to use a dedicated Replication Server in the replication staging area"
  type        = bool
  validation {
    condition     = can(var.use_dedicated_replication_server)
    error_message = "resource_aws_drs_replication_configuration_template, use_dedicated_replication_server must be a boolean value."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "resource_aws_drs_replication_configuration_template, region must be a valid AWS region or null."
  }
}

variable "auto_replicate_new_disks" {
  description = "Whether to allow the AWS replication agent to automatically replicate newly added disks"
  type        = bool
  default     = null
  validation {
    condition     = var.auto_replicate_new_disks == null || can(var.auto_replicate_new_disks)
    error_message = "resource_aws_drs_replication_configuration_template, auto_replicate_new_disks must be a boolean value or null."
  }
}

variable "tags" {
  description = "Set of tags to be associated with the Replication Configuration Template resource"
  type        = map(string)
  default     = {}
  validation {
    condition     = can(var.tags)
    error_message = "resource_aws_drs_replication_configuration_template, tags must be a valid map of strings."
  }
}

variable "timeouts" {
  description = "Configuration for resource timeouts"
  type = object({
    create = optional(string, "20m")
    update = optional(string, "20m")
    delete = optional(string, "20m")
  })
  default = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_drs_replication_configuration_template, timeouts must be in format like '20m', '1h', '30s'."
  }
}