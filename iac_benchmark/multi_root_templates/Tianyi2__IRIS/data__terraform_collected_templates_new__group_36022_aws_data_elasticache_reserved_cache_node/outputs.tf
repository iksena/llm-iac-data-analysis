output "id" {
  description = "Unique identifier for the reservation. Same as offering_id."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.offering_id
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.region
}

output "cache_node_type" {
  description = "Node type for the reserved cache node."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.cache_node_type
}

output "duration" {
  description = "Duration of the reservation in RFC3339 duration format."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.duration
}

output "offering_type" {
  description = "Offering type of this reserved cache node."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.offering_type
}

output "product_description" {
  description = "Engine type for the reserved cache node."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.product_description
}

output "fixed_price" {
  description = "Fixed price charged for this reserved cache node."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.fixed_price
}

output "offering_id" {
  description = "Unique identifier for the reservation."
  value       = data.aws_elasticache_reserved_cache_node_offering.this.offering_id
}