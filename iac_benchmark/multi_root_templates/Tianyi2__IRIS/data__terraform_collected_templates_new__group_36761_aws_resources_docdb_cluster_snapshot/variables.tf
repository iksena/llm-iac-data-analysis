variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_cluster_identifier" {
  description = "The DocumentDB Cluster Identifier from which to take the snapshot."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.db_cluster_identifier)) && length(var.db_cluster_identifier) >= 1 && length(var.db_cluster_identifier) <= 63
    error_message = "resource_aws_docdb_cluster_snapshot, db_cluster_identifier must start with a letter, contain only alphanumeric characters and hyphens, and be between 1 and 63 characters long."
  }
}

variable "db_cluster_snapshot_identifier" {
  description = "The Identifier for the snapshot."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.db_cluster_snapshot_identifier)) && length(var.db_cluster_snapshot_identifier) >= 1 && length(var.db_cluster_snapshot_identifier) <= 63
    error_message = "resource_aws_docdb_cluster_snapshot, db_cluster_snapshot_identifier must start with a letter, contain only alphanumeric characters and hyphens, and be between 1 and 63 characters long."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the DocumentDB cluster snapshot."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.create_timeout))
    error_message = "resource_aws_docdb_cluster_snapshot, create_timeout must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}