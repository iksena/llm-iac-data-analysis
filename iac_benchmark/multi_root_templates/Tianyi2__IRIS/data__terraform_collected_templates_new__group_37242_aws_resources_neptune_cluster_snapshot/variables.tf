variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_cluster_identifier" {
  description = "The DB Cluster Identifier from which to take the snapshot."
  type        = string

  validation {
    condition     = length(var.db_cluster_identifier) > 0
    error_message = "resource_aws_neptune_cluster_snapshot, db_cluster_identifier must not be empty."
  }
}

variable "db_cluster_snapshot_identifier" {
  description = "The Identifier for the snapshot."
  type        = string

  validation {
    condition     = length(var.db_cluster_snapshot_identifier) > 0
    error_message = "resource_aws_neptune_cluster_snapshot, db_cluster_snapshot_identifier must not be empty."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the Neptune cluster snapshot."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(h|m|s)$", var.create_timeout))
    error_message = "resource_aws_neptune_cluster_snapshot, create_timeout must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}