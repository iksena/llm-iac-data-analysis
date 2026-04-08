resource "aws_docdb_cluster_snapshot" "this" {
  region                         = var.region
  db_cluster_identifier          = var.db_cluster_identifier
  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier

  timeouts {
    create = var.create_timeout
  }
}