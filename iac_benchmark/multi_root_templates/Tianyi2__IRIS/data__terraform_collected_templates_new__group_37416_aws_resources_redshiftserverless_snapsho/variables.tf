variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "namespace_name" {
  description = "The namespace to create a snapshot for."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.namespace_name)) && length(var.namespace_name) > 0
    error_message = "resource_aws_redshiftserverless_snapshot, namespace_name must be a non-empty string containing only lowercase letters, numbers, and hyphens."
  }
}

variable "snapshot_name" {
  description = "The name of the snapshot."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.snapshot_name)) && length(var.snapshot_name) > 0
    error_message = "resource_aws_redshiftserverless_snapshot, snapshot_name must be a non-empty string containing only letters, numbers, and hyphens."
  }
}

variable "retention_period" {
  description = "How long to retain the created snapshot. Default value is -1."
  type        = number
  default     = -1

  validation {
    condition     = var.retention_period >= -1
    error_message = "resource_aws_redshiftserverless_snapshot, retention_period must be -1 or a positive number."
  }
}