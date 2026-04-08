variable "name" {
  description = "Name of the route"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_appmesh_route, name must not be empty."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which the virtual router exists"
  type        = string

  validation {
    condition     = length(var.mesh_name) > 0
    error_message = "data_aws_appmesh_route, mesh_name must not be empty."
  }
}

variable "virtual_router_name" {
  description = "Name of the virtual router in which the route exists"
  type        = string

  validation {
    condition     = length(var.virtual_router_name) > 0
    error_message = "data_aws_appmesh_route, virtual_router_name must not be empty."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner"
  type        = string
  default     = null

  validation {
    condition     = var.mesh_owner == null || can(regex("^[0-9]{12}$", var.mesh_owner))
    error_message = "data_aws_appmesh_route, mesh_owner must be a valid 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_appmesh_route, region must be a valid AWS region identifier or null."
  }
}