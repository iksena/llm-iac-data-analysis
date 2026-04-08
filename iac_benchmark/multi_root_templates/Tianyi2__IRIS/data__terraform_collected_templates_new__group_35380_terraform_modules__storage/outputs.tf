output "minio_operator_enabled" {
  description = "Indicates if the MinIO Operator is enabled."
  value       = var.minio_operator_enabled
}

output "minio_operator_namespace" {
  description = "The namespace where the MinIO Operator is deployed."
  value       = var.minio_operator_enabled ? data.kubernetes_namespace.minio_operator[0].metadata[0].name : ""
}

output "openebs_enabled" {
  description = "Indicates if OpenEBS is enabled."
  value       = var.openebs_enabled
}

output "openebs_namespace" {
  description = "The namespace where OpenEBS is deployed."
  value       = var.openebs_enabled ? data.kubernetes_namespace.openebs[0].metadata[0].name : ""
}

output "velero_enabled" {
  description = "Indicates if Velero is enabled."
  value       = var.velero_enabled
}

output "velero_namespace" {
  description = "The namespace where Velero is deployed."
  value       = var.velero_enabled ? data.kubernetes_namespace.velero[0].metadata[0].name : ""
}

output "velero_node_selector_labels" {
  description = "The node selector labels used by the Velero pods."
  value       = var.velero_enabled ? var.velero_minio_pool_node_selector : {}
}

output "velero_tolerations" {
  description = "The tolerations applied to the Velero pods."
  value       = var.velero_enabled ? var.velero_minio_pool_tolerations : []
}

output "velero_minio_tenant_name" {
  description = "The name of the Velero MinIO tenant."
  value       = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_name : ""
}

output "velero_minio_tenant_bucket_access_id" {
  description = "The access ID for the Velero MinIO tenant bucket."
  value       = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_access_id : ""
}

output "velero_minio_tenant_bucket_access_key" {
  description = "The access key for the Velero MinIO tenant bucket."
  value       = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_access_key : ""
  sensitive   = true
}

output "velero_minio_tenant_service_address" {
  description = "The address of the Velero MinIO tenant service."
  value       = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_service_address : ""
}

output "velero_minio_tenant_service_protocol" {
  description = "The protocol used by the Velero MinIO tenant service."
  value       = length(module.velero_minio_tenant) > 0 ? module.velero_minio_tenant[0].tenant_service_protocol : ""
}

output "velero_minio_tenant_bucket_name" {
  description = "The bucket name used by Velero in the MinIO tenant."
  value       = local.velero_bucket_name
}

output "velero_minio_tenant_bucket_region" {
  description = "The bucket region used by Velero in the MinIO tenant."
  value       = local.velero_bucket_region
}

output "velero_minio_tenant_bucket_endpoint" {
  description = "The bucket endpoint used by Velero in the MinIO tenant."
  value       = local.velero_bucket_endpoint
}

output "longhorn_storage_class_name" {
  description = "The name of the Longhorn storage class."
  value       = module.longhorn.storage_class_name
}

output "longhorn_storage_class_reclaim_policy" {
  description = "The reclaim policy of the Longhorn storage class."
  value       = module.longhorn.storage_class_reclaim_policy
}

output "longhorn_ingress_enabled" {
  description = "Indicates if the Longhorn ingress is enabled."
  value       = module.longhorn.ingress_enabled
}

output "longhorn_ingress_address" {
  description = "The host for the Longhorn ingress."
  value       = module.longhorn.ingress_address
}
