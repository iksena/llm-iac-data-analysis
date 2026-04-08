variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "A value that indicates whether major version upgrades are allowed. Constraints: You must allow major version upgrades when specifying a value for the EngineVersion parameter that is a different major version than the DB cluster's current version."
  type        = bool
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window."
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "A list of EC2 Availability Zones that instances in the DB cluster can be created in."
  type        = list(string)
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for."
  type        = number
  default     = 1

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "resource_aws_docdb_cluster, backup_retention_period must be between 1 and 35 days."
  }
}

variable "cluster_identifier_prefix" {
  description = "Creates a unique cluster identifier beginning with the specified prefix. Conflicts with cluster_identifier."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier."
  type        = string
  default     = null
}

variable "db_subnet_group_name" {
  description = "A DB subnet group to associate with this DB instance."
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster."
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "A boolean value that indicates whether the DB cluster has deletion protection enabled. The database can't be deleted when deletion protection is enabled."
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch. The following log types are supported: audit, profiler."
  type        = list(string)
  default     = null

  validation {
    condition = var.enabled_cloudwatch_logs_exports == null ? true : alltrue([
      for log_type in var.enabled_cloudwatch_logs_exports : contains(["audit", "profiler"], log_type)
    ])
    error_message = "resource_aws_docdb_cluster, enabled_cloudwatch_logs_exports can only contain 'audit' and/or 'profiler'."
  }
}

variable "engine_version" {
  description = "The database engine version. Updating this argument results in an outage."
  type        = string
  default     = null
}

variable "engine" {
  description = "The name of the database engine to be used for this DB cluster."
  type        = string
  default     = "docdb"

  validation {
    condition     = var.engine == "docdb"
    error_message = "resource_aws_docdb_cluster, engine must be 'docdb'."
  }
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB cluster is deleted. If omitted, no final snapshot will be made."
  type        = string
  default     = null
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_docdb_global_cluster."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. When specifying kms_key_id, storage_encrypted needs to be set to true."
  type        = string
  default     = null
}

variable "manage_master_user_password" {
  description = "Set to true to allow Amazon DocumentDB to manage the master user password in AWS Secrets Manager. Cannot be set if master_password or master_password_wo is provided."
  type        = bool
  default     = null
}

variable "master_password" {
  description = "Password for the master DB user. Required unless a snapshot_identifier or unless a global_cluster_identifier is provided when the cluster is the secondary cluster of a global database. Conflicts with master_password_wo and manage_master_user_password."
  type        = string
  default     = null
  sensitive   = true
}

variable "master_password_wo" {
  description = "Write-Only password for the master DB user. Required unless a snapshot_identifier or unless a global_cluster_identifier is provided when the cluster is the secondary cluster of a global database. Conflicts with master_password and manage_master_user_password."
  type        = string
  default     = null
  sensitive   = true
}

variable "master_password_wo_version" {
  description = "Used together with master_password_wo to trigger an update. Increment this value when an update to the master_password_wo is required."
  type        = number
  default     = null
}

variable "master_username" {
  description = "Username for the master DB user. Required unless a snapshot_identifier or unless a global_cluster_identifier is provided when the cluster is the secondary cluster of a global database."
  type        = string
  default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections."
  type        = number
  default     = null
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter. Time in UTC. Default: A 30-minute window selected at random from an 8-hour block of time per region. E.g., 04:00-09:00"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "The weekly time range during which system maintenance can occur, in (UTC) e.g., wed:04:00-wed:04:30"
  type        = string
  default     = null
}

variable "restore_to_point_in_time" {
  description = "A configuration block for restoring a DB instance to an arbitrary point in time."
  type = object({
    restore_to_time            = optional(string)
    restore_type               = optional(string)
    source_cluster_identifier  = string
    use_latest_restorable_time = optional(bool)
  })
  default = null

  validation {
    condition = var.restore_to_point_in_time == null ? true : (
      var.restore_to_point_in_time.restore_type == null ? true : contains(["full-copy", "copy-on-write"], var.restore_to_point_in_time.restore_type)
    )
    error_message = "resource_aws_docdb_cluster, restore_to_point_in_time.restore_type must be either 'full-copy' or 'copy-on-write'."
  }

  validation {
    condition = var.restore_to_point_in_time == null ? true : (
      var.restore_to_point_in_time.restore_to_time != null && var.restore_to_point_in_time.use_latest_restorable_time == true ? false : true
    )
    error_message = "resource_aws_docdb_cluster, restore_to_point_in_time.restore_to_time cannot be specified with use_latest_restorable_time."
  }
}

variable "serverless_v2_scaling_configuration" {
  description = "Scaling configuration of an Amazon DocumentDB Serverless cluster."
  type = object({
    max_capacity = number
    min_capacity = number
  })
  default = null

  validation {
    condition = var.serverless_v2_scaling_configuration == null ? true : (
      var.serverless_v2_scaling_configuration.max_capacity >= 1 &&
      var.serverless_v2_scaling_configuration.max_capacity <= 256 &&
      var.serverless_v2_scaling_configuration.max_capacity * 2 == floor(var.serverless_v2_scaling_configuration.max_capacity * 2)
    )
    error_message = "resource_aws_docdb_cluster, serverless_v2_scaling_configuration.max_capacity must be multiples of 0.5 between 1 and 256."
  }

  validation {
    condition = var.serverless_v2_scaling_configuration == null ? true : (
      var.serverless_v2_scaling_configuration.min_capacity >= 0.5 &&
      var.serverless_v2_scaling_configuration.min_capacity <= 256 &&
      var.serverless_v2_scaling_configuration.min_capacity * 2 == floor(var.serverless_v2_scaling_configuration.min_capacity * 2)
    )
    error_message = "resource_aws_docdb_cluster, serverless_v2_scaling_configuration.min_capacity must be multiples of 0.5 between 0.5 and 256."
  }
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted. If true is specified, no DB snapshot is created. If false is specified, a DB snapshot is created before the DB cluster is deleted, using the value from final_snapshot_identifier."
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot."
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted."
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "The storage type to associate with the DB cluster."
  type        = string
  default     = null

  validation {
    condition     = var.storage_type == null ? true : contains(["standard", "iopt1"], var.storage_type)
    error_message = "resource_aws_docdb_cluster, storage_type must be either 'standard' or 'iopt1'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the DB cluster."
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster."
  type        = list(string)
  default     = null
}