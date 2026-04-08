output "client_ids" {
  description = "List of Cognito user pool client IDs."
  value       = data.aws_cognito_user_pool_clients.this.client_ids
}

output "client_names" {
  description = "List of Cognito user pool client names."
  value       = data.aws_cognito_user_pool_clients.this.client_names
}