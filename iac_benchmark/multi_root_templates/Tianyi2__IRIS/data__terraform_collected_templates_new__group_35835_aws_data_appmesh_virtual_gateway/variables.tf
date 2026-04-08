variable "name" {
  description = "Name of the virtual gateway."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) > 0
    error_message = "data_appmesh_virtual_gateway, name must be a non-empty string containing only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which the virtual gateway exists."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.mesh_name)) && length(var.mesh_name) > 0
    error_message = "data_appmesh_virtual_gateway, mesh_name must be a non-empty string containing only alphanumeric characters, dots, underscores, and hyphens."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  type        = string
  default     = null

  validation {
    condition     = var.mesh_owner == null || can(regex("^[0-9]{12}$", var.mesh_owner))
    error_message = "data_appmesh_virtual_gateway, mesh_owner must be a valid 12-digit AWS account ID or null."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_appmesh_virtual_gateway, region must be a valid AWS region name or null."
  }
}