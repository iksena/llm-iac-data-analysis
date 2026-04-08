resource "aws_rds_global_cluster" "this" {
  region                       = var.region
  global_cluster_identifier    = var.global_cluster_identifier
  database_name                = var.database_name
  deletion_protection          = var.deletion_protection
  engine                       = var.engine
  engine_lifecycle_support     = var.engine_lifecycle_support
  engine_version               = var.engine_version
  force_destroy                = var.force_destroy
  source_db_cluster_identifier = var.source_db_cluster_identifier
  storage_encrypted            = var.storage_encrypted
  tags                         = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}