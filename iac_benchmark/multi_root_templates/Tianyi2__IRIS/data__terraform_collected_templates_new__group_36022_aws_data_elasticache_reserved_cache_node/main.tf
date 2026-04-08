data "aws_elasticache_reserved_cache_node_offering" "this" {
  region              = var.region
  cache_node_type     = var.cache_node_type
  duration            = var.duration
  offering_type       = var.offering_type
  product_description = var.product_description
}