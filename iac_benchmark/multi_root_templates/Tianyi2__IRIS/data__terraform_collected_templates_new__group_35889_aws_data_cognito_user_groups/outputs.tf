output "id" {
  description = "User pool identifier."
  value       = data.aws_cognito_user_groups.this.id
}

output "groups" {
  description = "List of groups."
  value       = data.aws_cognito_user_groups.this.groups
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_cognito_user_groups.this.region
}

output "user_pool_id" {
  description = "User pool the client belongs to."
  value       = data.aws_cognito_user_groups.this.user_pool_id
}