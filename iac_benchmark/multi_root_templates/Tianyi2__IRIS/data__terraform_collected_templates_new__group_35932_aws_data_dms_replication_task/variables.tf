variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_dms_replication_task, region must be a valid AWS region format."
  }
}

variable "replication_task_id" {
  description = "The replication task identifier."
  type        = string

  validation {
    condition     = length(var.replication_task_id) > 0
    error_message = "data_aws_dms_replication_task, replication_task_id must not be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.replication_task_id))
    error_message = "data_aws_dms_replication_task, replication_task_id must contain only alphanumeric characters and hyphens."
  }
}