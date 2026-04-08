output "id" {
  description = "The key ID of the KMS key policy."
  value       = aws_kms_key_policy.this.id
}

output "key_id" {
  description = "The ID of the KMS Key to which the policy is attached."
  value       = aws_kms_key_policy.this.key_id
}