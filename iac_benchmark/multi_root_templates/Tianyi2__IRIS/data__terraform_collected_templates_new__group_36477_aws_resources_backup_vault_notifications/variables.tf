variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "backup_vault_name" {
  description = "Name of the backup vault to add notifications for."
  type        = string

  validation {
    condition     = length(var.backup_vault_name) > 0
    error_message = "resource_aws_backup_vault_notifications, backup_vault_name must not be empty."
  }
}

variable "sns_topic_arn" {
  description = "The Amazon Resource Name (ARN) that specifies the topic for a backup vault's events."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sns:", var.sns_topic_arn))
    error_message = "resource_aws_backup_vault_notifications, sns_topic_arn must be a valid SNS topic ARN starting with 'arn:aws:sns:'."
  }
}

variable "backup_vault_events" {
  description = "An array of events that indicate the status of jobs to back up resources to the backup vault."
  type        = list(string)

  validation {
    condition     = length(var.backup_vault_events) > 0
    error_message = "resource_aws_backup_vault_notifications, backup_vault_events must contain at least one event."
  }

  validation {
    condition = alltrue([
      for event in var.backup_vault_events : contains([
        "BACKUP_JOB_STARTED",
        "BACKUP_JOB_COMPLETED",
        "BACKUP_JOB_SUCCESSFUL",
        "BACKUP_JOB_FAILED",
        "BACKUP_JOB_EXPIRED",
        "RESTORE_JOB_STARTED",
        "RESTORE_JOB_COMPLETED",
        "RESTORE_JOB_SUCCESSFUL",
        "RESTORE_JOB_FAILED",
        "COPY_JOB_STARTED",
        "COPY_JOB_SUCCESSFUL",
        "COPY_JOB_FAILED",
        "RECOVERY_POINT_MODIFIED",
        "BACKUP_PLAN_CREATED",
        "BACKUP_PLAN_MODIFIED"
      ], event)
    ])
    error_message = "resource_aws_backup_vault_notifications, backup_vault_events must contain valid AWS Backup event types."
  }
}