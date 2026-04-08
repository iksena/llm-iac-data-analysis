variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the virtual service."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_appmesh_virtual_service, name cannot be null or empty."
  }
}

variable "mesh_name" {
  description = "Name of the service mesh in which the virtual service exists."
  type        = string

  validation {
    condition     = var.mesh_name != null && var.mesh_name != ""
    error_message = "data_aws_appmesh_virtual_service, mesh_name cannot be null or empty."
  }
}

variable "mesh_owner" {
  description = "AWS account ID of the service mesh's owner."
  type        = string
  default     = null
}