variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "most_recent" {
  description = "If more than one result is returned, use the most recent Snapshot"
  type        = bool
  default     = null
}

variable "db_instance_identifier" {
  description = "Returns the list of snapshots created by the specific db_instance"
  type        = string
  default     = null
}

variable "db_snapshot_identifier" {
  description = "Returns information on a specific snapshot_id"
  type        = string
  default     = null
}

variable "snapshot_type" {
  description = "Type of snapshots to be returned"
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_type == null || contains(["automated", "manual", "shared", "public", "awsbackup"], var.snapshot_type)
    error_message = "data_aws_db_snapshot, snapshot_type must be one of: automated, manual, shared, public, awsbackup."
  }
}

variable "include_shared" {
  description = "Set this value to true to include shared manual DB snapshots from other AWS accounts"
  type        = bool
  default     = false
}

variable "include_public" {
  description = "Set this value to true to include manual DB snapshots that are public and can be copied or restored by any AWS account"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mapping of tags, each pair of which must exactly match a pair on the desired DB snapshot"
  type        = map(string)
  default     = {}
}