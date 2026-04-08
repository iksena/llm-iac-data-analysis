// region azure/aks

variable "resource_group_name" {
  type        = string
  description = "The Resource Group name to be imported"
}

variable "aks_cluster_name" {
  type        = string
  description = "The AKS cluster name to be imported"
}

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools to be imported as Ocean Virtual Node Groups"
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Map of maps containing node labels by node pool name"
}

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node pool name"
}

variable "node_pools_tags" {
  type        = map(map(string))
  description = "Map of maps containing node tags by node pool name"
}

variable "node_pools_headrooms" {
  type        = map(map(string))
  description = "Map of maps containing headroom configuration by node pool name"
}

// endregion

// region spotinst/ocean-aks

variable "spotinst_token" {
  type        = string
  description = "Spot Personal Access token"
}

variable "spotinst_account" {
  type        = string
  description = "Spot account ID"
}

// endregion
