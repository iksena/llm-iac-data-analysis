output "id" {
  description = "The ID of the ElastiCache Global Replication Group."
  value       = aws_elasticache_global_replication_group.this.id
}

output "arn" {
  description = "The ARN of the ElastiCache Global Replication Group."
  value       = aws_elasticache_global_replication_group.this.arn
}

output "engine_version_actual" {
  description = "The full version number of the cache engine running on the members of this global replication group."
  value       = aws_elasticache_global_replication_group.this.engine_version_actual
}

output "at_rest_encryption_enabled" {
  description = "A flag that indicate whether the encryption at rest is enabled."
  value       = aws_elasticache_global_replication_group.this.at_rest_encryption_enabled
}

output "auth_token_enabled" {
  description = "A flag that indicate whether AuthToken (password) is enabled."
  value       = aws_elasticache_global_replication_group.this.auth_token_enabled
}

output "cluster_enabled" {
  description = "Indicates whether the Global Datastore is cluster enabled."
  value       = aws_elasticache_global_replication_group.this.cluster_enabled
}

output "global_replication_group_id" {
  description = "The full ID of the global replication group."
  value       = aws_elasticache_global_replication_group.this.global_replication_group_id
}

output "global_node_groups" {
  description = "Set of node groups (shards) on the global replication group."
  value       = aws_elasticache_global_replication_group.this.global_node_groups
}

output "transit_encryption_enabled" {
  description = "A flag that indicates whether the encryption in transit is enabled."
  value       = aws_elasticache_global_replication_group.this.transit_encryption_enabled
}