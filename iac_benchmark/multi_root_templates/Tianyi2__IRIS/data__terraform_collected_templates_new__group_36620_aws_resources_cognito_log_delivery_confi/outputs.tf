output "user_pool_id" {
  description = "The ID of the user pool for which to configure log delivery"
  value       = aws_cognito_log_delivery_configuration.this.user_pool_id
}

output "region" {
  description = "The AWS region"
  value       = aws_cognito_log_delivery_configuration.this.region
}

output "log_configurations" {
  description = "Configuration block for log delivery"
  value       = aws_cognito_log_delivery_configuration.this.log_configurations
}