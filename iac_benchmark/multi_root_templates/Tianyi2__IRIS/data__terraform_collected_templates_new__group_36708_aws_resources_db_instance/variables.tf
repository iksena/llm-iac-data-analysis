variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "The allocated storage in gibibytes"
  type        = number
  default     = null

  validation {
    condition     = var.allocated_storage == null || var.allocated_storage >= 5
    error_message = "resource_aws_db_instance, allocated_storage must be at least 5 GiB."
  }
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed"
  type        = bool
  default     = false
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
  description = "The AZ for the RDS instance"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 0

  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "resource_aws_db_instance, backup_retention_period must be between 0 and 35 days."
  }
}

variable "backup_target" {
  description = "Specifies where automated backups and manual snapshots are stored"
  type        = string
  default     = "region"

  validation {
    condition     = contains(["region", "outposts"], var.backup_target)
    error_message = "resource_aws_db_instance, backup_target must be either 'region' or 'outposts'."
  }
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled"
  type        = string
  default     = null
}

variable "blue_green_update" {
  description = "Enables low-downtime updates using RDS Blue/Green deployments"
  type = object({
    enabled = optional(bool, false)
  })
  default = null
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle and Microsoft SQL instances (collation)"
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Instance tags to snapshots"
  type        = bool
  default     = false
}

variable "custom_iam_instance_profile" {
  description = "The instance profile associated with the underlying Amazon EC2 instance of an RDS Custom DB instance"
  type        = string
  default     = null
}

variable "database_insights_mode" {
  description = "The mode of Database Insights that is enabled for the instance"
  type        = string
  default     = null

  validation {
    condition     = var.database_insights_mode == null || contains(["standard", "advanced"], var.database_insights_mode)
    error_message = "resource_aws_db_instance, database_insights_mode must be either 'standard' or 'advanced'."
  }
}

variable "db_name" {
  description = "The name of the database to create when the DB instance is created"
  type        = string
  default     = null
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group"
  type        = string
  default     = null
}

variable "dedicated_log_volume" {
  description = "Use a dedicated log volume (DLV) for the DB instance"
  type        = bool
  default     = false
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in"
  type        = string
  default     = null
}

variable "domain_auth_secret_arn" {
  description = "The ARN for the Secrets Manager secret with the self managed Active Directory credentials"
  type        = string
  default     = null
}

variable "domain_dns_ips" {
  description = "The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers"
  type        = list(string)
  default     = null

  validation {
    condition     = var.domain_dns_ips == null || length(var.domain_dns_ips) == 2
    error_message = "resource_aws_db_instance, domain_dns_ips must contain exactly two IP addresses."
  }
}

variable "domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of the self managed Active Directory domain"
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = null
}

variable "domain_ou" {
  description = "The self managed Active Directory organizational unit for your DB instance to join"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Set of log types to enable for exporting to CloudWatch logs"
  type        = set(string)
  default     = []
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = null
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "engine_lifecycle_support" {
  description = "The life cycle type for this DB instance"
  type        = string
  default     = "open-source-rds-extended-support"

  validation {
    condition     = contains(["open-source-rds-extended-support", "open-source-rds-extended-support-disabled"], var.engine_lifecycle_support)
    error_message = "resource_aws_db_instance, engine_lifecycle_support must be 'open-source-rds-extended-support' or 'open-source-rds-extended-support-disabled'."
  }
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = false
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = null
}

variable "identifier_prefix" {
  description = "Creates a unique identifier beginning with the specified prefix"
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "iops" {
  description = "The amount of provisioned IOPS"
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model information for this DB instance"
  type        = string
  default     = null

  validation {
    condition = var.license_model == null || contains([
      "general-public-license",
      "license-included",
      "bring-your-own-license",
      "postgresql-license"
    ], var.license_model)
    error_message = "resource_aws_db_instance, license_model must be one of: general-public-license, license-included, bring-your-own-license, postgresql-license."
  }
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
  default     = null
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager"
  type        = bool
  default     = false
}

variable "master_user_secret_kms_key_id" {
  description = "The Amazon Web Services KMS key identifier for the KMS key"
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = "Specifies the maximum storage (in GiB) that Amazon RDS can automatically scale to for this DB instance"
  type        = number
  default     = null
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance"
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval)
    error_message = "resource_aws_db_instance, monitoring_interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "nchar_character_set_name" {
  description = "The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances"
  type        = string
  default     = null
}

variable "network_type" {
  description = "The network type of the DB instance"
  type        = string
  default     = null

  validation {
    condition     = var.network_type == null || contains(["IPV4", "DUAL"], var.network_type)
    error_message = "resource_aws_db_instance, network_type must be either 'IPV4' or 'DUAL'."
  }
}

variable "option_group_name" {
  description = "Name of the DB option group to associate"
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "password" {
  description = "Password for the master DB user"
  type        = string
  default     = null
  sensitive   = true
}

variable "password_wo" {
  description = "Password for the master DB user (write-only)"
  type        = string
  default     = null
  sensitive   = true
}

variable "password_wo_version" {
  description = "Used together with password_wo to trigger an update"
  type        = number
  default     = null
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Amount of time in days to retain Performance Insights data"
  type        = number
  default     = 7

  validation {
    condition = var.performance_insights_retention_period == 7 || var.performance_insights_retention_period == 731 || (
      var.performance_insights_retention_period % 31 == 0 && var.performance_insights_retention_period > 31
    )
    error_message = "resource_aws_db_instance, performance_insights_retention_period must be 7, 731, or a multiple of 31."
  }
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode"
  type        = string
  default     = null

  validation {
    condition     = var.replica_mode == null || contains(["mounted", "open-read-only"], var.replica_mode)
    error_message = "resource_aws_db_instance, replica_mode must be either 'mounted' or 'open-read-only'."
  }
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replica database, and to use this value as the source database"
  type        = string
  default     = null
}

variable "upgrade_storage_config" {
  description = "Whether to upgrade the storage file system configuration on the read replica"
  type        = bool
  default     = false
}

variable "restore_to_point_in_time" {
  description = "A configuration block for restoring a DB instance to an arbitrary point in time"
  type = object({
    restore_time                             = optional(string)
    source_db_instance_identifier            = optional(string)
    source_db_instance_automated_backups_arn = optional(string)
    source_dbi_resource_id                   = optional(string)
    use_latest_restorable_time               = optional(bool, false)
  })
  default = null
}

variable "s3_import" {
  description = "Restore from a Percona Xtrabackup in S3"
  type = object({
    bucket_name           = string
    bucket_prefix         = optional(string)
    ingestion_role        = string
    source_engine         = string
    source_engine_version = string
  })
  default = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD), io1 (provisioned IOPS SSD), or io2 (block express storage provisioned IOPS SSD)"
  type        = string
  default     = null

  validation {
    condition     = var.storage_type == null || contains(["standard", "gp2", "gp3", "io1", "io2"], var.storage_type)
    error_message = "resource_aws_db_instance, storage_type must be one of: standard, gp2, gp3, io1, io2."
  }
}

variable "storage_throughput" {
  description = "The storage throughput value for the DB instance"
  type        = number
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "timezone" {
  description = "Time zone of the DB instance"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "customer_owned_ip_enabled" {
  description = "Indicates whether to enable a customer-owned IP address (CoIP) for an RDS on Outposts DB instance"
  type        = bool
  default     = false
}