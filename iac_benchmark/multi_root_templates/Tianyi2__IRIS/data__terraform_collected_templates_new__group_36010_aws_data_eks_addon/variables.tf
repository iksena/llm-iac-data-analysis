variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "addon_name" {
  description = "Name of the EKS add-on. The name must match one of the names returned by list-addon."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.addon_name))
    error_message = "data_aws_eks_addon, addon_name must be a valid EKS add-on name containing only alphanumeric characters, hyphens, and underscores, and must start with an alphanumeric character."
  }
}

variable "cluster_name" {
  description = "Name of the EKS Cluster."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]*$", var.cluster_name))
    error_message = "data_aws_eks_addon, cluster_name must be a valid EKS cluster name containing only alphanumeric characters, hyphens, and underscores, and must start with an alphanumeric character."
  }

  validation {
    condition     = length(var.cluster_name) >= 1 && length(var.cluster_name) <= 100
    error_message = "data_aws_eks_addon, cluster_name must be between 1 and 100 characters in length."
  }
}