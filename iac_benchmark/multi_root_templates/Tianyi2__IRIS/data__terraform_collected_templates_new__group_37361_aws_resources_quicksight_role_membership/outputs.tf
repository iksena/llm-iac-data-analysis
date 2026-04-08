output "member_name" {
  description = "Name of the group added to the role"
  value       = aws_quicksight_role_membership.this.member_name
}

output "role" {
  description = "Role that the group was added to"
  value       = aws_quicksight_role_membership.this.role
}

output "aws_account_id" {
  description = "AWS account ID"
  value       = aws_quicksight_role_membership.this.aws_account_id
}

output "namespace" {
  description = "Name of the namespace"
  value       = aws_quicksight_role_membership.this.namespace
}

output "region" {
  description = "Region where the resource is managed"
  value       = aws_quicksight_role_membership.this.region
}