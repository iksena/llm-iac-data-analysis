resource "aws_docdb_global_cluster" "this" {
  region                       = var.region
  global_cluster_identifier    = var.global_cluster_identifier
  database_name                = var.database_name
  deletion_protection          = var.deletion_protection
  engine                       = var.engine
  engine_version               = var.engine_version
  source_db_cluster_identifier = var.source_db_cluster_identifier
  storage_encrypted            = var.storage_encrypted

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}