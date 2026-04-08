output "client_secret" {
  description = "Client secret of the user pool client"
  value       = aws_cognito_user_pool_client.this.client_secret
  sensitive   = true
}

output "id" {
  description = "ID of the user pool client"
  value       = aws_cognito_user_pool_client.this.id
}