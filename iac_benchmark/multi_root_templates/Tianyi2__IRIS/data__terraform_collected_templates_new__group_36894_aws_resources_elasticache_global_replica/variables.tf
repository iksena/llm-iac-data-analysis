variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "automatic_failover_enabled" {
  description = "Specifies whether read-only replicas will be automatically promoted to read/write primary if the existing primary fails."
  type        = bool
  default     = null
}

variable "cache_node_type" {
  description = "The instance class used. When creating, by default the Global Replication Group inherits the node type of the primary replication group."
  type        = string
  default     = null
}

variable "engine" {
  description = "The name of the cache engine to be used for the clusters in this global replication group. Valid values are 'redis' or 'valkey'."
  type        = string
  default     = null

  validation {
    condition     = var.engine == null || contains(["redis", "valkey"], var.engine)
    error_message = "resource_aws_elasticache_global_replication_group, engine must be either 'redis' or 'valkey'."
  }
}

variable "engine_version" {
  description = "Engine version to use for the Global Replication Group. When the version is 7 or higher, the major and minor version should be set (e.g., '7.2'). When the version is 6, the major and minor version can be set (e.g., '6.2'), or the minor version can be unspecified (e.g., '6.x')."
  type        = string
  default     = null
}

variable "global_replication_group_id_suffix" {
  description = "The suffix name of a Global Datastore. If global_replication_group_id_suffix is changed, creates a new resource."
  type        = string

  validation {
    condition     = var.global_replication_group_id_suffix != null && length(var.global_replication_group_id_suffix) > 0
    error_message = "resource_aws_elasticache_global_replication_group, global_replication_group_id_suffix is required and cannot be empty."
  }
}

variable "primary_replication_group_id" {
  description = "The ID of the primary cluster that accepts writes and will replicate updates to the secondary cluster. If primary_replication_group_id is changed, creates a new resource."
  type        = string

  validation {
    condition     = var.primary_replication_group_id != null && length(var.primary_replication_group_id) > 0
    error_message = "resource_aws_elasticache_global_replication_group, primary_replication_group_id is required and cannot be empty."
  }
}

variable "global_replication_group_description" {
  description = "A user-created description for the global replication group."
  type        = string
  default     = null
}

variable "num_node_groups" {
  description = "The number of node groups (shards) on the global replication group."
  type        = number
  default     = null

  validation {
    condition     = var.num_node_groups == null || var.num_node_groups > 0
    error_message = "resource_aws_elasticache_global_replication_group, num_node_groups must be greater than 0."
  }
}

variable "parameter_group_name" {
  description = "An ElastiCache Parameter Group to use for the Global Replication Group. Required when upgrading an engine or major engine version."
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null
}