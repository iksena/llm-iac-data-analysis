output "arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  value       = aws_kms_key.this.arn
}

output "key_id" {
  description = "The globally unique identifier for the key."
  value       = aws_kms_key.this.key_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kms_key.this.tags_all
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_kms_key.this.region
}

output "description" {
  description = "The description of the key as viewed in AWS console."
  value       = aws_kms_key.this.description
}

output "key_usage" {
  description = "The intended use of the key."
  value       = aws_kms_key.this.key_usage
}

output "custom_key_store_id" {
  description = "ID of the KMS Custom Key Store where the key is stored."
  value       = aws_kms_key.this.custom_key_store_id
}

output "customer_master_key_spec" {
  description = "The key spec of the key."
  value       = aws_kms_key.this.customer_master_key_spec
}

output "policy" {
  description = "The key policy JSON document."
  value       = aws_kms_key.this.policy
}

output "bypass_policy_lockout_safety_check" {
  description = "Whether the key policy lockout safety check is bypassed."
  value       = aws_kms_key.this.bypass_policy_lockout_safety_check
}

output "deletion_window_in_days" {
  description = "The waiting period in days before the key is deleted."
  value       = aws_kms_key.this.deletion_window_in_days
}

output "is_enabled" {
  description = "Whether the key is enabled."
  value       = aws_kms_key.this.is_enabled
}

output "enable_key_rotation" {
  description = "Whether key rotation is enabled."
  value       = aws_kms_key.this.enable_key_rotation
}

output "rotation_period_in_days" {
  description = "The period of time between each rotation date."
  value       = aws_kms_key.this.rotation_period_in_days
}

output "multi_region" {
  description = "Whether the KMS key is a multi-Region or regional key."
  value       = aws_kms_key.this.multi_region
}

output "tags" {
  description = "A map of tags assigned to the object."
  value       = aws_kms_key.this.tags
}

output "xks_key_id" {
  description = "The external key ID for the KMS key in an external key store."
  value       = aws_kms_key.this.xks_key_id
}