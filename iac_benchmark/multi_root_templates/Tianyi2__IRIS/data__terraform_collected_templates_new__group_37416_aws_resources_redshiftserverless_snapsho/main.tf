resource "aws_redshiftserverless_snapshot" "this" {
  region           = var.region
  namespace_name   = var.namespace_name
  snapshot_name    = var.snapshot_name
  retention_period = var.retention_period
}