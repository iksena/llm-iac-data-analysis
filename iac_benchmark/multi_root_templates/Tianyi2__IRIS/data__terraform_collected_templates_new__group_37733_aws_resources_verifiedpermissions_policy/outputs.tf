output "policy_store_id" {
  description = "The ID of the Policy Store"
  value       = aws_verifiedpermissions_policy_store.this.policy_store_id
}

output "arn" {
  description = "The ARN of the Policy Store"
  value       = aws_verifiedpermissions_policy_store.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_verifiedpermissions_policy_store.this.tags_all
}