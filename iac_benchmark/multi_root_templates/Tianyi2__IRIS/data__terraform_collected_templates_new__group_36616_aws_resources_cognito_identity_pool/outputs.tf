output "id" {
  description = "An identity pool ID"
  value       = aws_cognito_identity_pool.this.id
}

output "arn" {
  description = "The ARN of the identity pool"
  value       = aws_cognito_identity_pool.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_cognito_identity_pool.this.tags_all
}