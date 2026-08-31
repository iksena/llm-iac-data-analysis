variable "vault_name" {
  description = "The name of the AWS Backup vault"
  type        = string 
  default     = "benchmark-vault"
}

variable "schedule" {
  description = "Cron expression for when to run backup plan"
  type        = string
  default     = "cron(0 5 * * ? *)"
}

variable "start_window" {
  default     = 60
  description = "The start window in minutes for the backup plan"
  type        = number
}

variable "completion_window" {
  default     = 180
  description = "The completion window in minutes for the backup plan"
  type        = number
}

variable "backups_expire_days" {
  description = "Days after the backups are deleted"
  type        = number
  default     = 30
}

variable "min_retention_days" {
  description = "Minimum allowed retention days allowed by the vault lock."
  type        = number
  default     = 7
}

variable "max_retention_days" {
  description = "Maximum allowed retention days allowed by the vault lock."
  type        = number
  default     = 90
}

variable "backup_tag" {
  description = "The key of the tag to use on AWS resources that should be backed up."
  type        = string
  default     = "benchmark-backup"
}
