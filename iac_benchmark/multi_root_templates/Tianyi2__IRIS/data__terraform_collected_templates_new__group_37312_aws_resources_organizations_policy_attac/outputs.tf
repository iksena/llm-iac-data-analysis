output "id" {
  description = "The ID of the policy attachment (format: target_id:policy_id)."
  value       = aws_organizations_policy_attachment.this.id
}

output "policy_id" {
  description = "The unique identifier (ID) of the attached policy."
  value       = aws_organizations_policy_attachment.this.policy_id
}

output "target_id" {
  description = "The unique identifier (ID) of the target (root, organizational unit, or account)."
  value       = aws_organizations_policy_attachment.this.target_id
}

output "skip_destroy" {
  description = "Whether the policy attachment will be preserved during destroy operations."
  value       = aws_organizations_policy_attachment.this.skip_destroy
}