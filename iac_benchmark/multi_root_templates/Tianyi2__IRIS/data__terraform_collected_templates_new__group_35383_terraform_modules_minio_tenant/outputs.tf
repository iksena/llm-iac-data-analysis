output "namespace" {
  description = "The name of the namespace in which the MinIO tenant is deployed."
  value       = data.kubernetes_namespace.namespace.metadata[0].name
}

output "chart_id" {
  description = "The Helm release ID for the MinIO tenant."
  value       = helm_release.application.id
}

output "chart_name" {
  description = "The Helm chart reference for the MinIO tenant."
  value       = helm_release.application.name
}

output "tenant_name" {
  description = "The name of the MinIO tenant."
  value       = helm_release.application.name
}

output "tenant_access_id" {
  description = "The access ID for the MinIO tenant."
  value       = var.access_id
}

output "tenant_access_key" {
  description = "The access key for the MinIO tenant."
  value       = local.access_key
  sensitive   = true
}

output "tenant_service_address" {
  description = "The address of the MinIO tenant service."
  value       = "minio.${data.kubernetes_namespace.namespace.metadata[0].name}.svc"
}

output "tenant_service_protocol" {
  description = "The protocol used by the MinIO tenant service."
  value       = var.request_auto_cert ? "https" : "http"
}

output "tenant_user_id" {
  description = "The user ID used by the MinIO tenant pods."
  value       = var.pool_user_id
}

output "tenant_group_id" {
  description = "The group ID used by the MinIO tenant pods."
  value       = var.pool_group_id
}

output "tenant_node_selector_labels" {
  description = "The node selector labels used by the MinIO tenant pods."
  value       = var.pool_node_selector
}

output "tenant_bucket_names" {
  description = "The names of the buckets created in the MinIO tenant."
  value       = [for bucket in var.buckets : bucket.name]
}

output "tenant_bucket_regions_by_name" {
  description = "A map of bucket names to their respective regions."
  value       = { for bucket in var.buckets : bucket.name => bucket.region }
}
