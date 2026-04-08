variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_elasticache_replication_group, region must be a valid AWS region name or null."
  }
}

variable "replication_group_id" {
  description = "Identifier for the replication group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.replication_group_id))
    error_message = "data_aws_elasticache_replication_group, replication_group_id must start with a letter and contain only alphanumeric characters and hyphens."
  }
}