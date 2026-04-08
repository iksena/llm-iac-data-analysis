output "policy_name" {
  description = "Name of the resource policy."
  value       = aws_xray_resource_policy.this.policy_name
}

output "policy_document" {
  description = "JSON string of the resource policy or resource policy document."
  value       = aws_xray_resource_policy.this.policy_document
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_xray_resource_policy.this.region
}

output "policy_revision_id" {
  description = "Current policy revision id for this policy name."
  value       = aws_xray_resource_policy.this.policy_revision_id
}

output "bypass_policy_lockout_check" {
  description = "Flag indicating whether to bypass the resource policy lockout safety check."
  value       = aws_xray_resource_policy.this.bypass_policy_lockout_check
}

output "last_updated_time" {
  description = "When the policy was last updated, in Unix time seconds."
  value       = aws_xray_resource_policy.this.last_updated_time
}