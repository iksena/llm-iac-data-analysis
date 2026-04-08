output "namespace" {
  description = "The name of the namespace in which Longhorn is deployed."
  value       = data.kubernetes_namespace.namespace.metadata[0].name
}

output "chart_id" {
  description = "The Helm release ID for Longhorn."
  value       = helm_release.application.id
}

output "chart_name" {
  description = "The Helm chart reference for Longhorn."
  value       = helm_release.application.name
}

output "chart_reference" {
  description = "The Helm chart reference for Longhorn."
  value       = local.chart_reference
}

output "service_address" {
  description = "The address of the Longhorn service."
  value       = "${helm_release.application.name}.${data.kubernetes_namespace.namespace.metadata[0].name}.svc"
}

output "service_port" {
  description = "The port of the Longhorn service."
  value       = local.service_port
}

output "ingress_enabled" {
  description = "Whether ingress is enabled for the Longhorn service."
  value       = var.ingress_enabled
}

output "ingress_address" {
  description = "The ingress address of the Longhorn service."
  value       = var.ingress_enabled ? var.ingress_host_address : ""
}

output "tls_enabled" {
  description = "Whether TLS is enabled for the Longhorn ingress."
  value       = var.ingress_tls_enabled
}

output "tls_secret_name" {
  description = "The name of the TLS secret used for Longhorn ingress."
  value       = local.ingress_tls_secret_name
}

output "storage_class_name" {
  description = "The name of the storage class created by Longhorn."
  value       = var.storage_class_name
}

output "storage_class_reclaim_policy" {
  description = "The reclaim policy of the storage class created by Longhorn."
  value       = var.storage_reclaim_policy
}
