output "user_name" {
  description = "IAM user name"
  value       = aws_iam_user_policies_exclusive.this.user_name
}

output "policy_names" {
  description = "List of inline policy names assigned to the user"
  value       = aws_iam_user_policies_exclusive.this.policy_names
}