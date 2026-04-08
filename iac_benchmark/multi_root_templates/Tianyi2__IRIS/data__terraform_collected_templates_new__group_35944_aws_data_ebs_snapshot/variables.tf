variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "most_recent" {
  description = "If more than one result is returned, use the most recent snapshot."
  type        = bool
  default     = null
}

variable "owners" {
  description = "Returns the snapshots owned by the specified owner id. Multiple owners can be specified."
  type        = list(string)
  default     = null

  validation {
    condition = var.owners == null || (
      length(var.owners) > 0 &&
      alltrue([for owner in var.owners : can(regex("^[0-9]{12}$|^self$|^amazon$|^aws-marketplace$", owner))])
    )
    error_message = "data_aws_ebs_snapshot, owners must be valid AWS account IDs (12 digits) or special values 'self', 'amazon', 'aws-marketplace'."
  }
}

variable "snapshot_ids" {
  description = "Returns information on a specific snapshot_id."
  type        = list(string)
  default     = null

  validation {
    condition = var.snapshot_ids == null || (
      length(var.snapshot_ids) > 0 &&
      alltrue([for id in var.snapshot_ids : can(regex("^snap-[0-9a-f]+$", id))])
    )
    error_message = "data_aws_ebs_snapshot, snapshot_ids must be valid snapshot IDs starting with 'snap-'."
  }
}

variable "restorable_by_user_ids" {
  description = "One or more AWS accounts IDs that can create volumes from the snapshot."
  type        = list(string)
  default     = null

  validation {
    condition = var.restorable_by_user_ids == null || (
      length(var.restorable_by_user_ids) > 0 &&
      alltrue([for id in var.restorable_by_user_ids : can(regex("^[0-9]{12}$", id))])
    )
    error_message = "data_aws_ebs_snapshot, restorable_by_user_ids must be valid AWS account IDs (12 digits)."
  }
}

variable "filter" {
  description = "One or more name/value pairs to filter off of."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && length(f.name) > 0 && length(f.values) > 0
    ])
    error_message = "data_aws_ebs_snapshot, filter each filter must have a non-empty name and at least one value."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_ebs_snapshot, timeouts.read must be a valid duration string (e.g., '20m', '1h', '30s')."
  }
}