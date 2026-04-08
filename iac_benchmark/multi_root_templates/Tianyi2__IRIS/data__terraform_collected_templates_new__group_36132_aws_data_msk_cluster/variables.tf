variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_msk_cluster, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string

  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "data_aws_msk_cluster, cluster_name cannot be empty."
  }

  validation {
    condition     = length(var.cluster_name) <= 64
    error_message = "data_aws_msk_cluster, cluster_name must be 64 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.cluster_name))
    error_message = "data_aws_msk_cluster, cluster_name must contain only alphanumeric characters and hyphens."
  }
}