variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "owners" {
  description = "Returns the snapshots owned by the specified owner id. Multiple owners can be specified."
  type        = list(string)
  default     = null
}

variable "restorable_by_user_ids" {
  description = "One or more AWS accounts IDs that can create volumes from the snapshot."
  type        = list(string)
  default     = null
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
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ebs_snapshot_ids, filter: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ebs_snapshot_ids, filter: filter values cannot be empty."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_read))
    error_message = "data_aws_ebs_snapshot_ids, timeouts_read: must be a valid timeout duration (e.g., '20m', '1h', '300s')."
  }
}