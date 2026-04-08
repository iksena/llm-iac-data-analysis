resource "aws_db_cluster_snapshot" "this" {
  region                         = var.region
  db_cluster_identifier          = var.db_cluster_identifier
  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier
  shared_accounts                = var.shared_accounts
  tags                           = var.tags

  timeouts {
    create = var.create_timeout
  }
}