variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the virtual cluster."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_emrcontainers_virtual_cluster, name cannot be empty."
  }
}

variable "container_provider" {
  description = "Configuration block for the container provider associated with your cluster."
  type = object({
    id   = string
    type = string
    info = object({
      eks_info = object({
        namespace = string
      })
    })
  })

  validation {
    condition     = length(var.container_provider.id) > 0
    error_message = "resource_aws_emrcontainers_virtual_cluster, container_provider.id cannot be empty."
  }

  validation {
    condition     = contains(["EKS"], var.container_provider.type)
    error_message = "resource_aws_emrcontainers_virtual_cluster, container_provider.type must be 'EKS'."
  }

  validation {
    condition     = length(var.container_provider.info.eks_info.namespace) > 0
    error_message = "resource_aws_emrcontainers_virtual_cluster, container_provider.info.eks_info.namespace cannot be empty."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}