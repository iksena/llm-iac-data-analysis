variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "db_instance_identifier" {
  description = "The DB Instance Identifier from which to take the snapshot."
  type        = string

  validation {
    condition     = length(var.db_instance_identifier) > 0
    error_message = "resource_aws_db_snapshot, db_instance_identifier must not be empty."
  }
}

variable "db_snapshot_identifier" {
  description = "The Identifier for the snapshot."
  type        = string

  validation {
    condition     = length(var.db_snapshot_identifier) > 0
    error_message = "resource_aws_db_snapshot, db_snapshot_identifier must not be empty."
  }
}

variable "shared_accounts" {
  description = "List of AWS Account IDs to share the snapshot with. Use 'all' to make the snapshot public."
  type        = list(string)
  default     = null

  validation {
    condition = var.shared_accounts == null || alltrue([
      for account in var.shared_accounts :
      account == "all" || can(regex("^[0-9]{12}$", account))
    ])
    error_message = "resource_aws_db_snapshot, shared_accounts must be 'all' or valid 12-digit AWS Account IDs."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "How long to wait for the snapshot creation to complete."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mh]$", var.timeouts_create))
    error_message = "resource_aws_db_snapshot, timeouts_create must be a valid duration (e.g., '20m', '1h')."
  }
}