resource "aws_redshift_snapshot_schedule_association" "this" {
  region              = var.region
  cluster_identifier  = var.cluster_identifier
  schedule_identifier = var.schedule_identifier
}