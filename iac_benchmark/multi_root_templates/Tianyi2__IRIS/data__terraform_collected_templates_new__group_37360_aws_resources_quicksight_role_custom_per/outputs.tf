
output "custom_permissions_name" {
  description = "Custom permissions profile name"
  value       = aws_quicksight_role_custom_permission.this.custom_permissions_name
}

output "role" {
  description = "Role associated with the custom permissions"
  value       = aws_quicksight_role_custom_permission.this.role
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = aws_quicksight_role_custom_permission.this.aws_account_id
}

output "namespace" {
  description = "Namespace containing the role"
  value       = aws_quicksight_role_custom_permission.this.namespace
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_quicksight_role_custom_permission.this.region
}