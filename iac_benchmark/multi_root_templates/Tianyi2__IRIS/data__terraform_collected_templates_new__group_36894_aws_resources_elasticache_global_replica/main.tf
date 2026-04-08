resource "aws_elasticache_global_replication_group" "this" {
  region                               = var.region
  automatic_failover_enabled           = var.automatic_failover_enabled
  cache_node_type                      = var.cache_node_type
  engine                               = var.engine
  engine_version                       = var.engine_version
  global_replication_group_id_suffix   = var.global_replication_group_id_suffix
  primary_replication_group_id         = var.primary_replication_group_id
  global_replication_group_description = var.global_replication_group_description
  num_node_groups                      = var.num_node_groups
  parameter_group_name                 = var.parameter_group_name

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}