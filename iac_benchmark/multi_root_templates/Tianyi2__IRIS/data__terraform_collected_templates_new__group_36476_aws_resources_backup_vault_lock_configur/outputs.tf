output "backup_vault_name" {
  description = "The name of the vault."
  value       = aws_backup_vault_lock_configuration.this.backup_vault_name
}

output "backup_vault_arn" {
  description = "The ARN of the vault."
  value       = aws_backup_vault_lock_configuration.this.backup_vault_arn
}