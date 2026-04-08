output "namespace" {
  description = "The name of the namespace in which Velero is deployed."
  value       = data.kubernetes_namespace.namespace.metadata[0].name
}

output "chart_id" {
  description = "The Helm release ID for Velero."
  value       = helm_release.application.id
}

output "chart_name" {
  description = "The Helm chart reference for Velero."
  value       = helm_release.application.name
}

output "backup_storage_location_name" {
  description = "The name of the S3 backup storage location created by Velero."
  value       = local.backup_storage_location_name
}
