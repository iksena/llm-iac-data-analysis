output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "kube_config" {
  description = "Raw kubeconfig for the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "cluster_identity_principal_id" {
  description = "Principal ID of the cluster managed identity"
  value       = azurerm_kubernetes_cluster.main.identity[0].principal_id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the kubelet managed identity"
  value       = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

output "node_resource_group" {
  description = "Auto-generated resource group containing AKS nodes"
  value       = azurerm_kubernetes_cluster.main.node_resource_group
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = var.enable_monitoring ? azurerm_log_analytics_workspace.main[0].id : null
}