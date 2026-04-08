variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "complete_lock" {
  description = "Boolean whether to permanently apply this Glacier Lock Policy. Once completed, this cannot be undone. If set to false, the Glacier Lock Policy remains in a testing mode for 24 hours."
  type        = bool

  validation {
    condition     = var.complete_lock != null
    error_message = "resource_aws_glacier_vault_lock, complete_lock is required and cannot be null."
  }
}

variable "policy" {
  description = "JSON string containing the IAM policy to apply as the Glacier Vault Lock policy."
  type        = string

  validation {
    condition     = var.policy != null && var.policy != ""
    error_message = "resource_aws_glacier_vault_lock, policy is required and cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_glacier_vault_lock, policy must be a valid JSON string."
  }
}

variable "vault_name" {
  description = "The name of the Glacier Vault."
  type        = string

  validation {
    condition     = var.vault_name != null && var.vault_name != ""
    error_message = "resource_aws_glacier_vault_lock, vault_name is required and cannot be empty."
  }

  validation {
    condition     = length(var.vault_name) >= 1 && length(var.vault_name) <= 255
    error_message = "resource_aws_glacier_vault_lock, vault_name must be between 1 and 255 characters in length."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.vault_name))
    error_message = "resource_aws_glacier_vault_lock, vault_name can only contain alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "ignore_deletion_error" {
  description = "Allow Terraform to ignore the error returned when attempting to delete the Glacier Lock Policy. This can be used to delete or recreate the Glacier Vault via Terraform."
  type        = bool
  default     = null
}