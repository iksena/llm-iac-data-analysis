output "id" {
  description = "The user policy ID, in the form of user_name:user_policy_name."
  value       = aws_iam_user_policy.this.id
}

output "name" {
  description = "The name of the policy (always set)."
  value       = aws_iam_user_policy.this.name
}