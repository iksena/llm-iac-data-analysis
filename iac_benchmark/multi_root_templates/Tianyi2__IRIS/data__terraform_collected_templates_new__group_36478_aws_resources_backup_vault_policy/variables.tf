variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "backup_vault_name" {
  description = "Name of the backup vault to add policy for."
  type        = string

  validation {
    condition     = length(var.backup_vault_name) > 0
    error_message = "resource_aws_backup_vault_policy, backup_vault_name must be a non-empty string."
  }
}

variable "policy" {
  description = "The backup vault access policy document in JSON format."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_backup_vault_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_backup_vault_policy, policy must be a non-empty string."
  }
}