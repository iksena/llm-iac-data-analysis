resource "aws_keyspaces_keyspace" "this" {
  region = var.region
  name   = var.name

  dynamic "replication_specification" {
    for_each = var.replication_specification != null ? [var.replication_specification] : []
    content {
      region_list          = replication_specification.value.region_list
      replication_strategy = replication_specification.value.replication_strategy
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}