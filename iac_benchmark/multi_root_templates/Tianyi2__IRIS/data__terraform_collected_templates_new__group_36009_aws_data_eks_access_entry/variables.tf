variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the EKS Cluster."
  type        = string

  validation {
    condition     = var.cluster_name != null && var.cluster_name != ""
    error_message = "data_aws_eks_access_entry, cluster_name must be provided and cannot be empty."
  }
}

variable "principal_arn" {
  description = "The IAM Principal ARN which requires Authentication access to the EKS cluster."
  type        = string

  validation {
    condition     = var.principal_arn != null && var.principal_arn != ""
    error_message = "data_aws_eks_access_entry, principal_arn must be provided and cannot be empty."
  }

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:(role|user)/", var.principal_arn))
    error_message = "data_aws_eks_access_entry, principal_arn must be a valid IAM role or user ARN."
  }
}