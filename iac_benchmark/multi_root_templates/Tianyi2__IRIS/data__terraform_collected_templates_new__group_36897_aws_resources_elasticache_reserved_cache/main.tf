resource "aws_elasticache_reserved_cache_node" "this" {
  reserved_cache_nodes_offering_id = var.reserved_cache_nodes_offering_id
  cache_node_count                 = var.cache_node_count
  id                               = var.id
  region                           = var.region
  tags                             = var.tags

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}