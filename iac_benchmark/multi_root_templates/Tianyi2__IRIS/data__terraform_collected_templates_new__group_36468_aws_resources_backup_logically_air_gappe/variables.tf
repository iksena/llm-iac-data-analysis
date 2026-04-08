variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Logically Air Gapped Backup Vault to create"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_backup_logically_air_gapped_vault, name cannot be empty."
  }
}

variable "max_retention_days" {
  description = "Maximum retention period that the Logically Air Gapped Backup Vault retains recovery points"
  type        = number

  validation {
    condition     = var.max_retention_days > 0
    error_message = "resource_aws_backup_logically_air_gapped_vault, max_retention_days must be greater than 0."
  }
}

variable "min_retention_days" {
  description = "Minimum retention period that the Logically Air Gapped Backup Vault retains recovery points"
  type        = number

  validation {
    condition     = var.min_retention_days > 0
    error_message = "resource_aws_backup_logically_air_gapped_vault, min_retention_days must be greater than 0."
  }
}

variable "tags" {
  description = "Metadata that you can assign to help organize the resources that you create"
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the Logically Air Gapped Backup Vault"
  type        = string
  default     = "30m"
}