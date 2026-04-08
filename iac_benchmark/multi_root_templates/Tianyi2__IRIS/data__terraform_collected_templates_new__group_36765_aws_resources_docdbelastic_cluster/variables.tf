variable "admin_user_name" {
  description = "Name of the Elastic DocumentDB cluster administrator"
  type        = string

  validation {
    condition     = length(var.admin_user_name) > 0
    error_message = "resource_aws_docdbelastic_cluster, admin_user_name must not be empty."
  }
}

variable "admin_user_password" {
  description = "Password for the Elastic DocumentDB cluster administrator. Can contain any printable ASCII characters. Must be at least 8 characters"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.admin_user_password) >= 8
    error_message = "resource_aws_docdbelastic_cluster, admin_user_password must be at least 8 characters long."
  }
}

variable "auth_type" {
  description = "Authentication type for the Elastic DocumentDB cluster. Valid values are PLAIN_TEXT and SECRET_ARN"
  type        = string

  validation {
    condition     = contains(["PLAIN_TEXT", "SECRET_ARN"], var.auth_type)
    error_message = "resource_aws_docdbelastic_cluster, auth_type must be either 'PLAIN_TEXT' or 'SECRET_ARN'."
  }
}

variable "name" {
  description = "Name of the Elastic DocumentDB cluster"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_docdbelastic_cluster, name must not be empty."
  }
}

variable "shard_capacity" {
  description = "Number of vCPUs assigned to each elastic cluster shard. Maximum is 64. Allowed values are 2, 4, 8, 16, 32, 64"
  type        = number

  validation {
    condition     = contains([2, 4, 8, 16, 32, 64], var.shard_capacity)
    error_message = "resource_aws_docdbelastic_cluster, shard_capacity must be one of: 2, 4, 8, 16, 32, 64."
  }
}

variable "shard_count" {
  description = "Number of shards assigned to the elastic cluster. Maximum is 32"
  type        = number

  validation {
    condition     = var.shard_count >= 1 && var.shard_count <= 32
    error_message = "resource_aws_docdbelastic_cluster, shard_count must be between 1 and 32."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The number of days for which automatic snapshots are retained. It should be in between 1 and 35. If not specified, the default value of 1 is set"
  type        = number
  default     = null

  validation {
    condition     = var.backup_retention_period == null || (var.backup_retention_period >= 1 && var.backup_retention_period <= 35)
    error_message = "resource_aws_docdbelastic_cluster, backup_retention_period must be between 1 and 35."
  }
}

variable "kms_key_id" {
  description = "ARN of a KMS key that is used to encrypt the Elastic DocumentDB cluster. If not specified, the default encryption key that KMS creates for your account is used"
  type        = string
  default     = null
}

variable "preferred_backup_window" {
  description = "The daily time range during which automated backups are created if automated backups are enabled, as determined by the backup_retention_period"
  type        = string
  default     = null
}

variable "preferred_maintenance_window" {
  description = "Weekly time range during which system maintenance can occur in UTC. Format: ddd:hh24:mi-ddd:hh24:mi. If not specified, AWS will choose a random 30-minute window on a random day of the week"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "IDs of subnets in which the Elastic DocumentDB Cluster operates"
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the collection. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate with the Elastic DocumentDB Cluster"
  type        = list(string)
  default     = null
}