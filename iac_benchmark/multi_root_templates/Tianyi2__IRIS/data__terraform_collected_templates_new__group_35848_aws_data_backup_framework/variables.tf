variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_backup_framework, region must be a valid AWS region identifier."
  }
}

variable "name" {
  description = "Backup framework name."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_backup_framework, name must be a non-empty string."
  }
}