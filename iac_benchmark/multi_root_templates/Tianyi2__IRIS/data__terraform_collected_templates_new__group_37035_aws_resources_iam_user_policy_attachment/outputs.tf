output "id" {
  description = "The policy attachment ID"
  value       = aws_iam_user_policy_attachment.this.id
}

output "user" {
  description = "The user the policy is applied to"
  value       = aws_iam_user_policy_attachment.this.user
}

output "policy_arn" {
  description = "The ARN of the attached policy"
  value       = aws_iam_user_policy_attachment.this.policy_arn
}