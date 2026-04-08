variable "source_db_cluster_snapshot_identifier" {
  description = "Identifier of the source snapshot"
  type        = string

  validation {
    condition     = length(var.source_db_cluster_snapshot_identifier) > 0
    error_message = "resource_aws_rds_cluster_snapshot_copy, source_db_cluster_snapshot_identifier must not be empty."
  }
}

variable "target_db_cluster_snapshot_identifier" {
  description = "Identifier for the snapshot"
  type        = string

  validation {
    condition     = length(var.target_db_cluster_snapshot_identifier) > 0
    error_message = "resource_aws_rds_cluster_snapshot_copy, target_db_cluster_snapshot_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "copy_tags" {
  description = "Whether to copy existing tags. Defaults to false"
  type        = bool
  default     = false
}

variable "destination_region" {
  description = "The Destination region to place snapshot copy"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key ID"
  type        = string
  default     = null
}

variable "presigned_url" {
  description = "URL that contains a Signature Version 4 signed request"
  type        = string
  default     = null

  validation {
    condition     = var.presigned_url == null || can(regex("^https?://", var.presigned_url))
    error_message = "resource_aws_rds_cluster_snapshot_copy, presigned_url must be a valid URL starting with http or https."
  }
}

variable "shared_accounts" {
  description = "List of AWS Account IDs to share the snapshot with. Use 'all' to make the snapshot public"
  type        = list(string)
  default     = null

  validation {
    condition = var.shared_accounts == null || alltrue([
      for account in var.shared_accounts :
      account == "all" || can(regex("^[0-9]{12}$", account))
    ])
    error_message = "resource_aws_rds_cluster_snapshot_copy, shared_accounts must contain valid 12-digit AWS Account IDs or 'all'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Timeouts for the resource operations"
  type = object({
    create = optional(string, "20m")
  })
  default = {}
}