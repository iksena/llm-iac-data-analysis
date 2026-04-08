output "arn" {
  description = "ARN assigned by AWS to this policy"
  value       = aws_iam_policy.this.arn
}

output "attachment_count" {
  description = "Number of entities (users, groups, and roles) that the policy is attached to"
  value       = aws_iam_policy.this.attachment_count
}

output "id" {
  description = "ARN assigned by AWS to this policy"
  value       = aws_iam_policy.this.id
}

output "policy_id" {
  description = "Policy's ID"
  value       = aws_iam_policy.this.policy_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iam_policy.this.tags_all
}