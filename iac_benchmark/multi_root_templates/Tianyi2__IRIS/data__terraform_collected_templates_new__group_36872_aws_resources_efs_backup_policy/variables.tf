variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "file_system_id" {
  description = "The ID of the EFS file system."
  type        = string

  validation {
    condition     = can(regex("^fs-[0-9a-f]{8,17}$", var.file_system_id))
    error_message = "resource_aws_efs_backup_policy, file_system_id must be a valid EFS file system ID (e.g., fs-ccfc0d65)."
  }
}

variable "backup_policy_status" {
  description = "A status of the backup policy."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.backup_policy_status)
    error_message = "resource_aws_efs_backup_policy, backup_policy_status must be either 'ENABLED' or 'DISABLED'."
  }
}