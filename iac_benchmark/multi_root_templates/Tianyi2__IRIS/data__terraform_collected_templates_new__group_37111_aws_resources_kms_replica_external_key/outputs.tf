output "arn" {
  description = "The Amazon Resource Name (ARN) of the replica key. The key ARNs of related multi-Region keys differ only in the Region value."
  value       = aws_kms_replica_external_key.this.arn
}

output "expiration_model" {
  description = "Whether the key material expires. Empty when pending key material import, otherwise KEY_MATERIAL_EXPIRES or KEY_MATERIAL_DOES_NOT_EXPIRE."
  value       = aws_kms_replica_external_key.this.expiration_model
}

output "key_id" {
  description = "The key ID of the replica key. Related multi-Region keys have the same key ID."
  value       = aws_kms_replica_external_key.this.key_id
}

output "key_state" {
  description = "The state of the replica key."
  value       = aws_kms_replica_external_key.this.key_state
}

output "key_usage" {
  description = "The cryptographic operations for which you can use the KMS key. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_external_key.this.key_usage
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kms_replica_external_key.this.tags_all
}