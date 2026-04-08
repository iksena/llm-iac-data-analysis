output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_elasticache_replication_group.this.region
}

output "replication_group_id" {
  description = "Identifier for the replication group"
  value       = data.aws_elasticache_replication_group.this.replication_group_id
}

output "description" {
  description = "Description of the replication group"
  value       = data.aws_elasticache_replication_group.this.description
}

output "arn" {
  description = "ARN of the created ElastiCache Replication Group"
  value       = data.aws_elasticache_replication_group.this.arn
}

output "auth_token_enabled" {
  description = "Whether an AuthToken (password) is enabled"
  value       = data.aws_elasticache_replication_group.this.auth_token_enabled
}

output "automatic_failover_enabled" {
  description = "A flag whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails"
  value       = data.aws_elasticache_replication_group.this.automatic_failover_enabled
}

output "cluster_mode" {
  description = "Whether cluster mode is enabled or disabled"
  value       = data.aws_elasticache_replication_group.this.cluster_mode
}

output "node_type" {
  description = "The cluster node type"
  value       = data.aws_elasticache_replication_group.this.node_type
}

output "num_cache_clusters" {
  description = "The number of cache clusters that the replication group has"
  value       = data.aws_elasticache_replication_group.this.num_cache_clusters
}

output "num_node_groups" {
  description = "Number of node groups (shards) for the replication group"
  value       = data.aws_elasticache_replication_group.this.num_node_groups
}

output "member_clusters" {
  description = "Identifiers of all the nodes that are part of this replication group"
  value       = data.aws_elasticache_replication_group.this.member_clusters
}

output "multi_az_enabled" {
  description = "Whether Multi-AZ Support is enabled for the replication group"
  value       = data.aws_elasticache_replication_group.this.multi_az_enabled
}

output "replicas_per_node_group" {
  description = "Number of replica nodes in each node group"
  value       = data.aws_elasticache_replication_group.this.replicas_per_node_group
}

output "log_delivery_configuration" {
  description = "Redis SLOWLOG or Redis Engine Log delivery settings"
  value       = data.aws_elasticache_replication_group.this.log_delivery_configuration
}

output "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache begins taking a daily snapshot of your node group (shard)"
  value       = data.aws_elasticache_replication_group.this.snapshot_window
}

output "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache retains automatic cache cluster snapshots before deleting them"
  value       = data.aws_elasticache_replication_group.this.snapshot_retention_limit
}

output "port" {
  description = "The port number on which the configuration endpoint will accept connections"
  value       = data.aws_elasticache_replication_group.this.port
}

output "configuration_endpoint_address" {
  description = "The configuration endpoint address to allow host discovery"
  value       = data.aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "primary_endpoint_address" {
  description = "The endpoint of the primary node in this node group (shard)"
  value       = data.aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "The endpoint of the reader node in this node group (shard)"
  value       = data.aws_elasticache_replication_group.this.reader_endpoint_address
}