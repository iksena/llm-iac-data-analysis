output "arn" {
  description = "ARN of the vault"
  value       = data.aws_backup_vault.this.arn
}

output "kms_key_arn" {
  description = "Server-side encryption key that is used to protect your backups"
  value       = data.aws_backup_vault.this.kms_key_arn
}

output "recovery_points" {
  description = "Number of recovery points that are stored in a backup vault"
  value       = data.aws_backup_vault.this.recovery_points
}

output "tags" {
  description = "Metadata that you can assign to help organize the resources that you create"
  value       = data.aws_backup_vault.this.tags
}

output "name" {
  description = "Name of the backup vault"
  value       = data.aws_backup_vault.this.name
}

output "region" {
  description = "Region where this resource will be managed"
  value       = data.aws_backup_vault.this.region
}