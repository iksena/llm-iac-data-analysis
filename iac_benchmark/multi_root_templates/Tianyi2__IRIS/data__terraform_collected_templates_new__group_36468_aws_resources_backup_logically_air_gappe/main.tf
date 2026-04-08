resource "aws_backup_logically_air_gapped_vault" "this" {
  region             = var.region
  name               = var.name
  max_retention_days = var.max_retention_days
  min_retention_days = var.min_retention_days
  tags               = var.tags

  timeouts {
    create = var.create_timeout
  }
}