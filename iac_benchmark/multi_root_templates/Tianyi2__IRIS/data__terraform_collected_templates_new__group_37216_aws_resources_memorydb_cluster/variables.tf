variable "acl_name" {
  description = "The name of the Access Control List to associate with the cluster"
  type        = string

  validation {
    condition     = length(var.acl_name) > 0
    error_message = "resource_aws_memorydb_cluster, acl_name must not be empty."
  }
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes in the cluster"
  type        = string

  validation {
    condition     = length(var.node_type) > 0
    error_message = "resource_aws_memorydb_cluster, node_type must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "When set to true, the cluster will automatically receive minor engine version upgrades after launch"
  type        = bool
  default     = true
}

variable "data_tiering" {
  description = "Enables data tiering"
  type        = bool
  default     = null
}

variable "description" {
  description = "Description for the cluster"
  type        = string
  default     = "Managed by Terraform"
}

variable "engine" {
  description = "The engine that will run on your nodes"
  type        = string
  default     = null

  validation {
    condition     = var.engine == null || contains(["redis", "valkey"], var.engine)
    error_message = "resource_aws_memorydb_cluster, engine must be either 'redis' or 'valkey'."
  }
}

variable "engine_version" {
  description = "Version number of the engine to be used for the cluster"
  type        = string
  default     = null
}

variable "final_snapshot_name" {
  description = "Name of the final cluster snapshot to be created when this resource is deleted"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used to encrypt the cluster at rest"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_memorydb_cluster, kms_key_arn must be a valid KMS ARN."
  }
}

variable "maintenance_window" {
  description = "Specifies the weekly time range during which maintenance on the cluster is performed"
  type        = string
  default     = null

  validation {
    condition     = var.maintenance_window == null || can(regex("^[a-z]{3}:[0-9]{2}:[0-9]{2}-[a-z]{3}:[0-9]{2}:[0-9]{2}$", var.maintenance_window))
    error_message = "resource_aws_memorydb_cluster, maintenance_window must be in format ddd:hh24:mi-ddd:hh24:mi."
  }
}

variable "name" {
  description = "Name of the cluster"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "num_replicas_per_shard" {
  description = "The number of replicas to apply to each shard, up to a maximum of 5"
  type        = number
  default     = 1

  validation {
    condition     = var.num_replicas_per_shard >= 0 && var.num_replicas_per_shard <= 5
    error_message = "resource_aws_memorydb_cluster, num_replicas_per_shard must be between 0 and 5."
  }
}

variable "num_shards" {
  description = "The number of shards in the cluster"
  type        = number
  default     = 1

  validation {
    condition     = var.num_shards >= 1
    error_message = "resource_aws_memorydb_cluster, num_shards must be at least 1."
  }
}

variable "multi_region_cluster_name" {
  description = "The multi region cluster identifier specified on aws_memorydb_multi_region_cluster"
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "The name of the parameter group associated with the cluster"
  type        = string
  default     = null
}

variable "port" {
  description = "The port number on which each of the nodes accepts connections"
  type        = number
  default     = 6379

  validation {
    condition     = var.port >= 1 && var.port <= 65535
    error_message = "resource_aws_memorydb_cluster, port must be between 1 and 65535."
  }
}

variable "security_group_ids" {
  description = "Set of VPC Security Group IDs to associate with this cluster"
  type        = set(string)
  default     = null
}

variable "snapshot_arns" {
  description = "List of ARNs that uniquely identify RDB snapshot files stored in S3"
  type        = list(string)
  default     = null

  validation {
    condition = var.snapshot_arns == null || alltrue([
      for arn in var.snapshot_arns : can(regex("^arn:aws:s3:::", arn))
    ])
    error_message = "resource_aws_memorydb_cluster, snapshot_arns must contain valid S3 ARNs."
  }
}

variable "snapshot_name" {
  description = "The name of a snapshot from which to restore data into the new cluster"
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "The number of days for which MemoryDB retains automatic snapshots before deleting them"
  type        = number
  default     = 0

  validation {
    condition     = var.snapshot_retention_limit >= 0 && var.snapshot_retention_limit <= 35
    error_message = "resource_aws_memorydb_cluster, snapshot_retention_limit must be between 0 and 35."
  }
}

variable "snapshot_window" {
  description = "The daily time range (in UTC) during which MemoryDB begins taking a daily snapshot of your shard"
  type        = string
  default     = null

  validation {
    condition     = var.snapshot_window == null || can(regex("^[0-9]{2}:[0-9]{2}-[0-9]{2}:[0-9]{2}$", var.snapshot_window))
    error_message = "resource_aws_memorydb_cluster, snapshot_window must be in format hh24:mi-hh24:mi."
  }
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to which cluster notifications are sent"
  type        = string
  default     = null

  validation {
    condition     = var.sns_topic_arn == null || can(regex("^arn:aws:sns:", var.sns_topic_arn))
    error_message = "resource_aws_memorydb_cluster, sns_topic_arn must be a valid SNS ARN."
  }
}

variable "subnet_group_name" {
  description = "The name of the subnet group to be used for the cluster"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tls_enabled" {
  description = "A flag to enable in-transit encryption on the cluster"
  type        = bool
  default     = true
}

variable "timeout_create" {
  description = "Timeout for creating the cluster"
  type        = string
  default     = "120m"
}

variable "timeout_update" {
  description = "Timeout for updating the cluster"
  type        = string
  default     = "120m"
}

variable "timeout_delete" {
  description = "Timeout for deleting the cluster"
  type        = string
  default     = "120m"
}