resource "aws_efs_backup_policy" "this" {
  region         = var.region
  file_system_id = var.file_system_id

  backup_policy {
    status = var.backup_policy_status
  }
}