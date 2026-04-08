output "id" {
  description = "The role policy ID, which is role_name:policy_name"
  value       = aws_iam_role_policy.this.id
}

output "name" {
  description = "The name of the policy"
  value       = aws_iam_role_policy.this.name
}

output "policy" {
  description = "The policy document"
  value       = aws_iam_role_policy.this.policy
}

output "role" {
  description = "The name of the role associated with the policy"
  value       = aws_iam_role_policy.this.role
}