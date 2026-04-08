output "arn" {
  description = "The ARN of the created ElastiCache Cluster."
  value       = aws_elasticache_cluster.this.arn
}

output "engine_version_actual" {
  description = "Because ElastiCache pulls the latest minor or patch for a version, this attribute returns the running version of the cache engine."
  value       = aws_elasticache_cluster.this.engine_version_actual
}

output "cache_nodes" {
  description = "List of node objects including id, address, port and availability_zone."
  value       = aws_elasticache_cluster.this.cache_nodes
}

output "cluster_address" {
  description = "(Memcached only) DNS name of the cache cluster without the port appended."
  value       = aws_elasticache_cluster.this.cluster_address
}

output "configuration_endpoint" {
  description = "(Memcached only) Configuration endpoint to allow host discovery."
  value       = aws_elasticache_cluster.this.configuration_endpoint
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elasticache_cluster.this.tags_all
}