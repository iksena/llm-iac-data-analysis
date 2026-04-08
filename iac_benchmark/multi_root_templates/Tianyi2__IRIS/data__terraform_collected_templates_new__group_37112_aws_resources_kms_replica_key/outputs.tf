output "arn" {
  description = "The Amazon Resource Name (ARN) of the replica key. The key ARNs of related multi-Region keys differ only in the Region value."
  value       = aws_kms_replica_key.this.arn
}

output "key_id" {
  description = "The key ID of the replica key. Related multi-Region keys have the same key ID."
  value       = aws_kms_replica_key.this.key_id
}

output "key_rotation_enabled" {
  description = "A Boolean value that specifies whether key rotation is enabled. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_key.this.key_rotation_enabled
}

output "key_spec" {
  description = "The type of key material in the KMS key. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_key.this.key_spec
}

output "key_usage" {
  description = "The cryptographic operations for which you can use the KMS key. This is a shared property of multi-Region keys."
  value       = aws_kms_replica_key.this.key_usage
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kms_replica_key.this.tags_all
}