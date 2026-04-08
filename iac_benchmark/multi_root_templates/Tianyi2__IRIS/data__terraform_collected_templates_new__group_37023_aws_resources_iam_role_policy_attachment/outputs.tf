output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role_policy_attachments_exclusive.this.role_name
}

output "policy_arns" {
  description = "The list of managed IAM policy ARNs attached to the role"
  value       = aws_iam_role_policy_attachments_exclusive.this.policy_arns
}