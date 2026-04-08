resource "aws_redshift_cluster_snapshot" "this" {
  region                           = var.region
  cluster_identifier               = var.cluster_identifier
  snapshot_identifier              = var.snapshot_identifier
  manual_snapshot_retention_period = var.manual_snapshot_retention_period
  tags                             = var.tags
}