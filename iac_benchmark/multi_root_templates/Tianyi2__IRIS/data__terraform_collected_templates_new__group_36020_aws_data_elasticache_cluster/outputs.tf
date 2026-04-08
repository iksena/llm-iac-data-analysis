output "node_type" {
  description = "The cluster node type"
  value       = data.aws_elasticache_cluster.this.node_type
}

output "num_cache_nodes" {
  description = "The number of cache nodes that the cache cluster has"
  value       = data.aws_elasticache_cluster.this.num_cache_nodes
}

output "engine" {
  description = "Name of the cache engine"
  value       = data.aws_elasticache_cluster.this.engine
}

output "engine_version" {
  description = "Version number of the cache engine"
  value       = data.aws_elasticache_cluster.this.engine_version
}

output "ip_discovery" {
  description = "The IP version advertised in the discovery protocol"
  value       = data.aws_elasticache_cluster.this.ip_discovery
}

output "network_type" {
  description = "The IP versions for cache cluster connections"
  value       = data.aws_elasticache_cluster.this.network_type
}

output "subnet_group_name" {
  description = "Name of the subnet group associated to the cache cluster"
  value       = data.aws_elasticache_cluster.this.subnet_group_name
}

output "security_group_ids" {
  description = "List VPC security groups associated with the cache cluster"
  value       = data.aws_elasticache_cluster.this.security_group_ids
}

output "parameter_group_name" {
  description = "Name of the parameter group associated with this cache cluster"
  value       = data.aws_elasticache_cluster.this.parameter_group_name
}

output "replication_group_id" {
  description = "The replication group to which this cache cluster belongs"
  value       = data.aws_elasticache_cluster.this.replication_group_id
}

output "log_delivery_configuration" {
  description = "Redis SLOWLOG or Redis Engine Log delivery settings"
  value       = data.aws_elasticache_cluster.this.log_delivery_configuration
}

output "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed"
  value       = data.aws_elasticache_cluster.this.maintenance_window
}

output "snapshot_window" {
  description = "Daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of the cache cluster"
  value       = data.aws_elasticache_cluster.this.snapshot_window
}

output "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them"
  value       = data.aws_elasticache_cluster.this.snapshot_retention_limit
}

output "availability_zone" {
  description = "Availability Zone for the cache cluster"
  value       = data.aws_elasticache_cluster.this.availability_zone
}

output "notification_topic_arn" {
  description = "An ARN of an SNS topic that ElastiCache notifications get sent to"
  value       = data.aws_elasticache_cluster.this.notification_topic_arn
}

output "port" {
  description = "The port number on which each of the cache nodes will accept connections"
  value       = data.aws_elasticache_cluster.this.port
}

output "configuration_endpoint" {
  description = "(Memcached only) Configuration endpoint to allow host discovery"
  value       = data.aws_elasticache_cluster.this.configuration_endpoint
}

output "cluster_address" {
  description = "(Memcached only) DNS name of the cache cluster without the port appended"
  value       = data.aws_elasticache_cluster.this.cluster_address
}

output "preferred_outpost_arn" {
  description = "The outpost ARN in which the cache cluster was created if created in outpost"
  value       = data.aws_elasticache_cluster.this.preferred_outpost_arn
}

output "cache_nodes" {
  description = "List of node objects including id, address, port, availability_zone and outpost_arn"
  value       = data.aws_elasticache_cluster.this.cache_nodes
}

output "tags" {
  description = "Tags assigned to the resource"
  value       = data.aws_elasticache_cluster.this.tags
}