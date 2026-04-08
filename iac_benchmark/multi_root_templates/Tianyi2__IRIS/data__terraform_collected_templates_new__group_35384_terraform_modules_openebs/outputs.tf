output "namespace" {
  description = "The name of the namespace in which OpenEBS is deployed."
  value       = data.kubernetes_namespace.namespace.metadata[0].name
}

output "chart_id" {
  description = "The Helm release ID for OpenEBS."
  value       = helm_release.application.id
}

output "chart_name" {
  description = "The Helm chart reference for OpenEBS."
  value       = helm_release.application.name
}
