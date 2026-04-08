output "arn" {
  description = "ARN of the trusted token issuer."
  value       = aws_ssoadmin_trusted_token_issuer.this.arn
}

output "id" {
  description = "ARN of the trusted token issuer."
  value       = aws_ssoadmin_trusted_token_issuer.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssoadmin_trusted_token_issuer.this.tags_all
}