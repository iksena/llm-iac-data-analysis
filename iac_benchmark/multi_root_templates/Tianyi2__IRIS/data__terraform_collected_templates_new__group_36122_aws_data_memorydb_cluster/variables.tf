variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the cluster."

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_memorydb_cluster, name must not be empty."
  }
}