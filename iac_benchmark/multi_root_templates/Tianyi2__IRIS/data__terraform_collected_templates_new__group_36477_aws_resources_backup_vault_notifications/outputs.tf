output "id" {
  description = "The name of the vault."
  value       = aws_backup_vault_notifications.this.id
}

output "backup_vault_arn" {
  description = "The ARN of the vault."
  value       = aws_backup_vault_notifications.this.backup_vault_arn
}