output "created_date" {
  description = "The date the policy was created."
  value       = aws_verifiedpermissions_policy.this.created_date
}

output "policy_id" {
  description = "The Policy ID of the policy."
  value       = aws_verifiedpermissions_policy.this.policy_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_verifiedpermissions_policy.this.region
}

output "policy_store_id" {
  description = "The Policy Store ID of the policy store."
  value       = aws_verifiedpermissions_policy.this.policy_store_id
}