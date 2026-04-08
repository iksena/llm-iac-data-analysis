variable "allow_major_version_upgrade" {
  description = "Whether upgrades between different major versions are allowed. You must set it to `true` when providing an `engine_version` parameter that uses a different major version than the DB cluster's current version"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Whether any cluster modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "List of EC2 Availability Zones that instances in the Neptune cluster can be created in"
  type        = list(string)
  default     = null
}

variable "backup_retention_period" {
  description = "Days to retain backups for"
  type        = number
  default     = 1

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "resource_aws_neptune_cluster, backup_retention_period must be between 1 and 35 days."
  }
}

variable "cluster_identifier" {
  description = "Cluster identifier. If omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = null

  validation {
    condition     = var.cluster_identifier == null || can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.cluster_identifier))
    error_message = "resource_aws_neptune_cluster, cluster_identifier must start with a letter, contain only lowercase letters, numbers, and hyphens, and end with a letter or number."
  }
}

variable "cluster_identifier_prefix" {
  description = "Creates a unique cluster identifier beginning with the specified prefix. Conflicts with cluster_identifier"
  type        = string
  default     = null

  validation {
    condition     = var.cluster_identifier_prefix == null || can(regex("^[a-z][a-z0-9-]*$", var.cluster_identifier_prefix))
    error_message = "resource_aws_neptune_cluster, cluster_identifier_prefix must start with a letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "copy_tags_to_snapshot" {
  description = "If set to true, tags are copied to any snapshot of the DB cluster that is created"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Value that indicates whether the DB cluster has deletion protection enabled. The database can't be deleted when deletion protection is enabled"
  type        = bool
  default     = false
}

variable "enable_cloudwatch_logs_exports" {
  description = "List of the log types this DB cluster is configured to export to Cloudwatch Logs. Currently only supports `audit` and `slowquery`"
  type        = list(string)
  default     = null

  validation {
    condition = var.enable_cloudwatch_logs_exports == null || alltrue([
      for log_type in var.enable_cloudwatch_logs_exports : contains(["audit", "slowquery"], log_type)
    ])
    error_message = "resource_aws_neptune_cluster, enable_cloudwatch_logs_exports can only contain 'audit' and 'slowquery' log types."
  }
}

variable "engine" {
  description = "Name of the database engine to be used for this Neptune cluster"
  type        = string
  default     = "neptune"

  validation {
    condition     = var.engine == "neptune"
    error_message = "resource_aws_neptune_cluster, engine must be 'neptune'."
  }
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "Name of your final Neptune snapshot when this Neptune cluster is deleted. If omitted, no final snapshot will be made"
  type        = string
  default     = null

  validation {
    condition     = var.final_snapshot_identifier == null || can(regex("^[a-zA-Z0-9-]*$", var.final_snapshot_identifier))
    error_message = "resource_aws_neptune_cluster, final_snapshot_identifier can only contain letters, numbers, and hyphens."
  }
}

variable "global_cluster_identifier" {
  description = "Global cluster identifier specified on aws_neptune_global_cluster"
  type        = string
  default     = null
}

variable "iam_roles" {
  description = "List of ARNs for the IAM roles to associate to the Neptune Cluster"
  type        = list(string)
  default     = null

  validation {
    condition = var.iam_roles == null || alltrue([
      for arn in var.iam_roles : can(regex("^arn:aws:iam::[0-9]{12}:role/.+", arn))
    ])
    error_message = "resource_aws_neptune_cluster, iam_roles must contain valid IAM role ARNs."
  }
}

variable "iam_database_authentication_enabled" {
  description = "Whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN for the KMS encryption key. When specifying kms_key_arn, storage_encrypted needs to be set to true"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]{12}:key/.+", var.kms_key_arn))
    error_message = "resource_aws_neptune_cluster, kms_key_arn must be a valid KMS key ARN."
  }
}

variable "neptune_cluster_parameter_group_name" {
  description = "Cluster parameter group to associate with the cluster"
  type        = string
  default     = null
}

variable "neptune_instance_parameter_group_name" {
  description = "Name of DB parameter group to apply to all instances in the cluster"
  type        = string
  default     = null
}

variable "neptune_subnet_group_name" {
  description = "Neptune subnet group to associate with this Neptune instance"
  type        = string
  default     = null
}

variable "port" {
  description = "Port on which the Neptune accepts connections"
  type        = number
  default     = 8182

  validation {
    condition     = var.port >= 1150 && var.port <= 65535
    error_message = "resource_aws_neptune_cluster, port must be between 1150 and 65535."
  }
}

variable "preferred_backup_window" {
  description = "Daily time range during which automated backups are created if automated backups are enabled using the BackupRetentionPeriod parameter. Time in UTC"
  type        = string
  default     = null

  validation {
    condition     = var.preferred_backup_window == null || can(regex("^([01]?[0-9]|2[0-3]):[0-5][0-9]-([01]?[0-9]|2[0-3]):[0-5][0-9]$", var.preferred_backup_window))
    error_message = "resource_aws_neptune_cluster, preferred_backup_window must be in the format HH:MM-HH:MM (e.g., 04:00-09:00)."
  }
}

variable "preferred_maintenance_window" {
  description = "Weekly time range during which system maintenance can occur, in (UTC)"
  type        = string
  default     = null

  validation {
    condition     = var.preferred_maintenance_window == null || can(regex("^(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]-(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]$", var.preferred_maintenance_window))
    error_message = "resource_aws_neptune_cluster, preferred_maintenance_window must be in the format day:HH:MM-day:HH:MM (e.g., wed:04:00-wed:04:30)."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "replication_source_identifier" {
  description = "ARN of a source Neptune cluster or Neptune instance if this Neptune cluster is to be created as a Read Replica"
  type        = string
  default     = null

  validation {
    condition     = var.replication_source_identifier == null || can(regex("^arn:aws:neptune:[a-z0-9-]+:[0-9]{12}:(cluster|db):.+", var.replication_source_identifier))
    error_message = "resource_aws_neptune_cluster, replication_source_identifier must be a valid Neptune cluster or instance ARN."
  }
}

variable "serverless_v2_scaling_configuration" {
  description = "Serverless v2 scaling configuration for the Neptune cluster"
  type = object({
    min_capacity = optional(number, 2.5)
    max_capacity = optional(number, 128)
  })
  default = null

  validation {
    condition = var.serverless_v2_scaling_configuration == null || (
      var.serverless_v2_scaling_configuration.min_capacity >= 1 &&
      var.serverless_v2_scaling_configuration.max_capacity <= 128 &&
      var.serverless_v2_scaling_configuration.min_capacity <= var.serverless_v2_scaling_configuration.max_capacity
    )
    error_message = "resource_aws_neptune_cluster, serverless_v2_scaling_configuration min_capacity must be >= 1, max_capacity must be <= 128, and min_capacity must be <= max_capacity."
  }
}

variable "skip_final_snapshot" {
  description = "Whether a final Neptune snapshot is created before the Neptune cluster is deleted"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a Neptune cluster snapshot, or the ARN when specifying a Neptune snapshot"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Whether the Neptune cluster is encrypted"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "Storage type associated with the cluster"
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "iopt1"], var.storage_type)
    error_message = "resource_aws_neptune_cluster, storage_type must be either 'standard' or 'iopt1'."
  }
}

variable "tags" {
  description = "Map of tags to assign to the Neptune cluster"
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster"
  type        = list(string)
  default     = null

  validation {
    condition = var.vpc_security_group_ids == null || alltrue([
      for sg_id in var.vpc_security_group_ids : can(regex("^sg-[a-f0-9]{8,17}$", sg_id))
    ])
    error_message = "resource_aws_neptune_cluster, vpc_security_group_ids must contain valid security group IDs."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the Neptune cluster operations"
  type = object({
    create = optional(string, "120m")
    update = optional(string, "120m")
    delete = optional(string, "120m")
  })
  default = {
    create = "120m"
    update = "120m"
    delete = "120m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.create)),
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.update)),
      can(regex("^[0-9]+(s|m|h)$", var.timeouts.delete))
    ])
    error_message = "resource_aws_neptune_cluster, timeouts must be in the format of '120m', '2h', or '7200s'."
  }
}