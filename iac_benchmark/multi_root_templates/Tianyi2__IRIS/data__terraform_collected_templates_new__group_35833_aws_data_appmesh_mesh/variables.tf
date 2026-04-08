variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the service mesh."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9\\-]*[a-zA-Z0-9])?$", var.name))
    error_message = "data_aws_appmesh_mesh, name must be a valid mesh name containing only alphanumeric characters and hyphens, not starting or ending with a hyphen."
  }

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "data_aws_appmesh_mesh, name must be between 1 and 255 characters in length."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  type        = string
  default     = null

  validation {
    condition     = var.mesh_owner == null || can(regex("^[0-9]{12}$", var.mesh_owner))
    error_message = "data_aws_appmesh_mesh, mesh_owner must be a valid 12-digit AWS account ID."
  }
}