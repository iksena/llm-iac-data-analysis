resource "aws_lightsail_database" "this" {
  blueprint_id             = var.blueprint_id
  bundle_id                = var.bundle_id
  master_database_name     = var.master_database_name
  master_password          = var.master_password
  master_username          = var.master_username
  relational_database_name = var.relational_database_name

  apply_immediately            = var.apply_immediately
  availability_zone            = var.availability_zone
  backup_retention_enabled     = var.backup_retention_enabled
  final_snapshot_name          = var.final_snapshot_name
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  publicly_accessible          = var.publicly_accessible
  region                       = var.region
  skip_final_snapshot          = var.skip_final_snapshot
  tags                         = var.tags
}