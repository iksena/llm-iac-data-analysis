output "id" {
  description = "The name of the Logically Air Gapped Backup Vault"
  value       = aws_backup_logically_air_gapped_vault.this.id
}

output "arn" {
  description = "The ARN of the Logically Air Gapped Backup Vault"
  value       = aws_backup_logically_air_gapped_vault.this.arn
}


output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_backup_logically_air_gapped_vault.this.tags_all
}