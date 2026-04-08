variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.global_cluster_identifier))
    error_message = "resource_aws_docdb_global_cluster, global_cluster_identifier must start with a letter and contain only alphanumeric characters and hyphens."
  }
}

variable "database_name" {
  description = "Name for an automatically created database on cluster creation."
  type        = string
  default     = null

  validation {
    condition     = var.database_name == null || can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.database_name))
    error_message = "resource_aws_docdb_global_cluster, database_name must start with a letter and contain only alphanumeric characters and underscores."
  }
}

variable "deletion_protection" {
  description = "If the Global Cluster should have deletion protection enabled. The database can't be deleted when this value is set to true. The default is false."
  type        = bool
  default     = false
}

variable "engine" {
  description = "Name of the database engine to be used for this DB cluster. Current Valid values: docdb. Defaults to docdb. Conflicts with source_db_cluster_identifier."
  type        = string
  default     = "docdb"

  validation {
    condition     = contains(["docdb"], var.engine)
    error_message = "resource_aws_docdb_global_cluster, engine must be one of: docdb."
  }
}

variable "engine_version" {
  description = "Engine version of the global database. Upgrading the engine version will result in all cluster members being immediately updated. NOTE: Upgrading major versions is not supported."
  type        = string
  default     = null

  validation {
    condition     = var.engine_version == null || can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.engine_version))
    error_message = "resource_aws_docdb_global_cluster, engine_version must be in the format x.y.z (e.g., 4.0.0)."
  }
}

variable "source_db_cluster_identifier" {
  description = "Amazon Resource Name (ARN) to use as the primary DB Cluster of the Global Cluster on creation. Terraform cannot perform drift detection of this value."
  type        = string
  default     = null

  validation {
    condition     = var.source_db_cluster_identifier == null || can(regex("^arn:aws:rds:", var.source_db_cluster_identifier))
    error_message = "resource_aws_docdb_global_cluster, source_db_cluster_identifier must be a valid ARN starting with 'arn:aws:rds:'."
  }
}

variable "storage_encrypted" {
  description = "Specifies whether the DB cluster is encrypted. The default is false unless source_db_cluster_identifier is specified and encrypted. Terraform will only perform drift detection if a configuration value is provided."
  type        = bool
  default     = false
}

variable "create_timeout" {
  description = "Timeout for creating the global cluster."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_docdb_global_cluster, create_timeout must be a valid timeout format (e.g., 5m, 1h)."
  }
}

variable "update_timeout" {
  description = "Timeout for updating the global cluster."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_docdb_global_cluster, update_timeout must be a valid timeout format (e.g., 5m, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the global cluster."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_docdb_global_cluster, delete_timeout must be a valid timeout format (e.g., 5m, 1h)."
  }
}