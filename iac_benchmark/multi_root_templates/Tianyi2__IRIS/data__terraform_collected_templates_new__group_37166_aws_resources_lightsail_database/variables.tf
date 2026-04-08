variable "blueprint_id" {
  description = "Blueprint ID for your database. A blueprint describes the major engine version of a database."
  type        = string

  validation {
    condition     = can(regex("^(mysql|postgres)_", var.blueprint_id))
    error_message = "resource_aws_lightsail_database, blueprint_id must start with either 'mysql_' or 'postgres_' prefix."
  }
}

variable "bundle_id" {
  description = "Bundle ID for your database. A bundle describes the performance specifications for your database."
  type        = string

  validation {
    condition     = can(regex("^(micro|small|medium|large)_(ha_)?1_0$", var.bundle_id))
    error_message = "resource_aws_lightsail_database, bundle_id must match the pattern: (micro|small|medium|large)_(ha_)?1_0"
  }
}

variable "master_database_name" {
  description = "Name of the master database created when the Lightsail database resource is created."
  type        = string

  validation {
    condition     = length(var.master_database_name) > 0
    error_message = "resource_aws_lightsail_database, master_database_name cannot be empty."
  }
}

variable "master_password" {
  description = "Password for the master user of your database. The password can include any printable ASCII character except \"/\", \"\\\", or \"@\"."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.master_password) > 0 && !can(regex("[/\\\\@]", var.master_password))
    error_message = "resource_aws_lightsail_database, master_password cannot be empty and cannot contain \"/\", \"\\\", or \"@\" characters."
  }
}

variable "master_username" {
  description = "Master user name for your database."
  type        = string

  validation {
    condition     = length(var.master_username) > 0
    error_message = "resource_aws_lightsail_database, master_username cannot be empty."
  }
}

variable "relational_database_name" {
  description = "Name to use for your Lightsail database resource. Names be unique within each AWS Region in your Lightsail account."
  type        = string

  validation {
    condition     = length(var.relational_database_name) > 0
    error_message = "resource_aws_lightsail_database, relational_database_name cannot be empty."
  }
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately. When false, applies changes during the preferred maintenance window. Some changes may cause an outage."
  type        = bool
  default     = null
}

variable "availability_zone" {
  description = "Availability Zone in which to create your database. Use the us-east-2a case-sensitive format."
  type        = string
  default     = null

  validation {
    condition     = var.availability_zone == null || can(regex("^[a-z]+-[a-z]+-[0-9]+[a-z]$", var.availability_zone))
    error_message = "resource_aws_lightsail_database, availability_zone must be in the format us-east-2a (region-direction-number-letter)."
  }
}

variable "backup_retention_enabled" {
  description = "Whether to enable automated backup retention for your database. When false, disables automated backup retention for your database."
  type        = bool
  default     = null
}

variable "final_snapshot_name" {
  description = "Name of the database snapshot created if skip final snapshot is false, which is the default value for that parameter."
  type        = string
  default     = null

  validation {
    condition     = var.final_snapshot_name == null || length(var.final_snapshot_name) > 0
    error_message = "resource_aws_lightsail_database, final_snapshot_name cannot be empty when specified."
  }
}

variable "preferred_backup_window" {
  description = "Daily time range during which automated backups are created for your database if automated backups are enabled. Must be in the hh24:mi-hh24:mi format."
  type        = string
  default     = null

  validation {
    condition     = var.preferred_backup_window == null || can(regex("^[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]$", var.preferred_backup_window))
    error_message = "resource_aws_lightsail_database, preferred_backup_window must be in the format hh24:mi-hh24:mi (e.g., 16:00-16:30)."
  }
}

variable "preferred_maintenance_window" {
  description = "Weekly time range during which system maintenance can occur on your database. Must be in the ddd:hh24:mi-ddd:hh24:mi format."
  type        = string
  default     = null

  validation {
    condition     = var.preferred_maintenance_window == null || can(regex("^(Mon|Tue|Wed|Thu|Fri|Sat|Sun):[0-2][0-9]:[0-5][0-9]-(Mon|Tue|Wed|Thu|Fri|Sat|Sun):[0-2][0-9]:[0-5][0-9]$", var.preferred_maintenance_window))
    error_message = "resource_aws_lightsail_database, preferred_maintenance_window must be in the format ddd:hh24:mi-ddd:hh24:mi (e.g., Tue:17:00-Tue:17:30)."
  }
}

variable "publicly_accessible" {
  description = "Whether the database is accessible to resources outside of your Lightsail account."
  type        = bool
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Whether a final database snapshot is created before your database is deleted. If true is specified, no database snapshot is created."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. To create a key-only tag, use an empty string as the value."
  type        = map(string)
  default     = null
}