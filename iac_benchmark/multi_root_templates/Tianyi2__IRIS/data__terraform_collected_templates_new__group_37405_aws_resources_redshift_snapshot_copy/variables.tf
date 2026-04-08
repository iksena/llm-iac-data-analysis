variable "cluster_identifier" {
  description = "Identifier of the source cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.cluster_identifier)) && length(var.cluster_identifier) >= 1 && length(var.cluster_identifier) <= 63
    error_message = "resource_aws_redshift_snapshot_copy, cluster_identifier must be a valid cluster identifier: lowercase letters, numbers, and hyphens only, 1-63 characters, must start with a letter and end with alphanumeric character."
  }
}

variable "destination_region" {
  description = "AWS Region to copy snapshots to"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.destination_region))
    error_message = "resource_aws_redshift_snapshot_copy, destination_region must be a valid AWS region name."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_redshift_snapshot_copy, region must be a valid AWS region name or null."
  }
}

variable "manual_snapshot_retention_period" {
  description = "Number of days to retain newly copied snapshots in the destination AWS Region after they are copied from the source AWS Region. If the value is -1, the manual snapshot is retained indefinitely"
  type        = number
  default     = null

  validation {
    condition     = var.manual_snapshot_retention_period == null || (var.manual_snapshot_retention_period >= -1 && var.manual_snapshot_retention_period <= 3653)
    error_message = "resource_aws_redshift_snapshot_copy, manual_snapshot_retention_period must be between -1 and 3653 days, or null."
  }
}

variable "retention_period" {
  description = "Number of days to retain automated snapshots in the destination region after they are copied from the source region"
  type        = number
  default     = null

  validation {
    condition     = var.retention_period == null || (var.retention_period >= 0 && var.retention_period <= 35)
    error_message = "resource_aws_redshift_snapshot_copy, retention_period must be between 0 and 35 days, or null."
  }
}

variable "snapshot_copy_grant_name" {
  description = "Name of the snapshot copy grant to use when snapshots of an AWS KMS-encrypted cluster are copied to the destination region"
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_copy_grant_name == null || can(regex("^[a-zA-Z0-9_.-]+$", var.snapshot_copy_grant_name))
    error_message = "resource_aws_redshift_snapshot_copy, snapshot_copy_grant_name must contain only alphanumeric characters, underscores, periods, and hyphens, or be null."
  }
}