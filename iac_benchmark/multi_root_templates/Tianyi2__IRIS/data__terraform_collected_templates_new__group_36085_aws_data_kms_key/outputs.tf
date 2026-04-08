output "id" {
  description = "The globally unique identifier for the key"
  value       = data.aws_kms_key.this.id
}

output "arn" {
  description = "The ARN of the key"
  value       = data.aws_kms_key.this.arn
}

output "aws_account_id" {
  description = "The twelve-digit account ID of the AWS account that owns the key"
  value       = data.aws_kms_key.this.aws_account_id
}

output "cloud_hsm_cluster_id" {
  description = "The cluster ID of the AWS CloudHSM cluster that contains the key material for the KMS key"
  value       = data.aws_kms_key.this.cloud_hsm_cluster_id
}

output "creation_date" {
  description = "The date and time when the key was created"
  value       = data.aws_kms_key.this.creation_date
}

output "custom_key_store_id" {
  description = "A unique identifier for the custom key store that contains the KMS key"
  value       = data.aws_kms_key.this.custom_key_store_id
}

output "customer_master_key_spec" {
  description = "See key_spec"
  value       = data.aws_kms_key.this.customer_master_key_spec
}

output "deletion_date" {
  description = "The date and time after which AWS KMS deletes the key. This value is present only when key_state is PendingDeletion, otherwise this value is 0"
  value       = data.aws_kms_key.this.deletion_date
}

output "description" {
  description = "The description of the key"
  value       = data.aws_kms_key.this.description
}

output "enabled" {
  description = "Specifies whether the key is enabled. When key_state is Enabled this value is true, otherwise it is false"
  value       = data.aws_kms_key.this.enabled
}

output "expiration_model" {
  description = "Specifies whether the Key's key material expires. This value is present only when origin is EXTERNAL, otherwise this value is empty"
  value       = data.aws_kms_key.this.expiration_model
}

output "key_manager" {
  description = "The key's manager"
  value       = data.aws_kms_key.this.key_manager
}

output "key_spec" {
  description = "Describes the type of key material in the KMS key"
  value       = data.aws_kms_key.this.key_spec
}

output "key_state" {
  description = "The state of the key"
  value       = data.aws_kms_key.this.key_state
}

output "key_usage" {
  description = "Specifies the intended use of the key"
  value       = data.aws_kms_key.this.key_usage
}

output "multi_region" {
  description = "Indicates whether the KMS key is a multi-Region (true) or regional (false) key"
  value       = data.aws_kms_key.this.multi_region
}

output "multi_region_configuration" {
  description = "Lists the primary and replica keys in same multi-Region key. Present only when the value of multi_region is true"
  value       = data.aws_kms_key.this.multi_region_configuration
}

output "origin" {
  description = "When this value is AWS_KMS, AWS KMS created the key material. When this value is EXTERNAL, the key material was imported from your existing key management infrastructure or the CMK lacks key material"
  value       = data.aws_kms_key.this.origin
}

output "pending_deletion_window_in_days" {
  description = "The waiting period before the primary key in a multi-Region key is deleted"
  value       = data.aws_kms_key.this.pending_deletion_window_in_days
}

output "valid_to" {
  description = "The time at which the imported key material expires. This value is present only when origin is EXTERNAL and whose expiration_model is KEY_MATERIAL_EXPIRES, otherwise this value is 0"
  value       = data.aws_kms_key.this.valid_to
}

output "xks_key_configuration" {
  description = "Information about the external key that is associated with a KMS key in an external key store"
  value       = data.aws_kms_key.this.xks_key_configuration
}