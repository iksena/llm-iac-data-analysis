variable "plan_id" {
  description = "Backup plan ID"
  type        = string

  validation {
    condition     = length(var.plan_id) > 0
    error_message = "data_aws_backup_plan, plan_id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_backup_plan, region must be a valid AWS region format or null."
  }
}