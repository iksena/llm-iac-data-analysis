data "aws_db_cluster_snapshot" "this" {
  region                         = var.region
  most_recent                    = var.most_recent
  db_cluster_identifier          = var.db_cluster_identifier
  db_cluster_snapshot_identifier = var.db_cluster_snapshot_identifier
  snapshot_type                  = var.snapshot_type
  include_shared                 = var.include_shared
  include_public                 = var.include_public
  tags                           = var.tags
}