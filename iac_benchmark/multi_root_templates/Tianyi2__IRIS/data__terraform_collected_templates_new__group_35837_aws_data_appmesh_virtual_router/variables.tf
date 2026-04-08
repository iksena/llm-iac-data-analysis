variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the virtual router"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_appmesh_virtual_router, name must not be empty."
  }
}

variable "mesh_name" {
  description = "Name of the mesh in which the virtual router exists"
  type        = string

  validation {
    condition     = length(var.mesh_name) > 0
    error_message = "data_aws_appmesh_virtual_router, mesh_name must not be empty."
  }
}