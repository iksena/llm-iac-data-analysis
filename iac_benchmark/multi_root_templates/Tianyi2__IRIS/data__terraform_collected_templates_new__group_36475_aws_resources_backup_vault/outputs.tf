output "id" {
  description = "The name of the vault."
  value       = aws_backup_vault.this.id
}

output "arn" {
  description = "The ARN of the vault."
  value       = aws_backup_vault.this.arn
}

output "recovery_points" {
  description = "The number of recovery points that are stored in a backup vault."
  value       = aws_backup_vault.this.recovery_points
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_backup_vault.this.tags_all
}