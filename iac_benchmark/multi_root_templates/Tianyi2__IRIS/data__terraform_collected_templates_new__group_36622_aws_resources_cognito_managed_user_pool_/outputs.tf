output "client_secret" {
  description = "Client secret of the user pool client."
  value       = aws_cognito_managed_user_pool_client.this.client_secret
  sensitive   = true
}

output "id" {
  description = "Unique identifier for the user pool client."
  value       = aws_cognito_managed_user_pool_client.this.id
}

output "name" {
  description = "Name of the user pool client."
  value       = aws_cognito_managed_user_pool_client.this.name
}