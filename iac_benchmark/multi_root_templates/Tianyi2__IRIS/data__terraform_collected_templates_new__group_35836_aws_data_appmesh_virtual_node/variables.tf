variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the virtual node"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_appmesh_virtual_node, name must not be empty."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which the virtual node exists"
  type        = string

  validation {
    condition     = length(var.mesh_name) > 0
    error_message = "data_aws_appmesh_virtual_node, mesh_name must not be empty."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner"
  type        = string
  default     = null

  validation {
    condition     = var.mesh_owner == null || can(regex("^[0-9]{12}$", var.mesh_owner))
    error_message = "data_aws_appmesh_virtual_node, mesh_owner must be a 12-digit AWS account ID."
  }
}