variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for the virtual service. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appmesh_virtual_service, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which to create the virtual service. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = length(var.mesh_name) >= 1 && length(var.mesh_name) <= 255
    error_message = "resource_aws_appmesh_virtual_service, mesh_name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner. Defaults to the account ID the AWS provider is currently connected to."
  type        = string
  default     = null
}

variable "spec" {
  description = "Virtual service specification to apply."
  type = object({
    provider = optional(object({
      virtual_node = optional(object({
        virtual_node_name = string
      }))
      virtual_router = optional(object({
        virtual_router_name = string
      }))
    }))
  })
  default = null

  validation {
    condition = var.spec == null || (
      var.spec.provider == null || (
        (var.spec.provider.virtual_node != null && var.spec.provider.virtual_router == null) ||
        (var.spec.provider.virtual_node == null && var.spec.provider.virtual_router != null)
      )
    )
    error_message = "resource_aws_appmesh_virtual_service, spec.provider can only specify either virtual_node or virtual_router, not both."
  }

  validation {
    condition = var.spec == null || var.spec.provider == null || var.spec.provider.virtual_node == null || (
      length(var.spec.provider.virtual_node.virtual_node_name) >= 1 &&
      length(var.spec.provider.virtual_node.virtual_node_name) <= 255
    )
    error_message = "resource_aws_appmesh_virtual_service, spec.provider.virtual_node.virtual_node_name must be between 1 and 255 characters in length."
  }

  validation {
    condition = var.spec == null || var.spec.provider == null || var.spec.provider.virtual_router == null || (
      length(var.spec.provider.virtual_router.virtual_router_name) >= 1 &&
      length(var.spec.provider.virtual_router.virtual_router_name) <= 255
    )
    error_message = "resource_aws_appmesh_virtual_service, spec.provider.virtual_router.virtual_router_name must be between 1 and 255 characters in length."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}