variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "A boolean that indicates that all recovery points stored in the vault are deleted so that the vault can be destroyed without error."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "The server-side encryption key that is used to protect your backups."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_backup_vault, kms_key_arn must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "name" {
  description = "Name of the backup vault to create."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 50
    error_message = "resource_aws_backup_vault, name must be between 1 and 50 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\-_\\.]+$", var.name))
    error_message = "resource_aws_backup_vault, name can only contain alphanumeric characters, hyphens, underscores, and periods."
  }
}

variable "tags" {
  description = "Metadata that you can assign to help organize the resources that you create."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 128 && length(v) <= 256
    ])
    error_message = "resource_aws_backup_vault, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}