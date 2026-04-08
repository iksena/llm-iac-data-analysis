variable "engine" {
  description = "Name of the cache engine to be used for this cache cluster. Valid values are memcached, redis or valkey."
  type        = string
  validation {
    condition     = contains(["memcached", "redis", "valkey"], var.engine)
    error_message = "resource_aws_elasticache_serverless_cache, engine must be one of: memcached, redis, valkey."
  }
}

variable "name" {
  description = "The Cluster name which serves as a unique identifier to the serverless cache"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cache_usage_limits" {
  description = "Sets the cache usage limits for storage and ElastiCache Processing Units for the cache."
  type = object({
    data_storage = optional(object({
      minimum = optional(number)
      maximum = optional(number)
      unit    = optional(string)
    }))
    ecpu_per_second = optional(object({
      minimum = optional(number)
      maximum = optional(number)
    }))
  })
  default = null
  validation {
    condition = var.cache_usage_limits == null || (
      var.cache_usage_limits.data_storage == null || (
        (var.cache_usage_limits.data_storage.minimum == null || (var.cache_usage_limits.data_storage.minimum >= 1 && var.cache_usage_limits.data_storage.minimum <= 5000)) &&
        (var.cache_usage_limits.data_storage.maximum == null || (var.cache_usage_limits.data_storage.maximum >= 1 && var.cache_usage_limits.data_storage.maximum <= 5000)) &&
        (var.cache_usage_limits.data_storage.unit == null || var.cache_usage_limits.data_storage.unit == "GB")
      )
    )
    error_message = "resource_aws_elasticache_serverless_cache, cache_usage_limits.data_storage: minimum and maximum must be between 1 and 5000, unit must be 'GB'."
  }
  validation {
    condition = var.cache_usage_limits == null || (
      var.cache_usage_limits.ecpu_per_second == null || (
        (var.cache_usage_limits.ecpu_per_second.minimum == null || (var.cache_usage_limits.ecpu_per_second.minimum >= 1000 && var.cache_usage_limits.ecpu_per_second.minimum <= 15000000)) &&
        (var.cache_usage_limits.ecpu_per_second.maximum == null || (var.cache_usage_limits.ecpu_per_second.maximum >= 1000 && var.cache_usage_limits.ecpu_per_second.maximum <= 15000000))
      )
    )
    error_message = "resource_aws_elasticache_serverless_cache, cache_usage_limits.ecpu_per_second: minimum and maximum must be between 1000 and 15000000."
  }
}

variable "daily_snapshot_time" {
  description = "The daily time that snapshots will be created from the new serverless cache. Only supported for engine types redis or valkey. Defaults to 0."
  type        = string
  default     = null
  validation {
    condition = var.daily_snapshot_time == null || (
      var.engine == "redis" || var.engine == "valkey"
    )
    error_message = "resource_aws_elasticache_serverless_cache, daily_snapshot_time is only supported for redis or valkey engines."
  }
}

variable "description" {
  description = "User-provided description for the serverless cache. The default is NULL."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "ARN of the customer managed key for encrypting the data at rest. If no KMS key is provided, a default service key is used."
  type        = string
  default     = null
}

variable "major_engine_version" {
  description = "The version of the cache engine that will be used to create the serverless cache."
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "A list of the one or more VPC security groups to be associated with the serverless cache. The security group will authorize traffic access for the VPC end-point (private-link). If no other information is given this will be the VPC's Default Security Group that is associated with the cluster VPC end-point."
  type        = list(string)
  default     = null
}

variable "snapshot_arns_to_restore" {
  description = "The list of ARN(s) of the snapshot that the new serverless cache will be created from. Available for Redis only."
  type        = list(string)
  default     = null
  validation {
    condition     = var.snapshot_arns_to_restore == null || var.engine == "redis"
    error_message = "resource_aws_elasticache_serverless_cache, snapshot_arns_to_restore is only available for redis engine."
  }
}

variable "snapshot_retention_limit" {
  description = "The number of snapshots that will be retained for the serverless cache that is being created. As new snapshots beyond this limit are added, the oldest snapshots will be deleted on a rolling basis. Available for Redis only."
  type        = number
  default     = null
  validation {
    condition     = var.snapshot_retention_limit == null || var.engine == "redis"
    error_message = "resource_aws_elasticache_serverless_cache, snapshot_retention_limit is only available for redis engine."
  }
}

variable "subnet_ids" {
  description = "A list of the identifiers of the subnets where the VPC endpoint for the serverless cache will be deployed. All the subnetIds must belong to the same VPC."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "user_group_id" {
  description = "The identifier of the UserGroup to be associated with the serverless cache. Available for Redis only. Default is NULL."
  type        = string
  default     = null
  validation {
    condition     = var.user_group_id == null || var.engine == "redis"
    error_message = "resource_aws_elasticache_serverless_cache, user_group_id is only available for redis engine."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the serverless cache"
  type        = string
  default     = "40m"
}

variable "update_timeout" {
  description = "Timeout for updating the serverless cache"
  type        = string
  default     = "80m"
}

variable "delete_timeout" {
  description = "Timeout for deleting the serverless cache"
  type        = string
  default     = "40m"
}