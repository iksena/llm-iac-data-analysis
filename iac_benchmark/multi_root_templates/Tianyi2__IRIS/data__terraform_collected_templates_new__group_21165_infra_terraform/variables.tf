variable "subscription_id" {
  description = "The Azure Subscription ID where resources will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create resources."
  type        = string
}

variable "location" {
  description = "Azure region for the resources."
  type        = string
}

variable "aks_cluster_name" {
  description = "The name to use for the AKS cluster."
  type        = string
}

variable "aks_default_node_pool_vm_size" {
  description = "The VM size for the default AKS node pool."
  type        = string
  default     = "Standard_D8ds_v5" # Keeping the original as default
}

variable "aks_default_node_pool_min_count" {
  description = "The minimum number of nodes for the default AKS node pool autoscaler."
  type        = number
  default     = 1
}

variable "aks_default_node_pool_max_count" {
  description = "The maximum number of nodes for the default AKS node pool autoscaler."
  type        = number
  default     = 2
}

variable "developer_api_ips" {
  type        = list(string)
  description = "List of dedicated public IP addresses/CIDRs for the Developer-facing API app."
  default     = ["0.0.0.0/0"]
}

variable "developer_vpn_ips" {
  type        = list(string)
  description = "List of public IP addresses/CIDRs for the developer VPN (for secure local access to the cluster)"
  default     = ["0.0.0.0/0"]
}