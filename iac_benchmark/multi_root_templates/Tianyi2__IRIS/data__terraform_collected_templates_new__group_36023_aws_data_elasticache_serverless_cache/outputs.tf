output "arn" {
  description = "The Amazon Resource Name (ARN) of the serverless cache"
  value       = data.aws_elasticache_serverless_cache.this.arn
}

output "cache_usage_limits" {
  description = "The cache usage limits for storage and ElastiCache Processing Units for the cache"
  value       = data.aws_elasticache_serverless_cache.this.cache_usage_limits
}

output "create_time" {
  description = "Timestamp of when the serverless cache was created"
  value       = data.aws_elasticache_serverless_cache.this.create_time
}

output "daily_snapshot_time" {
  description = "The daily time that snapshots will be created from the new serverless cache. Only available for engine types redis and valkey"
  value       = data.aws_elasticache_serverless_cache.this.daily_snapshot_time
}

output "description" {
  description = "Description of the serverless cache"
  value       = data.aws_elasticache_serverless_cache.this.description
}

output "endpoint" {
  description = "Represents the information required for client programs to connect to the cache"
  value       = data.aws_elasticache_serverless_cache.this.endpoint
}

output "engine" {
  description = "Name of the cache engine"
  value       = data.aws_elasticache_serverless_cache.this.engine
}

output "full_engine_version" {
  description = "The name and version number of the engine the serverless cache is compatible with"
  value       = data.aws_elasticache_serverless_cache.this.full_engine_version
}

output "kms_key_id" {
  description = "ARN of the customer managed key for encrypting the data at rest"
  value       = data.aws_elasticache_serverless_cache.this.kms_key_id
}

output "major_engine_version" {
  description = "The version number of the engine the serverless cache is compatible with"
  value       = data.aws_elasticache_serverless_cache.this.major_engine_version
}

output "name" {
  description = "Identifier for the serverless cache"
  value       = data.aws_elasticache_serverless_cache.this.name
}

output "reader_endpoint" {
  description = "Represents the information required for client programs to connect to a cache node"
  value       = data.aws_elasticache_serverless_cache.this.reader_endpoint
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_elasticache_serverless_cache.this.region
}

output "security_group_ids" {
  description = "A list of the one or more VPC security groups associated with the serverless cache"
  value       = data.aws_elasticache_serverless_cache.this.security_group_ids
}

output "snapshot_retention_limit" {
  description = "The number of snapshots that will be retained for the serverless cache. Available for Redis only"
  value       = data.aws_elasticache_serverless_cache.this.snapshot_retention_limit
}

output "status" {
  description = "The current status of the serverless cache"
  value       = data.aws_elasticache_serverless_cache.this.status
}

output "subnet_ids" {
  description = "A list of the identifiers of the subnets where the VPC endpoint for the serverless cache are deployed"
  value       = data.aws_elasticache_serverless_cache.this.subnet_ids
}

output "user_group_id" {
  description = "The identifier of the UserGroup associated with the serverless cache. Available for Redis only"
  value       = data.aws_elasticache_serverless_cache.this.user_group_id
}