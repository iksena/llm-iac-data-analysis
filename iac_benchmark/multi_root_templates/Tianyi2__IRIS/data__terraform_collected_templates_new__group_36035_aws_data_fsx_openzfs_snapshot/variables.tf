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

variable "snapshot_ids" {
  description = "Returns information on a specific snapshot_id."
  type        = list(string)
  default     = null

  validation {
    condition = var.snapshot_ids == null || (
      var.snapshot_ids != null && length(var.snapshot_ids) > 0 && alltrue([
        for id in var.snapshot_ids : can(regex("^fsvolsnap-[a-z0-9]+$", id))
      ])
    )
    error_message = "data_aws_fsx_openzfs_snapshot, snapshot_ids must be valid FSx OpenZFS snapshot IDs starting with 'fsvolsnap-'."
  }
}

variable "filters" {
  description = "One or more name/value pairs to filter off of. The supported names are file-system-id or volume-id."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : contains(["file-system-id", "volume-id"], filter.name)
    ])
    error_message = "data_aws_fsx_openzfs_snapshot, filters name must be either 'file-system-id' or 'volume-id'."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_fsx_openzfs_snapshot, filters values cannot be empty."
  }
}