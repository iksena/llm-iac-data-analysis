output "user" {
  description = "The name of the IAM User"
  value       = aws_iam_user_group_membership.this.user
}

output "groups" {
  description = "The list of IAM Groups the user is added to"
  value       = aws_iam_user_group_membership.this.groups
}