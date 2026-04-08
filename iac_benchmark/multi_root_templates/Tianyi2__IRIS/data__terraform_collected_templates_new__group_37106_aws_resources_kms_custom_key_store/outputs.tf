output "id" {
  description = "The Custom Key Store ID"
  value       = aws_kms_custom_key_store.this.id
}

output "custom_key_store_name" {
  description = "Unique name for Custom Key Store"
  value       = aws_kms_custom_key_store.this.custom_key_store_name
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_kms_custom_key_store.this.region
}

output "custom_key_store_type" {
  description = "The type of key store"
  value       = aws_kms_custom_key_store.this.custom_key_store_type
}

output "cloud_hsm_cluster_id" {
  description = "Cluster ID of CloudHSM"
  value       = aws_kms_custom_key_store.this.cloud_hsm_cluster_id
}

output "trust_anchor_certificate" {
  description = "The certificate for an AWS CloudHSM key store"
  value       = aws_kms_custom_key_store.this.trust_anchor_certificate
  sensitive   = true
}

output "xks_proxy_connectivity" {
  description = "How AWS KMS communicates with the external key store proxy"
  value       = aws_kms_custom_key_store.this.xks_proxy_connectivity
}

output "xks_proxy_uri_endpoint" {
  description = "The endpoint that AWS KMS uses to send requests to the external key store proxy"
  value       = aws_kms_custom_key_store.this.xks_proxy_uri_endpoint
}

output "xks_proxy_uri_path" {
  description = "The base path to the proxy APIs for this external key store"
  value       = aws_kms_custom_key_store.this.xks_proxy_uri_path
}

output "xks_proxy_vpc_endpoint_service_name" {
  description = "The name of the Amazon VPC endpoint service for interface endpoints"
  value       = aws_kms_custom_key_store.this.xks_proxy_vpc_endpoint_service_name
}