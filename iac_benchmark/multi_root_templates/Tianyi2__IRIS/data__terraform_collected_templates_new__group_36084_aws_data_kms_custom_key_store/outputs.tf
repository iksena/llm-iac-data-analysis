output "id" {
  description = "The ID for the custom key store."
  value       = data.aws_kms_custom_key_store.this.id
}

output "cloudhsm_cluster_id" {
  description = "ID for the CloudHSM cluster that is associated with the custom key store."
  value       = data.aws_kms_custom_key_store.this.cloud_hsm_cluster_id
}

output "connection_state" {
  description = "Indicates whether the custom key store is connected to its CloudHSM cluster."
  value       = data.aws_kms_custom_key_store.this.connection_state
}

output "creation_date" {
  description = "The date and time when the custom key store was created."
  value       = data.aws_kms_custom_key_store.this.creation_date
}

output "trust_anchor_certificate" {
  description = "The trust anchor certificate of the associated CloudHSM cluster."
  value       = data.aws_kms_custom_key_store.this.trust_anchor_certificate
}

output "custom_key_store_id" {
  description = "The ID for the custom key store."
  value       = data.aws_kms_custom_key_store.this.custom_key_store_id
}

output "custom_key_store_name" {
  description = "The user-specified friendly name for the custom key store."
  value       = data.aws_kms_custom_key_store.this.custom_key_store_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_kms_custom_key_store.this.region
}