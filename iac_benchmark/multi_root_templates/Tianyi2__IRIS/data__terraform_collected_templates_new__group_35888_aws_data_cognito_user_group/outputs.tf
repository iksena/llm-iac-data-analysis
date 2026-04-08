output "description" {
  description = "Description of the user group."
  value       = data.aws_cognito_user_group.this.description
}

output "id" {
  description = "A comma-delimited string concatenating name and user_pool_id."
  value       = data.aws_cognito_user_group.this.id
}

output "precedence" {
  description = "Precedence of the user group."
  value       = data.aws_cognito_user_group.this.precedence
}

output "role_arn" {
  description = "ARN of the IAM role to be associated with the user group."
  value       = data.aws_cognito_user_group.this.role_arn
}

output "name" {
  description = "Name of the user group."
  value       = data.aws_cognito_user_group.this.name
}

output "user_pool_id" {
  description = "User pool the client belongs to."
  value       = data.aws_cognito_user_group.this.user_pool_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_cognito_user_group.this.region
}