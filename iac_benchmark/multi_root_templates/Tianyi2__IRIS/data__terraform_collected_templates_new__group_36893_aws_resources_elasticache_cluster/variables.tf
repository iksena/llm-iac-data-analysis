variable "cluster_id" {
  type        = string
  description = "Group identifier. ElastiCache converts this name to lowercase. Changing this value will re-create the resource."

  validation {
    condition     = length(var.cluster_id) > 0
    error_message = "resource_aws_elasticache_cluster, cluster_id must be a non-empty string."
  }
}

variable "engine" {
  type        = string
  description = "Name of the cache engine to be used for this cache cluster. Valid values are memcached, redis and valkey."
  default     = null

  validation {
    condition     = var.engine == null || contains(["memcached", "redis", "valkey"], var.engine)
    error_message = "resource_aws_elasticache_cluster, engine must be one of: memcached, redis, valkey."
  }
}

variable "node_type" {
  type        = string
  description = "The instance class used. Required unless replication_group_id is provided."
  default     = null
}

variable "num_cache_nodes" {
  type        = number
  description = "The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcached, this value must be between 1 and 40."
  default     = null

  validation {
    condition     = var.num_cache_nodes == null || (var.num_cache_nodes >= 1 && var.num_cache_nodes <= 40)
    error_message = "resource_aws_elasticache_cluster, num_cache_nodes must be between 1 and 40."
  }
}

variable "parameter_group_name" {
  type        = string
  description = "The name of the parameter group to associate with this cache cluster. Required unless replication_group_id is provided."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "apply_immediately" {
  type        = bool
  description = "Whether any database modifications are applied immediately, or during the next maintenance window. Default is false."
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Specifies whether minor version engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Only supported for engine type redis and if the engine version is 6 or higher. Defaults to true."
  default     = true
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone for the cache cluster. If you want to create cache nodes in multi-az, use preferred_availability_zones instead. Changing this value will re-create the resource."
  default     = null
}

variable "az_mode" {
  type        = string
  description = "Whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num_cache_nodes must be greater than 1."
  default     = "single-az"

  validation {
    condition     = contains(["single-az", "cross-az"], var.az_mode)
    error_message = "resource_aws_elasticache_cluster, az_mode must be either single-az or cross-az."
  }
}

variable "engine_version" {
  type        = string
  description = "Version number of the cache engine to be used. If not set, defaults to the latest version."
  default     = null
}

variable "final_snapshot_identifier" {
  type        = string
  description = "Name of your final cluster snapshot. If omitted, no final snapshot will be made. Redis only."
  default     = null
}

variable "ip_discovery" {
  type        = string
  description = "The IP version to advertise in the discovery protocol. Valid values are ipv4 or ipv6."
  default     = null

  validation {
    condition     = var.ip_discovery == null || contains(["ipv4", "ipv6"], var.ip_discovery)
    error_message = "resource_aws_elasticache_cluster, ip_discovery must be either ipv4 or ipv6."
  }
}

variable "log_delivery_configuration" {
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
  description = "Specifies the destination and format of Redis SLOWLOG or Redis Engine Log. See Log Delivery Configuration. Redis only. Max of 2 blocks."
  default     = []

  validation {
    condition     = length(var.log_delivery_configuration) <= 2
    error_message = "resource_aws_elasticache_cluster, log_delivery_configuration can have a maximum of 2 blocks."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration : contains(["cloudwatch-logs", "kinesis-firehose"], config.destination_type)
    ])
    error_message = "resource_aws_elasticache_cluster, log_delivery_configuration destination_type must be either cloudwatch-logs or kinesis-firehose."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration : contains(["json", "text"], config.log_format)
    ])
    error_message = "resource_aws_elasticache_cluster, log_delivery_configuration log_format must be either json or text."
  }

  validation {
    condition = alltrue([
      for config in var.log_delivery_configuration : contains(["slow-log", "engine-log"], config.log_type)
    ])
    error_message = "resource_aws_elasticache_cluster, log_delivery_configuration log_type must be either slow-log or engine-log."
  }
}

variable "maintenance_window" {
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed. The format is ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC). The minimum maintenance window is a 60 minute period."
  default     = null

  validation {
    condition     = var.maintenance_window == null || can(regex("^[a-z]{3}:[0-9]{2}:[0-9]{2}-[a-z]{3}:[0-9]{2}:[0-9]{2}$", var.maintenance_window))
    error_message = "resource_aws_elasticache_cluster, maintenance_window must be in the format ddd:hh24:mi-ddd:hh24:mi (24H Clock UTC)."
  }
}

variable "network_type" {
  type        = string
  description = "The IP versions for cache cluster connections. IPv6 is supported with Redis engine 6.2 onword or Memcached version 1.6.6 for all Nitro system instances. Valid values are ipv4, ipv6 or dual_stack."
  default     = null

  validation {
    condition     = var.network_type == null || contains(["ipv4", "ipv6", "dual_stack"], var.network_type)
    error_message = "resource_aws_elasticache_cluster, network_type must be one of: ipv4, ipv6, dual_stack."
  }
}

variable "notification_topic_arn" {
  type        = string
  description = "ARN of an SNS topic to send ElastiCache notifications to."
  default     = null

  validation {
    condition     = var.notification_topic_arn == null || can(regex("^arn:aws:sns:", var.notification_topic_arn))
    error_message = "resource_aws_elasticache_cluster, notification_topic_arn must be a valid SNS topic ARN."
  }
}

variable "outpost_mode" {
  type        = string
  description = "Specify the outpost mode that will apply to the cache cluster creation. Valid values are single-outpost and cross-outpost, however AWS currently only supports single-outpost mode."
  default     = null

  validation {
    condition     = var.outpost_mode == null || contains(["single-outpost", "cross-outpost"], var.outpost_mode)
    error_message = "resource_aws_elasticache_cluster, outpost_mode must be either single-outpost or cross-outpost."
  }
}

variable "port" {
  type        = number
  description = "The port number on which each of the cache nodes will accept connections. For Memcached the default is 11211, and for Redis the default port is 6379. Cannot be provided with replication_group_id. Changing this value will re-create the resource."
  default     = null

  validation {
    condition     = var.port == null || (var.port >= 1 && var.port <= 65535)
    error_message = "resource_aws_elasticache_cluster, port must be between 1 and 65535."
  }
}

variable "preferred_availability_zones" {
  type        = list(string)
  description = "List of the Availability Zones in which cache nodes are created. If you are creating your cluster in an Amazon VPC you can only locate nodes in Availability Zones that are associated with the subnets in the selected subnet group. The number of Availability Zones listed must equal the value of num_cache_nodes. Memcached only."
  default     = []
}

variable "preferred_outpost_arn" {
  type        = string
  description = "The outpost ARN in which the cache cluster will be created. Required if outpost_mode is specified."
  default     = null

  validation {
    condition     = var.preferred_outpost_arn == null || can(regex("^arn:aws:outposts:", var.preferred_outpost_arn))
    error_message = "resource_aws_elasticache_cluster, preferred_outpost_arn must be a valid outpost ARN."
  }
}

variable "replication_group_id" {
  type        = string
  description = "ID of the replication group to which this cluster should belong. If this parameter is specified, the cluster is added to the specified replication group as a read replica; otherwise, the cluster is a standalone primary that is not part of any replication group."
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "One or more VPC security groups associated with the cache cluster. Cannot be provided with replication_group_id. VPC only."
  default     = []
}

variable "snapshot_arns" {
  type        = list(string)
  description = "Single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. The object name cannot contain any commas. Changing snapshot_arns forces a new resource. Redis only."
  default     = []

  validation {
    condition     = length(var.snapshot_arns) <= 1
    error_message = "resource_aws_elasticache_cluster, snapshot_arns can contain at most one element."
  }

  validation {
    condition = alltrue([
      for arn in var.snapshot_arns : can(regex("^arn:aws:s3:::", arn))
    ])
    error_message = "resource_aws_elasticache_cluster, snapshot_arns must contain valid S3 ARNs."
  }
}

variable "snapshot_name" {
  type        = string
  description = "Name of a snapshot from which to restore data into the new node group. Changing snapshot_name forces a new resource. Redis only."
  default     = null
}

variable "snapshot_retention_limit" {
  type        = number
  description = "Number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Redis only."
  default     = null

  validation {
    condition     = var.snapshot_retention_limit == null || var.snapshot_retention_limit >= 0
    error_message = "resource_aws_elasticache_cluster, snapshot_retention_limit must be greater than or equal to 0."
  }
}

variable "snapshot_window" {
  type        = string
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. Example: 05:00-09:00. Redis only."
  default     = null

  validation {
    condition     = var.snapshot_window == null || can(regex("^[0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2}$", var.snapshot_window))
    error_message = "resource_aws_elasticache_cluster, snapshot_window must be in the format HH:MM-HH:MM."
  }
}

variable "subnet_group_name" {
  type        = string
  description = "Name of the subnet group to be used for the cache cluster. Changing this value will re-create the resource. Cannot be provided with replication_group_id. VPC only."
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  default     = {}
}

variable "transit_encryption_enabled" {
  type        = bool
  description = "Enable encryption in-transit. Supported with Memcached versions 1.6.12 and later, Valkey 7.2 and later, Redis OSS versions 3.2.6, 4.0.10 and later, running in a VPC."
  default     = null
}