variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "copy_tags" {
  description = "Whether to copy existing tags. Defaults to false."
  type        = bool
  default     = false
}

variable "destination_region" {
  description = "The Destination region to place snapshot copy."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key ID."
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "The name of an option group to associate with the copy of the snapshot."
  type        = string
  default     = null
}

variable "presigned_url" {
  description = "The URL that contains a Signature Version 4 signed request."
  type        = string
  default     = null
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
    error_message = "resource_aws_db_snapshot_copy, shared_accounts must be either 'all' or a list of 12-digit AWS Account IDs."
  }
}

variable "source_db_snapshot_identifier" {
  description = "Snapshot identifier of the source snapshot."
  type        = string

  validation {
    condition     = length(var.source_db_snapshot_identifier) > 0
    error_message = "resource_aws_db_snapshot_copy, source_db_snapshot_identifier cannot be empty."
  }
}

variable "target_custom_availability_zone" {
  description = "The external custom Availability Zone."
  type        = string
  default     = null
}

variable "target_db_snapshot_identifier" {
  description = "The Identifier for the snapshot."
  type        = string

  validation {
    condition     = length(var.target_db_snapshot_identifier) > 0
    error_message = "resource_aws_db_snapshot_copy, target_db_snapshot_identifier cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.target_db_snapshot_identifier))
    error_message = "resource_aws_db_snapshot_copy, target_db_snapshot_identifier must contain only alphanumeric characters and hyphens."
  }

  validation {
    condition     = length(var.target_db_snapshot_identifier) <= 255
    error_message = "resource_aws_db_snapshot_copy, target_db_snapshot_identifier must be 255 characters or less."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the DB snapshot copy."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_db_snapshot_copy, create_timeout must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}