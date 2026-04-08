output "user_name" {
  description = "The name of the user that you want to match."
  value       = data.aws_quicksight_user.this.user_name
}

output "aws_account_id" {
  description = "AWS account ID."
  value       = data.aws_quicksight_user.this.aws_account_id
}

output "namespace" {
  description = "QuickSight namespace."
  value       = data.aws_quicksight_user.this.namespace
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_quicksight_user.this.region
}

output "active" {
  description = "The active status of user. When you create an Amazon QuickSight user that's not an IAM user or an Active Directory user, that user is inactive until they sign in and provide a password."
  value       = data.aws_quicksight_user.this.active
}

output "arn" {
  description = "The Amazon Resource Name (ARN) for the user."
  value       = data.aws_quicksight_user.this.arn
}

output "custom_permissions_name" {
  description = "The custom permissions profile associated with this user."
  value       = data.aws_quicksight_user.this.custom_permissions_name
}

output "email" {
  description = "The user's email address."
  value       = data.aws_quicksight_user.this.email
}

output "identity_type" {
  description = "The type of identity authentication used by the user."
  value       = data.aws_quicksight_user.this.identity_type
}

output "principal_id" {
  description = "The principal ID of the user."
  value       = data.aws_quicksight_user.this.principal_id
}

output "user_role" {
  description = "The Amazon QuickSight role for the user. The user role can be one of the following: READER (read-only access to dashboards), AUTHOR (can create data sources, datasets, analyzes, and dashboards), ADMIN (author who can also manage Amazon QuickSight settings)."
  value       = data.aws_quicksight_user.this.user_role
}