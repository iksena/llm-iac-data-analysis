output "arn" {
  description = "ARN for the reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.arn
}

output "duration" {
  description = "Duration of the reservation as an RFC3339 duration"
  value       = aws_elasticache_reserved_cache_node.this.duration
}

output "fixed_price" {
  description = "Fixed price charged for this reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.fixed_price
}

output "cache_node_type" {
  description = "Node type for the reserved cache nodes"
  value       = aws_elasticache_reserved_cache_node.this.cache_node_type
}

output "offering_type" {
  description = "Offering type of this reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.offering_type
}

output "product_description" {
  description = "Engine type for the reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.product_description
}

output "recurring_charges" {
  description = "Recurring price charged to run this reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.recurring_charges
}

output "start_time" {
  description = "Time the reservation started"
  value       = aws_elasticache_reserved_cache_node.this.start_time
}

output "state" {
  description = "State of the reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.state
}

output "usage_price" {
  description = "Hourly price charged for this reserved cache node"
  value       = aws_elasticache_reserved_cache_node.this.usage_price
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_elasticache_reserved_cache_node.this.tags_all
}

output "id" {
  description = "Customer-specified identifier to track this reservation"
  value       = aws_elasticache_reserved_cache_node.this.id
}

output "reserved_cache_nodes_offering_id" {
  description = "ID of the reserved cache node offering to purchase"
  value       = aws_elasticache_reserved_cache_node.this.reserved_cache_nodes_offering_id
}

output "cache_node_count" {
  description = "Number of cache node instances to reserve"
  value       = aws_elasticache_reserved_cache_node.this.cache_node_count
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_elasticache_reserved_cache_node.this.region
}

output "tags" {
  description = "Map of tags assigned to the reservation"
  value       = aws_elasticache_reserved_cache_node.this.tags
}