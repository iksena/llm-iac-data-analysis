variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_identifier" {
  description = "The cluster identifier for which you want a snapshot."
  type        = string

  validation {
    condition     = length(var.cluster_identifier) > 0
    error_message = "resource_aws_redshift_cluster_snapshot, cluster_identifier must not be empty."
  }
}

variable "snapshot_identifier" {
  description = "A unique identifier for the snapshot that you are requesting. This identifier must be unique for all snapshots within the Amazon Web Services account."
  type        = string

  validation {
    condition     = length(var.snapshot_identifier) > 0
    error_message = "resource_aws_redshift_cluster_snapshot, snapshot_identifier must not be empty."
  }
}

variable "manual_snapshot_retention_period" {
  description = "The number of days that a manual snapshot is retained. If the value is -1, the manual snapshot is retained indefinitely. Valid values are -1 and between 1 and 3653."
  type        = number
  default     = null

  validation {
    condition     = var.manual_snapshot_retention_period == null || var.manual_snapshot_retention_period == -1 || (var.manual_snapshot_retention_period >= 1 && var.manual_snapshot_retention_period <= 3653)
    error_message = "resource_aws_redshift_cluster_snapshot, manual_snapshot_retention_period must be -1 or between 1 and 3653."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}