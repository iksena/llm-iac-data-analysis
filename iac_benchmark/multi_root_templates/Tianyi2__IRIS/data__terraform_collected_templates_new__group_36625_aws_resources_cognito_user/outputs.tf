output "user_pool_id" {
  description = "The user pool ID for the user pool where the user will be created"
  value       = aws_cognito_user.this.user_pool_id
}

output "username" {
  description = "The username for the user"
  value       = aws_cognito_user.this.username
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_cognito_user.this.region
}

output "attributes" {
  description = "User attributes and attribute values set for the user"
  value       = aws_cognito_user.this.attributes
}

output "client_metadata" {
  description = "Custom key-value pairs for custom workflows triggered by user creation"
  value       = aws_cognito_user.this.client_metadata
}

output "desired_delivery_mediums" {
  description = "Mediums through which the welcome message will be sent"
  value       = aws_cognito_user.this.desired_delivery_mediums
}

output "enabled" {
  description = "Whether the user is enabled"
  value       = aws_cognito_user.this.enabled
}

output "force_alias_creation" {
  description = "Whether alias migration from previous user is forced"
  value       = aws_cognito_user.this.force_alias_creation
}

output "message_action" {
  description = "Message action setting for invitation message"
  value       = aws_cognito_user.this.message_action
}

output "password" {
  description = "The user's permanent password"
  value       = aws_cognito_user.this.password
  sensitive   = true
}

output "temporary_password" {
  description = "The user's temporary password"
  value       = aws_cognito_user.this.temporary_password
  sensitive   = true
}

output "validation_data" {
  description = "The user's validation data for custom validation workflows"
  value       = aws_cognito_user.this.validation_data
}

output "status" {
  description = "Current user status"
  value       = aws_cognito_user.this.status
}

output "sub" {
  description = "Unique user ID that is never reassignable to another user"
  value       = aws_cognito_user.this.sub
}

