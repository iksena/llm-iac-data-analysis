variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name to use for the virtual router. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_appmesh_virtual_router, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which to create the virtual router. Must be between 1 and 255 characters in length."
  type        = string

  validation {
    condition     = length(var.mesh_name) >= 1 && length(var.mesh_name) <= 255
    error_message = "resource_aws_appmesh_virtual_router, mesh_name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner. Defaults to the account ID the AWS provider is currently connected to."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "listeners" {
  description = "Listeners that the virtual router is expected to receive inbound traffic from. Currently only one listener is supported per virtual router."
  type = list(object({
    port     = number
    protocol = string
  }))
  default = []

  validation {
    condition = alltrue([
      for listener in var.listeners : contains(["http", "http2", "tcp", "grpc"], listener.protocol)
    ])
    error_message = "resource_aws_appmesh_virtual_router, listeners protocol must be one of: http, http2, tcp, grpc."
  }
}