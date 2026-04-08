variable "allocated_storage" {
  description = "The amount of storage in gibibytes (GiB) to allocate to each DB instance in the Multi-AZ DB cluster"
  type        = number
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "Enable to allow major engine version upgrades when changing engine versions"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Specifies whether any cluster modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "List of EC2 Availability Zones for the DB cluster storage where DB cluster instances can be created"
  type        = list(string)
  default     = null
  validation {
    condition     = var.availability_zones == null || length(var.availability_zones) <= 3
    error_message = "resource_aws_rds_cluster, availability_zones: A maximum of 3 AZs can be configured."
  }
}

variable "backtrack_window" {
  description = "Target backtrack window, in seconds. Only available for aurora and aurora-mysql engines currently"
  type        = number
  default     = 0
  validation {
    condition     = var.backtrack_window >= 0 && var.backtrack_window <= 259200
    error_message = "resource_aws_rds_cluster, backtrack_window: Must be between 0 and 259200 (72 hours)."
  }
}

variable "backup_retention_period" {
  description = "Days to retain backups for"
  type        = number
  default     = 1
}

variable "ca_certificate_identifier" {
  description = "The CA certificate identifier to use for the DB cluster's server certificate"
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The cluster identifier. If omitted, Terraform will assign a random, unique identifier"
  type        = string
  default     = null
}

variable "cluster_identifier_prefix" {
  description = "Creates a unique cluster identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "cluster_scalability_type" {
  description = "Specifies the scalability mode of the Aurora DB cluster"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["limitless", "standard"], var.cluster_scalability_type)
    error_message = "resource_aws_rds_cluster, cluster_scalability_type: Valid values are limitless, standard."
  }
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots"
  type        = bool
  default     = false
}

variable "database_insights_mode" {
  description = "The mode of Database Insights to enable for the DB cluster"
  type        = string
  default     = null
  validation {
    condition     = var.database_insights_mode == null || contains(["standard", "advanced"], var.database_insights_mode)
    error_message = "resource_aws_rds_cluster, database_insights_mode: Valid values are standard, advanced."
  }
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = null
}

variable "db_cluster_instance_class" {
  description = "The compute and memory capacity of each DB instance in the Multi-AZ DB cluster"
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_name" {
  description = "A cluster parameter group to associate with the cluster"
  type        = string
  default     = null
}

variable "db_instance_parameter_group_name" {
  description = "Instance parameter group to associate with all instances of the DB cluster"
  type        = string
  default     = null
}

variable "db_subnet_group_name" {
  description = "DB subnet group to associate with this DB cluster"
  type        = string
  default     = null
}

variable "db_system_id" {
  description = "For use with RDS Custom"
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB cluster is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB cluster should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The ID of the Directory Service Active Directory domain to create the cluster in"
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = null
}

variable "enable_global_write_forwarding" {
  description = "Whether cluster should forward writes to an associated global cluster"
  type        = bool
  default     = null
}

variable "enable_http_endpoint" {
  description = "Enable HTTP endpoint (data API)"
  type        = bool
  default     = null
}

variable "enable_local_write_forwarding" {
  description = "Whether read replicas can forward write operations to the writer DB instance in the DB cluster"
  type        = bool
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to export to cloudwatch"
  type        = set(string)
  default     = null
  validation {
    condition = var.enabled_cloudwatch_logs_exports == null || alltrue([
      for log_type in var.enabled_cloudwatch_logs_exports :
      contains(["audit", "error", "general", "iam-db-auth-error", "instance", "postgresql", "slowquery"], log_type)
    ])
    error_message = "resource_aws_rds_cluster, enabled_cloudwatch_logs_exports: Valid values are audit, error, general, iam-db-auth-error, instance, postgresql, slowquery."
  }
}

variable "engine" {
  description = "Name of the database engine to be used for this DB cluster"
  type        = string
  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql", "mysql", "postgres"], var.engine)
    error_message = "resource_aws_rds_cluster, engine: Valid values are aurora-mysql, aurora-postgresql, mysql, postgres."
  }
}

variable "engine_lifecycle_support" {
  description = "The life cycle type for this DB instance"
  type        = string
  default     = "open-source-rds-extended-support"
  validation {
    condition     = contains(["open-source-rds-extended-support", "open-source-rds-extended-support-disabled"], var.engine_lifecycle_support)
    error_message = "resource_aws_rds_cluster, engine_lifecycle_support: Valid values are open-source-rds-extended-support, open-source-rds-extended-support-disabled."
  }
}

variable "engine_mode" {
  description = "Database engine mode"
  type        = string
  default     = "provisioned"
  validation {
    condition     = contains(["global", "parallelquery", "provisioned", "serverless", ""], var.engine_mode)
    error_message = "resource_aws_rds_cluster, engine_mode: Valid values are global, parallelquery, provisioned, serverless, or empty string."
  }
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "Name of your final DB snapshot when this DB cluster is deleted"
  type        = string
  default     = null
}

variable "global_cluster_identifier" {
  description = "Global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or not mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = null
}

variable "iam_roles" {
  description = "List of ARNs for the IAM roles to associate to the RDS Cluster"
  type        = list(string)
  default     = null
}

variable "iops" {
  description = "Amount of Provisioned IOPS (input/output operations per second) to be initially allocated for each DB instance in the Multi-AZ DB cluster"
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = null
}

variable "master_password" {
  description = "Password for the master DB user"
  type        = string
  default     = null
  sensitive   = true
}

variable "master_password_wo" {
  description = "Write-Only password for the master DB user"
  type        = string
  default     = null
  sensitive   = true
}

variable "master_password_wo_version" {
  description = "Used together with master_password_wo to trigger an update"
  type        = number
  default     = null
}

variable "master_user_secret_kms_key_id" {
  description = "Amazon Web Services KMS key identifier for the KMS key"
  type        = string
  default     = null
}

variable "master_username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}

variable "monitoring_interval" {
  description = "Interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB cluster"
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "resource_aws_rds_cluster, monitoring_interval: Valid values are 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "monitoring_role_arn" {
  description = "ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = string
  default     = null
}

variable "network_type" {
  description = "Network type of the cluster"
  type        = string
  default     = null
  validation {
    condition     = var.network_type == null || contains(["IPV4", "DUAL"], var.network_type)
    error_message = "resource_aws_rds_cluster, network_type: Valid values are IPV4, DUAL."
  }
}

variable "performance_insights_enabled" {
  description = "Enables Performance Insights"
  type        = bool
  default     = null
}

variable "performance_insights_kms_key_id" {
  description = "Specifies the KMS Key ID to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Specifies the amount of time to retain performance insights data for"
  type        = number
  default     = null
  validation {
    condition = var.performance_insights_retention_period == null || var.performance_insights_retention_period == 7 || var.performance_insights_retention_period == 731 || (
      var.performance_insights_retention_period >= 31 && var.performance_insights_retention_period <= 713 && var.performance_insights_retention_period % 31 == 0
    )
    error_message = "resource_aws_rds_cluster, performance_insights_retention_period: Valid values are 7, month * 31 (where month is a number of months from 1-23), and 731."
  }
}

variable "port" {
  description = "Port on which the DB accepts connections"
  type        = number
  default     = null
}

variable "preferred_backup_window" {
  description = "Daily time range during which automated backups are created if automated backups are enabled"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Weekly time range during which system maintenance can occur"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB cluster is deleted"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this cluster from a snapshot"
  type        = string
  default     = null
}

variable "source_region" {
  description = "The source region for an encrypted replica DB cluster"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted"
  type        = bool
  default     = null
}

variable "storage_type" {
  description = "Specifies the storage type to be associated with the DB cluster"
  type        = string
  default     = null
  validation {
    condition     = var.storage_type == null || contains(["", "aurora-iopt1", "io1", "io2"], var.storage_type)
    error_message = "resource_aws_rds_cluster, storage_type: Valid values are empty string, aurora-iopt1 (Aurora DB Clusters), io1, io2 (Multi-AZ DB Clusters)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the DB cluster"
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Cluster"
  type        = list(string)
  default     = null
}

variable "restore_to_point_in_time" {
  description = "Nested attribute for point in time restore"
  type = object({
    source_cluster_identifier  = optional(string)
    source_cluster_resource_id = optional(string)
    restore_type               = optional(string, "full-copy")
    use_latest_restorable_time = optional(bool, false)
    restore_to_time            = optional(string)
  })
  default = null
  validation {
    condition = var.restore_to_point_in_time == null || (
      var.restore_to_point_in_time.source_cluster_identifier != null ||
      var.restore_to_point_in_time.source_cluster_resource_id != null
    )
    error_message = "resource_aws_rds_cluster, restore_to_point_in_time: One of source_cluster_identifier or source_cluster_resource_id must be specified."
  }
  validation {
    condition     = var.restore_to_point_in_time == null || contains(["full-copy", "copy-on-write"], var.restore_to_point_in_time.restore_type)
    error_message = "resource_aws_rds_cluster, restore_to_point_in_time.restore_type: Valid options are full-copy and copy-on-write."
  }
  validation {
    condition = var.restore_to_point_in_time == null || !(
      var.restore_to_point_in_time.use_latest_restorable_time == true &&
      var.restore_to_point_in_time.restore_to_time != null
    )
    error_message = "resource_aws_rds_cluster, restore_to_point_in_time: use_latest_restorable_time conflicts with restore_to_time."
  }
}

variable "s3_import" {
  description = "S3 Import Options"
  type = object({
    bucket_name           = string
    bucket_prefix         = optional(string)
    ingestion_role        = string
    source_engine         = string
    source_engine_version = string
  })
  default = null
}

variable "scaling_configuration" {
  description = "Nested attribute with scaling properties. Only valid when engine_mode is set to serverless"
  type = object({
    auto_pause               = optional(bool, true)
    max_capacity             = optional(number, 16)
    min_capacity             = optional(number, 1)
    seconds_before_timeout   = optional(number, 300)
    seconds_until_auto_pause = optional(number, 300)
    timeout_action           = optional(string, "RollbackCapacityChange")
  })
  default = null
  validation {
    condition     = var.scaling_configuration == null || contains([1, 2, 4, 8, 16, 32, 64, 128, 256], var.scaling_configuration.max_capacity)
    error_message = "resource_aws_rds_cluster, scaling_configuration.max_capacity: Valid Aurora MySQL capacity values are 1, 2, 4, 8, 16, 32, 64, 128, 256. Valid Aurora PostgreSQL capacity values are 2, 4, 8, 16, 32, 64, 192, 384."
  }
  validation {
    condition     = var.scaling_configuration == null || contains([1, 2, 4, 8, 16, 32, 64, 128, 256], var.scaling_configuration.min_capacity)
    error_message = "resource_aws_rds_cluster, scaling_configuration.min_capacity: Valid Aurora MySQL capacity values are 1, 2, 4, 8, 16, 32, 64, 128, 256. Valid Aurora PostgreSQL capacity values are 2, 4, 8, 16, 32, 64, 192, 384."
  }
  validation {
    condition     = var.scaling_configuration == null || (var.scaling_configuration.seconds_before_timeout >= 60 && var.scaling_configuration.seconds_before_timeout <= 600)
    error_message = "resource_aws_rds_cluster, scaling_configuration.seconds_before_timeout: Valid values are 60 through 600."
  }
  validation {
    condition     = var.scaling_configuration == null || (var.scaling_configuration.seconds_until_auto_pause >= 300 && var.scaling_configuration.seconds_until_auto_pause <= 86400)
    error_message = "resource_aws_rds_cluster, scaling_configuration.seconds_until_auto_pause: Valid values are 300 through 86400."
  }
  validation {
    condition     = var.scaling_configuration == null || contains(["ForceApplyCapacityChange", "RollbackCapacityChange"], var.scaling_configuration.timeout_action)
    error_message = "resource_aws_rds_cluster, scaling_configuration.timeout_action: Valid values are ForceApplyCapacityChange, RollbackCapacityChange."
  }
}

variable "serverlessv2_scaling_configuration" {
  description = "Nested attribute with scaling properties for ServerlessV2. Only valid when engine_mode is set to provisioned"
  type = object({
    max_capacity             = number
    min_capacity             = number
    seconds_until_auto_pause = optional(number)
  })
  default = null
  validation {
    condition     = var.serverlessv2_scaling_configuration == null || (var.serverlessv2_scaling_configuration.max_capacity >= 0 && var.serverlessv2_scaling_configuration.max_capacity <= 256)
    error_message = "resource_aws_rds_cluster, serverlessv2_scaling_configuration.max_capacity: Valid capacity values are in a range of 0 up to 256 in steps of 0.5."
  }
  validation {
    condition     = var.serverlessv2_scaling_configuration == null || (var.serverlessv2_scaling_configuration.min_capacity >= 0 && var.serverlessv2_scaling_configuration.min_capacity <= 256)
    error_message = "resource_aws_rds_cluster, serverlessv2_scaling_configuration.min_capacity: Valid capacity values are in a range of 0 up to 256 in steps of 0.5."
  }
  validation {
    condition     = var.serverlessv2_scaling_configuration == null || var.serverlessv2_scaling_configuration.max_capacity >= var.serverlessv2_scaling_configuration.min_capacity
    error_message = "resource_aws_rds_cluster, serverlessv2_scaling_configuration: The maximum capacity must be greater than or equal to the minimum capacity."
  }
  validation {
    condition     = var.serverlessv2_scaling_configuration == null || var.serverlessv2_scaling_configuration.seconds_until_auto_pause == null || (var.serverlessv2_scaling_configuration.seconds_until_auto_pause >= 300 && var.serverlessv2_scaling_configuration.seconds_until_auto_pause <= 86400)
    error_message = "resource_aws_rds_cluster, serverlessv2_scaling_configuration.seconds_until_auto_pause: Valid values are 300 through 86400."
  }
}