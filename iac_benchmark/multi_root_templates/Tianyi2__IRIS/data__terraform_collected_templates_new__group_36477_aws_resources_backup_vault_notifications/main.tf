resource "aws_backup_vault_notifications" "this" {
  region              = var.region
  backup_vault_name   = var.backup_vault_name
  sns_topic_arn       = var.sns_topic_arn
  backup_vault_events = var.backup_vault_events
}