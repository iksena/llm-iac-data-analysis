output "id" {
  description = "The group policy ID."
  value       = aws_iam_group_policy.this.id
}

output "group" {
  description = "The group to which this policy applies."
  value       = aws_iam_group_policy.this.group
}

output "name" {
  description = "The name of the policy."
  value       = aws_iam_group_policy.this.name
}

output "policy" {
  description = "The policy document attached to the group."
  value       = aws_iam_group_policy.this.policy
}