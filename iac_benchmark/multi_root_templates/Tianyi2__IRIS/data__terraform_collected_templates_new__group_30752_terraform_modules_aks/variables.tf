variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  validation {
    condition     = length(var.name_prefix) <= 10
    error_message = "Name prefix must be 10 characters or less for AKS naming limits."
  }
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for AKS nodes (from networking module)"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = null # Uses latest supported version
}

variable "enable_monitoring" {
  description = "Enable Azure Monitor for containers (ContainerInsights). Set to false for easier cleanup."
  type        = bool
  default     = true
}

variable "aks_admin_group_object_ids" {
  description = "List of Azure AD group object IDs that should have admin access to AKS cluster"
  type        = list(string)
  default     = []
}

variable "aks_admin_user_principal_names" {
  description = "List of Azure AD user principal names that should have admin access to AKS cluster"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}