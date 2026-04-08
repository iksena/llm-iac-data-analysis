variable "cluster_id" {
  description = "Group identifier"
  type        = string

  validation {
    condition     = length(var.cluster_id) > 0
    error_message = "data_aws_elasticache_cluster, cluster_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}