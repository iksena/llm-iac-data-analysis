variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cluster_type" {
  description = "Type of clusters to filter by. Currently, the only valid value is eks."
  type        = string
  default     = null

  validation {
    condition     = var.cluster_type == null || var.cluster_type == "eks"
    error_message = "data_aws_eks_cluster_versions, cluster_type must be 'eks' or null."
  }
}

variable "default_only" {
  description = "Whether to show only the default versions of Kubernetes supported by EKS."
  type        = bool
  default     = null
}

variable "include_all" {
  description = "Whether to include all kubernetes versions in the response."
  type        = bool
  default     = null
}

variable "version_status" {
  description = "Status of the EKS cluster versions to list. Valid values are STANDARD_SUPPORT or UNSUPPORTED or EXTENDED_SUPPORT."
  type        = string
  default     = null

  validation {
    condition = var.version_status == null || contains([
      "STANDARD_SUPPORT",
      "UNSUPPORTED",
      "EXTENDED_SUPPORT"
    ], var.version_status)
    error_message = "data_aws_eks_cluster_versions, version_status must be one of: STANDARD_SUPPORT, UNSUPPORTED, EXTENDED_SUPPORT."
  }
}