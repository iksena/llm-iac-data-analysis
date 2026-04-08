// region azure/aks

output "host" {
  value = module.ocean-aks.host
}

output "node_resource_group" {
  value = module.ocean-aks.node_resource_group
}

output "location" {
  value = module.ocean-aks.location
}

output "aks_id" {
  value = module.ocean-aks.aks_id
}

output "system_assigned_identity" {
  value = module.ocean-aks.system_assigned_identity
}

output "kubelet_identity" {
  value = module.ocean-aks.kubelet_identity
}

// endregion

// region spotinst/ocean-aks

output "ocean_cluster_id" {
  description = "The ID of the Ocean cluster"
  value       = module.ocean-aks.ocean_cluster_id
}

output "ocean_cluster_name" {
  description = "The name of the Ocean cluster"
  value       = module.ocean-aks.ocean_cluster_name
}

output "ocean_controller_cluster_id" {
  description = "The ID of the Ocean controller"
  value       = module.ocean-aks.ocean_controller_cluster_id
}

output "ocean_acd_identifier" {
  description = "The identifier used by the Ocean AKS Connector to import the AKS cluster"
  value       = module.ocean-aks.ocean_acd_identifier
}

// endregion
