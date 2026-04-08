variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the gateway route."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_appmesh_gateway_route, name must be a non-empty string."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which the virtual gateway exists."
  type        = string
  validation {
    condition     = length(var.mesh_name) > 0
    error_message = "data_aws_appmesh_gateway_route, mesh_name must be a non-empty string."
  }
}

variable "virtual_gateway_name" {
  description = "Name of the virtual gateway in which the route exists."
  type        = string
  validation {
    condition     = length(var.virtual_gateway_name) > 0
    error_message = "data_aws_appmesh_gateway_route, virtual_gateway_name must be a non-empty string."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  type        = string
  default     = null
  validation {
    condition     = var.mesh_owner == null || can(regex("^\\d{12}$", var.mesh_owner))
    error_message = "data_aws_appmesh_gateway_route, mesh_owner must be a valid 12-digit AWS account ID or null."
  }
}