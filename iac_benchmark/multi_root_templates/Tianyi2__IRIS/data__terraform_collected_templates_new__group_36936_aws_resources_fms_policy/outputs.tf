output "id" {
  description = "The ID of the AWS Firewall Manager policy."
  value       = aws_fms_policy.this.id
}

output "policy_update_token" {
  description = "A unique identifier for each update to the policy."
  value       = aws_fms_policy.this.policy_update_token
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_fms_policy.this.tags_all
}