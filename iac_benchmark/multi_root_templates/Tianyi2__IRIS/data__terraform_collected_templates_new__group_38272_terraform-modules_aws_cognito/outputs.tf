output "name" {
  description = "Generated name from local configuration."
  value       = module.resource_name_prefix.resource_name
}

output "cognito_user_pool_id" {
  description = "The ID of the Cognito User Pool."
  value       = aws_cognito_user_pool.cognito_user_pool.id
}

output "cognito_user_pool_arn" {
  description = "The ARN of the Cognito User Pool."
  value       = aws_cognito_user_pool.cognito_user_pool.arn
}

output "cognito_user_pool_client_id" {
  description = "The client ID of the Cognito User Pool."
  value       = aws_cognito_user_pool_client.client.id
}

output "cognito_user_pool_client_secret" {
  description = "The client secret of the Cognito User Pool Client."
  value       = aws_cognito_user_pool_client.client.client_secret
  sensitive   = true
}

output "cognito_user_pool_client_callback_urls" {
  description = "The callback URLs of the Cognito User Pool Client."
  value       = aws_cognito_user_pool_client.client.callback_urls
}

output "cognito_domain" {
  description = "The domain associated with the Cognito User Pool."
  value       = aws_cognito_user_pool_domain.domain.domain
}
