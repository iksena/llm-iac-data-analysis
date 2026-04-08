output "id" {
  description = "The ID of the Cognito user in group resource."
  value       = aws_cognito_user_in_group.this.id
}

output "user_pool_id" {
  description = "The user pool ID of the user and group."
  value       = aws_cognito_user_in_group.this.user_pool_id
}

output "group_name" {
  description = "The name of the group to which the user is added."
  value       = aws_cognito_user_in_group.this.group_name
}

output "username" {
  description = "The username of the user added to the group."
  value       = aws_cognito_user_in_group.this.username
}