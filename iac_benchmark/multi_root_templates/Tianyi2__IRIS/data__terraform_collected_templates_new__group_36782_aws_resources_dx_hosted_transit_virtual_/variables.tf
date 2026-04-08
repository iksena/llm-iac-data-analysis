variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "dx_gateway_id" {
  description = "The ID of the Direct Connect gateway to which to connect the virtual interface."
  type        = string

  validation {
    condition     = can(regex("^dxgw-[0-9a-f]{8,17}$", var.dx_gateway_id))
    error_message = "resource_aws_dx_hosted_transit_virtual_interface_accepter, dx_gateway_id must be a valid Direct Connect gateway ID (dxgw-xxxxxxxx)."
  }
}

variable "virtual_interface_id" {
  description = "The ID of the Direct Connect virtual interface to accept."
  type        = string

  validation {
    condition     = can(regex("^dxvif-[0-9a-f]{8,17}$", var.virtual_interface_id))
    error_message = "resource_aws_dx_hosted_transit_virtual_interface_accepter, virtual_interface_id must be a valid Direct Connect virtual interface ID (dxvif-xxxxxxxx)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_dx_hosted_transit_virtual_interface_accepter, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_dx_hosted_transit_virtual_interface_accepter, tags values must be between 0 and 256 characters."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the resource."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_dx_hosted_transit_virtual_interface_accepter, create_timeout must be a valid duration (e.g., 10m, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the resource."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_dx_hosted_transit_virtual_interface_accepter, delete_timeout must be a valid duration (e.g., 10m, 1h)."
  }
}