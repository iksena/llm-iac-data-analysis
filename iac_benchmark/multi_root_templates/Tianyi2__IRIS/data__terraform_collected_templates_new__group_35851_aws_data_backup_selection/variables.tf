variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_backup_selection, region must be a valid AWS region identifier."
  }
}

variable "plan_id" {
  description = "Backup plan ID associated with the selection of resources."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.plan_id))
    error_message = "data_aws_backup_selection, plan_id must be a valid backup plan ID."
  }
}

variable "selection_id" {
  description = "Backup selection ID."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.selection_id))
    error_message = "data_aws_backup_selection, selection_id must be a valid backup selection ID."
  }
}