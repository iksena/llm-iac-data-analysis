resource "aws_backup_vault_lock_configuration" "this" {
  region              = var.region
  backup_vault_name   = var.backup_vault_name
  changeable_for_days = var.changeable_for_days
  max_retention_days  = var.max_retention_days
  min_retention_days  = var.min_retention_days
}