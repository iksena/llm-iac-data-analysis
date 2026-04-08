variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "snapshot_id" {
  description = "A snapshot ID"
  type        = string

  validation {
    condition     = can(regex("^snap-[0-9a-f]{8,17}$", var.snapshot_id))
    error_message = "resource_aws_snapshot_create_volume_permission, snapshot_id must be a valid EBS snapshot ID starting with 'snap-'."
  }
}

variable "account_id" {
  description = "An AWS Account ID to add create volume permissions. The AWS Account cannot be the snapshot's owner"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_snapshot_create_volume_permission, account_id must be a valid 12-digit AWS Account ID."
  }
}