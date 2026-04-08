resource "aws_redshift_snapshot_copy" "this" {
  cluster_identifier               = var.cluster_identifier
  destination_region               = var.destination_region
  region                           = var.region
  manual_snapshot_retention_period = var.manual_snapshot_retention_period
  retention_period                 = var.retention_period
  snapshot_copy_grant_name         = var.snapshot_copy_grant_name
}