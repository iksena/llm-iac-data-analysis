variable "virtual_cluster_id" {
  description = "ID of the cluster"
  type        = string

  validation {
    condition     = length(var.virtual_cluster_id) > 0
    error_message = "data_aws_emrcontainers_virtual_cluster, virtual_cluster_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_emrcontainers_virtual_cluster, region must not be empty when specified."
  }
}