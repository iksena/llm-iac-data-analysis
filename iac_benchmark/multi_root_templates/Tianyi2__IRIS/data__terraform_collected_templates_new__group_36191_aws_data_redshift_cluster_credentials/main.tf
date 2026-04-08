data "aws_redshift_cluster_credentials" "this" {
  region             = var.region
  auto_create        = var.auto_create
  cluster_identifier = var.cluster_identifier
  db_name            = var.db_name
  db_user            = var.db_user
  db_groups          = var.db_groups
  duration_seconds   = var.duration_seconds
}