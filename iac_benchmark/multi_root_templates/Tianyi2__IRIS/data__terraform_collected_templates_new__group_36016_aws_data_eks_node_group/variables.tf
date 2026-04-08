variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-_]*[a-zA-Z0-9]$", var.cluster_name)) && length(var.cluster_name) <= 100
    error_message = "data_aws_eks_node_group, cluster_name must be a valid EKS cluster name (alphanumeric characters, hyphens, and underscores only, max 100 characters)."
  }
}

variable "node_group_name" {
  description = "Name of the node group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9\\-_]*[a-zA-Z0-9]$", var.node_group_name)) && length(var.node_group_name) <= 63
    error_message = "data_aws_eks_node_group, node_group_name must be a valid EKS node group name (alphanumeric characters, hyphens, and underscores only, max 63 characters)."
  }
}