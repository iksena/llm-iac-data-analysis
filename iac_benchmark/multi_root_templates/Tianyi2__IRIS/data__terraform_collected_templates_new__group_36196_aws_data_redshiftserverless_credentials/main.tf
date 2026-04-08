data "aws_redshiftserverless_credentials" "this" {
  region           = var.region
  workgroup_name   = var.workgroup_name
  db_name          = var.db_name
  duration_seconds = var.duration_seconds
}