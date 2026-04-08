variable "description" {
  description = "User-created description for the replication group. Must not be empty."
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_elasticache_replication_group, description must not be empty."
  }
}

variable "replication_group_id" {
  description = "Replication group identifier. This parameter is stored as a lowercase string."
  type        = string

  validation {
    condition     = length(var.replication_group_id) > 0
    error_message = "resource_aws_elasticache_replication_group, replication_group_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Whether to enable encryption at rest. When engine is redis, default is false. When engine is valkey, default is true."
  type        = bool
  default     = null
}

variable "auth_token" {
  description = "Password used to access a password protected server. Can be specified only if transit_encryption_enabled = true."
  type        = string
  default     = null
  sensitive   = true
}

variable "auth_token_update_strategy" {
  description = "Strategy to use when updating the auth_token. Valid values are SET, ROTATE, and DELETE. Required if auth_token is set."
  type        = string
  default     = null

  validation {
    condition     = var.auth_token_update_strategy == null || contains(["SET", "ROTATE", "DELETE"], var.auth_token_update_strategy)
    error_message = "resource_aws_elasticache_replication_group, auth_token_update_strategy must be one of: SET, ROTATE, DELETE."
  }
}

variable "auto_minor_version_upgrade" {
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported for engine types redis and valkey and if the engine version is 6 or higher. Defaults to true."
  type        = bool
  default     = true
}

variable "automatic_failover_enabled" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, num_cache_clusters must be greater than 1. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false."
  type        = bool
  default     = false
}

variable "cluster_mode" {
  description = "Specifies whether cluster mode is enabled or disabled. Valid values are enabled or disabled or compatible."
  type        = string
  default     = null

  validation {
    condition     = var.cluster_mode == null || contains(["enabled", "disabled", "compatible"], var.cluster_mode)
    error_message = "resource_aws_elasticache_replication_group, cluster_mode must be one of: enabled, disabled, compatible."
  }
}

variable "data_tiering_enabled" {
  description = "Enables data tiering. Data tiering is only supported for replication groups using the r6gd node type. This parameter must be set to true when using r6gd nodes."
  type        = bool
  default     = null
}

variable "engine" {
  description = "Name of the cache engine to be used for the clusters in this replication group. Valid values are redis or valkey. Default is redis."
  type        = string
  default     = "redis"

  validation {
    condition     = contains(["redis", "valkey"], var.engine)
    error_message = "resource_aws_elasticache_replication_group, engine must be one of: redis, valkey."
  }
}

variable "engine_version" {
  description = "Version number of the cache engine to be used for the cache clusters in this replication group. If the version is 7 or higher, the major and minor version should be set, e.g., 7.2. If the version is 6, the major and minor version can be set, e.g., 6.2, or the minor version can be unspecified which will use the latest version at creation time, e.g., 6.x. Otherwise, specify the full version desired, e.g., 5.0.6."
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made."
  type        = string
  default     = null
}

variable "global_replication_group_id" {
  description = "The ID of the global replication group to which this replication group should belong. If this parameter is specified, the replication group is added to the specified global replication group as a secondary replication group; otherwise, the replication group is not part of any global replication group. If global_replication_group_id is set, the num_node_groups parameter cannot be set."
  type        = string
  default     = null
}

variable "ip_discovery" {
  description = "The IP version to advertise in the discovery protocol. Valid values are ipv4 or ipv6."
  type        = string
  default     = null

  validation {
    condition     = var.ip_discovery == null || contains(["ipv4", "ipv6"], var.ip_discovery)
    error_message = "resource_aws_elasticache_replication_group, ip_discovery must be one of: ipv4, ipv6."
  }
}

variable "kms_key_id" {
  description = "The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at_rest_encryption_enabled = true."
  type        = string
  default     = null
}

variable "log_delivery_configuration" {
  description = "Specifies the destination and format of Redis OSS/Valkey SLOWLOG or Redis OSS/Valkey Engine Log. See Log Delivery Configuration."
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration : contains(["cloudwatch-logs", "kinesis-firehose"], config.destination_type)
    ])
    error_message = "resource_aws_elasticache_replication_group, log_delivery_configuration destination_type must be one of: cloudwatch-logs, kinesis-firehose."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration : contains(["json", "text"], config.log_format)
    ])
    error_message = "resource_aws_elasticache_replication_group, log_delivery_configuration log_format must be one of: json, text."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration : contains(["slow-log", "engine-log"], config.log_type)
    ])
    error_message = "resource_aws_elasticache_replication_group, log_delivery_configuration log_type must be one of: slow-log, engine-log."
  }

  validation {
    condition     = length(var.log_delivery_configuration) <= 2
    error_message = "resource_aws_elasticache_replication_group, log_delivery_configuration maximum of 2 blocks allowed."
  }
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period. Example: sun:05:00-sun:09:00"
  type        = string
  default     = null

  validation {
    condition     = var.maintenance_window == null || can(regex("^(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]-(sun|mon|tue|wed|thu|fri|sat):[0-2][0-9]:[0-5][0-9]$", var.maintenance_window))
    error_message = "resource_aws_elasticache_replication_group, maintenance_window must be in the format ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC)."
  }
}

variable "multi_az_enabled" {
  description = "Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic_failover_enabled must also be enabled. Defaults to false."
  type        = bool
  default     = false
}

variable "network_type" {
  description = "The IP versions for cache cluster connections. Valid values are ipv4, ipv6 or dual_stack."
  type        = string
  default     = null

  validation {
    condition     = var.network_type == null || contains(["ipv4", "ipv6", "dual_stack"], var.network_type)
    error_message = "resource_aws_elasticache_replication_group, network_type must be one of: ipv4, ipv6, dual_stack."
  }
}

variable "node_type" {
  description = "Instance class to be used. See AWS documentation for information on supported node types and guidance on selecting node types. Required unless global_replication_group_id is set. Cannot be set if global_replication_group_id is set."
  type        = string
  default     = null
}

variable "notification_topic_arn" {
  description = "ARN of an SNS topic to send ElastiCache notifications to. Example: arn:aws:sns:us-east-1:012345678999:my_sns_topic"
  type        = string
  default     = null

  validation {
    condition     = var.notification_topic_arn == null || can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9_-]+$", var.notification_topic_arn))
    error_message = "resource_aws_elasticache_replication_group, notification_topic_arn must be a valid SNS topic ARN."
  }
}

variable "num_cache_clusters" {
  description = "Number of cache clusters (primary and replicas) this replication group will have. If automatic_failover_enabled or multi_az_enabled are true, must be at least 2. Updates will occur before other modifications. Conflicts with num_node_groups and replicas_per_node_group. Defaults to 1."
  type        = number
  default     = 1

  validation {
    condition     = var.num_cache_clusters > 0
    error_message = "resource_aws_elasticache_replication_group, num_cache_clusters must be greater than 0."
  }
}

variable "num_node_groups" {
  description = "Number of node groups (shards) for this Redis replication group. Changing this number will trigger a resizing operation before other settings modifications. Conflicts with num_cache_clusters."
  type        = number
  default     = null

  validation {
    condition     = var.num_node_groups == null || var.num_node_groups > 0
    error_message = "resource_aws_elasticache_replication_group, num_node_groups must be greater than 0."
  }
}

variable "parameter_group_name" {
  description = "Name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used. To enable cluster mode, i.e., data sharding, use a parameter group that has the parameter cluster-enabled set to true."
  type        = string
  default     = null
}

variable "port" {
  description = "Port number on which each of the cache nodes will accept connections. For Memcache the default is 11211, and for Redis the default port is 6379."
  type        = number
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "resource_aws_elasticache_replication_group, port must be between 1 and 65535."
  }
}

variable "preferred_cache_cluster_azs" {
  description = "List of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is considered. The first item in the list will be the primary node. Ignored when updating."
  type        = list(string)
  default     = null
}

variable "replicas_per_node_group" {
  description = "Number of replica nodes in each node group. Changing this number will trigger a resizing operation before other settings modifications. Valid values are 0 to 5. Conflicts with num_cache_clusters. Can only be set if num_node_groups is set."
  type        = number
  default     = null

  validation {
    condition     = var.replicas_per_node_group == null || (var.replicas_per_node_group >= 0 && var.replicas_per_node_group <= 5)
    error_message = "resource_aws_elasticache_replication_group, replicas_per_node_group must be between 0 and 5."
  }
}

variable "security_group_ids" {
  description = "IDs of one or more Amazon VPC security groups associated with this replication group. Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud."
  type        = list(string)
  default     = null
}

variable "security_group_names" {
  description = "Names of one or more Amazon VPC security groups associated with this replication group. Use this parameter only when you are creating a replication group in an Amazon Virtual Private Cloud."
  type        = list(string)
  default     = null
}

variable "snapshot_arns" {
  description = "List of ARNs that identify Redis RDB snapshot files stored in Amazon S3. The names object names cannot contain any commas."
  type        = list(string)
  default     = null

  validation {
    condition = var.snapshot_arns == null || alltrue([
      for arn in var.snapshot_arns : can(regex("^arn:aws:s3:::[^,]+$", arn))
    ])
    error_message = "resource_aws_elasticache_replication_group, snapshot_arns must be valid S3 ARNs and cannot contain commas."
  }
}

variable "snapshot_name" {
  description = "Name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of snapshot_retention_limit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro cache nodes"
  type        = number
  default     = null

  validation {
    condition     = var.snapshot_retention_limit == null || var.snapshot_retention_limit >= 0
    error_message = "resource_aws_elasticache_replication_group, snapshot_retention_limit must be greater than or equal to 0."
  }
}

variable "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. Example: 05:00-09:00"
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_window == null || can(regex("^[0-2][0-9]:[0-5][0-9]-[0-2][0-9]:[0-5][0-9]$", var.snapshot_window))
    error_message = "resource_aws_elasticache_replication_group, snapshot_window must be in the format hh24:mi-hh24:mi (24H Clock UTC)."
  }
}

variable "subnet_group_name" {
  description = "Name of the cache subnet group to be used for the replication group."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. Adding tags to this resource will add or overwrite any existing tags on the clusters in the replication group and not to the group itself."
  type        = map(string)
  default     = {}
}

variable "transit_encryption_enabled" {
  description = "Whether to enable encryption in transit. Changing this argument with an engine_version < 7.0.5 will force a replacement. Engine versions prior to 7.0.5 only allow this transit encryption to be configured during creation of the replication group."
  type        = bool
  default     = null
}

variable "transit_encryption_mode" {
  description = "A setting that enables clients to migrate to in-transit encryption with no downtime. Valid values are preferred and required. When enabling encryption on an existing replication group, this must first be set to preferred before setting it to required in a subsequent apply."
  type        = string
  default     = null

  validation {
    condition     = var.transit_encryption_mode == null || contains(["preferred", "required"], var.transit_encryption_mode)
    error_message = "resource_aws_elasticache_replication_group, transit_encryption_mode must be one of: preferred, required."
  }
}

variable "user_group_ids" {
  description = "User Group ID to associate with the replication group. Only a maximum of one (1) user group ID is valid. NOTE: This argument is a set because the AWS specification allows for multiple IDs. However, in practice, AWS only allows a maximum size of one."
  type        = set(string)
  default     = null

  validation {
    condition     = var.user_group_ids == null || length(var.user_group_ids) <= 1
    error_message = "resource_aws_elasticache_replication_group, user_group_ids maximum of one (1) user group ID is valid."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "60m")
    delete = optional(string, "45m")
    update = optional(string, "40m")
  })
  default = {}
}