output "id" {
  description = "The name of the Cognito User Group."
  value       = aws_cognito_user_group.this.id
}

output "name" {
  description = "The name of the user group."
  value       = aws_cognito_user_group.this.name
}

output "user_pool_id" {
  description = "The user pool ID."
  value       = aws_cognito_user_group.this.user_pool_id
}

output "description" {
  description = "The description of the user group."
  value       = aws_cognito_user_group.this.description
}

output "precedence" {
  description = "The precedence of the user group."
  value       = aws_cognito_user_group.this.precedence
}

output "role_arn" {
  description = "The ARN of the IAM role associated with the user group."
  value       = aws_cognito_user_group.this.role_arn
}