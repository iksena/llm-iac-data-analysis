variable "region" {
  type        = string
  default     = null
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
}

variable "global_cluster_identifier" {
  type        = string
  description = "Global cluster identifier."

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.global_cluster_identifier)) && length(var.global_cluster_identifier) >= 1 && length(var.global_cluster_identifier) <= 63
    error_message = "resource_aws_rds_global_cluster, global_cluster_identifier must be a valid identifier: 1-63 characters, start with letter, contain only alphanumeric characters and hyphens."
  }
}

variable "database_name" {
  type        = string
  default     = null
  description = "Name for an automatically created database on cluster creation. Terraform will only perform drift detection if a configuration value is provided."

  validation {
    condition     = var.database_name == null || can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.database_name))
    error_message = "resource_aws_rds_global_cluster, database_name must start with a letter and contain only alphanumeric characters and underscores."
  }
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "If the Global Cluster should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false."
}

variable "engine" {
  type        = string
  default     = "aurora"
  description = "Name of the database engine to be used for this DB cluster. Valid values: aurora, aurora-mysql, aurora-postgresql. Defaults to aurora. Conflicts with source_db_cluster_identifier."

  validation {
    condition     = contains(["aurora", "aurora-mysql", "aurora-postgresql"], var.engine)
    error_message = "resource_aws_rds_global_cluster, engine must be one of: aurora, aurora-mysql, aurora-postgresql."
  }
}

variable "engine_lifecycle_support" {
  type        = string
  default     = "open-source-rds-extended-support"
  description = "The life cycle type for this DB instance. This setting applies only to Aurora PostgreSQL-based global databases. Valid values are open-source-rds-extended-support, open-source-rds-extended-support-disabled. Default value is open-source-rds-extended-support."

  validation {
    condition     = contains(["open-source-rds-extended-support", "open-source-rds-extended-support-disabled"], var.engine_lifecycle_support)
    error_message = "resource_aws_rds_global_cluster, engine_lifecycle_support must be one of: open-source-rds-extended-support, open-source-rds-extended-support-disabled."
  }
}

variable "engine_version" {
  type        = string
  default     = null
  description = "Engine version of the Aurora global database. The engine, engine_version, and instance_class (on the aws_rds_cluster_instance) must together support global databases."

  validation {
    condition     = var.engine_version == null || can(regex("^[0-9]+\\.[0-9]+(\\.[a-zA-Z0-9_.-]+)?$", var.engine_version))
    error_message = "resource_aws_rds_global_cluster, engine_version must be a valid version string (e.g., 5.7.mysql_aurora.2.07.5, 11.9)."
  }
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Enable to remove DB Cluster members from Global Cluster on destroy. Required with source_db_cluster_identifier."
}

variable "source_db_cluster_identifier" {
  type        = string
  default     = null
  description = "Amazon Resource Name (ARN) to use as the primary DB Cluster of the Global Cluster on creation. Terraform cannot perform drift detection of this value."

  validation {
    condition     = var.source_db_cluster_identifier == null || can(regex("^arn:aws[a-zA-Z-]*:rds:[a-z0-9-]+:[0-9]{12}:cluster:[a-zA-Z][a-zA-Z0-9-]*$", var.source_db_cluster_identifier))
    error_message = "resource_aws_rds_global_cluster, source_db_cluster_identifier must be a valid RDS cluster ARN."
  }
}

variable "storage_encrypted" {
  type        = bool
  default     = false
  description = "Specifies whether the DB cluster is encrypted. The default is false unless source_db_cluster_identifier is specified and encrypted."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to assign to the DB cluster. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_rds_global_cluster, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}

variable "timeout_create" {
  type        = string
  default     = "30m"
  description = "Timeout for creating the RDS Global Cluster."

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_create))
    error_message = "resource_aws_rds_global_cluster, timeout_create must be a valid timeout format (e.g., 30m, 1h, 3600s)."
  }
}

variable "timeout_update" {
  type        = string
  default     = "90m"
  description = "Timeout for updating the RDS Global Cluster."

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_update))
    error_message = "resource_aws_rds_global_cluster, timeout_update must be a valid timeout format (e.g., 90m, 1h, 3600s)."
  }
}

variable "timeout_delete" {
  type        = string
  default     = "30m"
  description = "Timeout for deleting the RDS Global Cluster."

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_delete))
    error_message = "resource_aws_rds_global_cluster, timeout_delete must be a valid timeout format (e.g., 30m, 1h, 3600s)."
  }
}