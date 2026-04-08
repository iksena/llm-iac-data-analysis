variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_backup_report_plan, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "name" {
  description = "Backup report plan name."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_backup_report_plan, name must not be empty."
  }
}