output "name" {
  description = "The name to identify the Group Membership"
  value       = aws_iam_group_membership.this.name
}

output "users" {
  description = "List of IAM User names"
  value       = aws_iam_group_membership.this.users
}

output "group" {
  description = "IAM Group name"
  value       = aws_iam_group_membership.this.group
}