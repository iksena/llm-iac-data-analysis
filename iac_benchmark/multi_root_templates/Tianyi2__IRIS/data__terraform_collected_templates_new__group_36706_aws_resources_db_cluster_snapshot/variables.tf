variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_cluster_identifier" {
  description = "The DB Cluster Identifier from which to take the snapshot."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.db_cluster_identifier))
    error_message = "resource_aws_db_cluster_snapshot, db_cluster_identifier must contain only alphanumeric characters and hyphens."
  }

  validation {
    condition     = length(var.db_cluster_identifier) >= 1 && length(var.db_cluster_identifier) <= 63
    error_message = "resource_aws_db_cluster_snapshot, db_cluster_identifier must be between 1 and 63 characters long."
  }
}

variable "db_cluster_snapshot_identifier" {
  description = "The Identifier for the snapshot."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.db_cluster_snapshot_identifier))
    error_message = "resource_aws_db_cluster_snapshot, db_cluster_snapshot_identifier must contain only alphanumeric characters and hyphens."
  }

  validation {
    condition     = length(var.db_cluster_snapshot_identifier) >= 1 && length(var.db_cluster_snapshot_identifier) <= 255
    error_message = "resource_aws_db_cluster_snapshot, db_cluster_snapshot_identifier must be between 1 and 255 characters long."
  }
}

variable "shared_accounts" {
  description = "List of AWS Account IDs to share the snapshot with. Use 'all' to make the snapshot public."
  type        = list(string)
  default     = null

  validation {
    condition = var.shared_accounts == null ? true : alltrue([
      for account in var.shared_accounts :
      account == "all" || can(regex("^[0-9]{12}$", account))
    ])
    error_message = "resource_aws_db_cluster_snapshot, shared_accounts must be either 'all' or a list of 12-digit AWS Account IDs."
  }
}

variable "tags" {
  description = "A map of tags to assign to the DB cluster. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags :
      length(key) <= 128 && length(value) <= 256
    ])
    error_message = "resource_aws_db_cluster_snapshot, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the DB cluster snapshot."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_db_cluster_snapshot, create_timeout must be a valid duration string (e.g., '20m', '1h', '300s')."
  }
}