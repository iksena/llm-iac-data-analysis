output "location" {
  description = "The URI of the vault that was created."
  value       = aws_glacier_vault.this.location
}

output "arn" {
  description = "The ARN of the vault."
  value       = aws_glacier_vault.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_glacier_vault.this.tags_all
}