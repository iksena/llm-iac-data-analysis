output "arn" {
  description = "The ARN of the Policy Store."
  value       = data.aws_verifiedpermissions_policy_store.this.arn
}

output "created_date" {
  description = "The date the Policy Store was created."
  value       = data.aws_verifiedpermissions_policy_store.this.created_date
}

output "deletion_protection" {
  description = "Whether the policy store can be deleted."
  value       = data.aws_verifiedpermissions_policy_store.this.deletion_protection
}

output "id" {
  description = "The ID of the Policy Store."
  value       = data.aws_verifiedpermissions_policy_store.this.id
}

output "last_updated_date" {
  description = "The date the Policy Store was last updated."
  value       = data.aws_verifiedpermissions_policy_store.this.last_updated_date
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_verifiedpermissions_policy_store.this.region
}

output "tags" {
  description = "Map of key-value pairs associated with the policy store."
  value       = data.aws_verifiedpermissions_policy_store.this.tags
}

output "validation_settings" {
  description = "Validation settings for the policy store."
  value       = data.aws_verifiedpermissions_policy_store.this.validation_settings
}