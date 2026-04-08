variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_backup_vault_lock_configuration, region must be a valid AWS region identifier."
  }
}

variable "backup_vault_name" {
  description = "Name of the backup vault to add a lock configuration for."
  type        = string

  validation {
    condition     = length(var.backup_vault_name) >= 1 && length(var.backup_vault_name) <= 50
    error_message = "resource_aws_backup_vault_lock_configuration, backup_vault_name must be between 1 and 50 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-_\\.]+$", var.backup_vault_name))
    error_message = "resource_aws_backup_vault_lock_configuration, backup_vault_name can only contain alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "changeable_for_days" {
  description = "The number of days before the lock date. If omitted creates a vault lock in governance mode, otherwise it will create a vault lock in compliance mode."
  type        = number
  default     = null

  validation {
    condition     = var.changeable_for_days == null || (var.changeable_for_days >= 3 && var.changeable_for_days <= 36500)
    error_message = "resource_aws_backup_vault_lock_configuration, changeable_for_days must be between 3 and 36500 days when specified."
  }
}

variable "max_retention_days" {
  description = "The maximum retention period that the vault retains its recovery points."
  type        = number
  default     = null

  validation {
    condition     = var.max_retention_days == null || (var.max_retention_days >= 1 && var.max_retention_days <= 36500)
    error_message = "resource_aws_backup_vault_lock_configuration, max_retention_days must be between 1 and 36500 days when specified."
  }
}

variable "min_retention_days" {
  description = "The minimum retention period that the vault retains its recovery points."
  type        = number
  default     = null

  validation {
    condition     = var.min_retention_days == null || (var.min_retention_days >= 1 && var.min_retention_days <= 36500)
    error_message = "resource_aws_backup_vault_lock_configuration, min_retention_days must be between 1 and 36500 days when specified."
  }
}

variable "min_max_retention_validation" {
  description = "Validation to ensure min_retention_days is less than or equal to max_retention_days when both are specified."
  type        = bool
  default     = true
}