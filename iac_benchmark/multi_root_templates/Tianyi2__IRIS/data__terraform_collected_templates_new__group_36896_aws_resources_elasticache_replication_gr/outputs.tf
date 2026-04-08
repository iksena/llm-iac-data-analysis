output "arn" {
  description = "ARN of the created ElastiCache Replication Group."
  value       = aws_elasticache_replication_group.this.arn
}

output "engine_version_actual" {
  description = "Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine."
  value       = aws_elasticache_replication_group.this.engine_version_actual
}

output "cluster_enabled" {
  description = "Indicates if cluster mode is enabled."
  value       = aws_elasticache_replication_group.this.cluster_enabled
}

output "configuration_endpoint_address" {
  description = "Address of the replication group configuration endpoint when cluster mode is enabled."
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "id" {
  description = "ID of the ElastiCache Replication Group."
  value       = aws_elasticache_replication_group.this.id
}

output "member_clusters" {
  description = "Identifiers of all the nodes that are part of this replication group."
  value       = aws_elasticache_replication_group.this.member_clusters
}

output "primary_endpoint_address" {
  description = "(Redis only) Address of the endpoint for the primary node in the replication group, if the cluster mode is disabled."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "(Redis only) Address of the endpoint for the reader node in the replication group, if the cluster mode is disabled."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elasticache_replication_group.this.tags_all
}