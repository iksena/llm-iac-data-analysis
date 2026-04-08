variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "compute_redundancy" {
  description = "Specifies whether to create standby DB shard groups for the DB shard group. Valid values are 0, 1, or 2."
  type        = number
  default     = 0
  validation {
    condition     = can(regex("^[0-2]$", tostring(var.compute_redundancy)))
    error_message = "resource_aws_rds_shard_group, compute_redundancy must be 0, 1, or 2."
  }
}

variable "db_cluster_identifier" {
  description = "The name of the primary DB cluster for the DB shard group."
  type        = string
  validation {
    condition     = length(var.db_cluster_identifier) > 0
    error_message = "resource_aws_rds_shard_group, db_cluster_identifier cannot be empty."
  }
}

variable "db_shard_group_identifier" {
  description = "The name of the DB shard group."
  type        = string
  validation {
    condition     = length(var.db_shard_group_identifier) > 0
    error_message = "resource_aws_rds_shard_group, db_shard_group_identifier cannot be empty."
  }
}

variable "max_acu" {
  description = "The maximum capacity of the DB shard group in Aurora capacity units (ACUs)."
  type        = number
  validation {
    condition     = var.max_acu > 0
    error_message = "resource_aws_rds_shard_group, max_acu must be greater than 0."
  }
}

variable "min_acu" {
  description = "The minimum capacity of the DB shard group in Aurora capacity units (ACUs)."
  type        = number
  default     = null
  validation {
    condition     = var.min_acu == null || var.min_acu >= 0
    error_message = "resource_aws_rds_shard_group, min_acu must be greater than or equal to 0 when specified."
  }
}

variable "publicly_accessible" {
  description = "Indicates whether the DB shard group is publicly accessible."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for creating the DB shard group."
  type        = string
  default     = "45m"
}

variable "update_timeout" {
  description = "Timeout for updating the DB shard group."
  type        = string
  default     = "45m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the DB shard group."
  type        = string
  default     = "45m"
}