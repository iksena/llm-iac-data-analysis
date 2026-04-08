resource "aws_neptune_global_cluster" "this" {
  global_cluster_identifier = var.global_cluster_identifier

  deletion_protection          = var.deletion_protection
  engine                       = var.engine
  engine_version               = var.engine_version
  region                       = var.region
  source_db_cluster_identifier = var.source_db_cluster_identifier
  storage_encrypted            = var.storage_encrypted

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}