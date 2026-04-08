variable "source_db_instance_arn" {
  description = "The Amazon Resource Name (ARN) of the source DB instance for the replicated automated backups"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:rds:[^:]+:[0-9]{12}:db:.+$", var.source_db_instance_arn))
    error_message = "resource_aws_db_instance_automated_backups_replication, source_db_instance_arn must be a valid RDS DB instance ARN in the format 'arn:aws:rds:region:account-id:db:db-instance-identifier'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The AWS KMS key identifier for encryption of the replicated automated backups. The KMS key ID is the Amazon Resource Name (ARN) for the KMS encryption key in the destination AWS Region"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^arn:aws:kms:[^:]+:[0-9]{12}:key/[a-f0-9-]+$", var.kms_key_id))
    error_message = "resource_aws_db_instance_automated_backups_replication, kms_key_id must be a valid KMS key ARN in the format 'arn:aws:kms:region:account-id:key/key-id' or null."
  }
}

variable "pre_signed_url" {
  description = "A URL that contains a Signature Version 4 signed request for the StartDBInstanceAutomatedBackupsReplication action to be called in the AWS Region of the source DB instance"
  type        = string
  default     = null

  validation {
    condition     = var.pre_signed_url == null || can(regex("^https://", var.pre_signed_url))
    error_message = "resource_aws_db_instance_automated_backups_replication, pre_signed_url must be a valid HTTPS URL or null."
  }
}

variable "retention_period" {
  description = "The retention period for the replicated automated backups"
  type        = number
  default     = 7

  validation {
    condition     = var.retention_period >= 1 && var.retention_period <= 35
    error_message = "resource_aws_db_instance_automated_backups_replication, retention_period must be between 1 and 35 days."
  }
}

variable "timeouts" {
  description = "Configuration block for timeouts"
  type = object({
    create = optional(string, "75m")
    delete = optional(string, "75m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      (var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))) &&
      (var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete)))
    )
    error_message = "resource_aws_db_instance_automated_backups_replication, timeouts must be valid duration strings (e.g., '75m', '2h', '30s') or null."
  }
}