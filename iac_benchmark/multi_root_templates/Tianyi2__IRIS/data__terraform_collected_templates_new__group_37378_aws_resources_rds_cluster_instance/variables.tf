variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "EC2 Availability Zone that the DB instance is created in"
  type        = string
  default     = null
}

variable "ca_cert_identifier" {
  description = "Identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "Identifier of the aws_rds_cluster in which to launch this instance"
  type        = string

  validation {
    condition     = var.cluster_identifier != ""
    error_message = "resource_aws_rds_cluster_instance, cluster_identifier cannot be empty."
  }
}

variable "copy_tags_to_snapshot" {
  description = "Indicates whether to copy all of the user-defined tags from the DB instance to snapshots of the DB instance"
  type        = bool
  default     = false
}

variable "custom_iam_instance_profile" {
  description = "Instance profile associated with the underlying Amazon EC2 instance of an RDS Custom DB instance"
  type        = string
  default     = null
}

variable "db_parameter_group_name" {
  description = "Name of the DB parameter group to associate with this instance"
  type        = string
  default     = null
}

variable "db_subnet_group_name" {
  description = "Specifies the DB subnet group to associate with this DB instance"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = null
}

variable "engine" {
  description = "Name of the database engine to be used for the RDS cluster instance"
  type        = string

  validation {
    condition     = contains(["aurora-mysql", "aurora-postgresql", "mysql", "postgres"], var.engine)
    error_message = "resource_aws_rds_cluster_instance, engine must be one of: aurora-mysql, aurora-postgresql, mysql, postgres."
  }
}

variable "force_destroy" {
  description = "Forces an instance to be destroyed when a part of a read replica cluster"
  type        = bool
  default     = false
}

variable "identifier_prefix" {
  description = "Creates a unique identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "Instance class to use"
  type        = string

  validation {
    condition     = var.instance_class != ""
    error_message = "resource_aws_rds_cluster_instance, instance_class cannot be empty."
  }
}

variable "monitoring_interval" {
  description = "Interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "resource_aws_rds_cluster_instance, monitoring_interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "monitoring_role_arn" {
  description = "ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = string
  default     = null
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not"
  type        = bool
  default     = null
}

variable "performance_insights_kms_key_id" {
  description = "ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data"
  type        = number
  default     = 7

  validation {
    condition     = var.performance_insights_retention_period == 7 || var.performance_insights_retention_period == 731 || (var.performance_insights_retention_period % 31 == 0 && var.performance_insights_retention_period > 0)
    error_message = "resource_aws_rds_cluster_instance, performance_insights_retention_period must be 7, 731, or a multiple of 31."
  }
}

variable "preferred_backup_window" {
  description = "Daily time range during which automated backups are created if automated backups are enabled"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Window to perform maintenance in"
  type        = string
  default     = null
}

variable "promotion_tier" {
  description = "Failover Priority setting on instance level"
  type        = number
  default     = 0
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to assign to the instance"
  type        = map(string)
  default     = {}
}