output "id" {
  description = "The name of the vault."
  value       = aws_backup_vault_policy.this.id
}

output "backup_vault_arn" {
  description = "The ARN of the vault."
  value       = aws_backup_vault_policy.this.backup_vault_arn
}