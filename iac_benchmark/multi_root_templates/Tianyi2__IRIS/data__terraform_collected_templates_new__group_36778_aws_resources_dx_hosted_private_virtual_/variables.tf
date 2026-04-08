variable "virtual_interface_id" {
  description = "The ID of the Direct Connect virtual interface to accept."
  type        = string

  validation {
    condition     = can(regex("^dxvif-[0-9a-f]{8}$", var.virtual_interface_id))
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, virtual_interface_id must be a valid Direct Connect virtual interface ID (format: dxvif-xxxxxxxx)."
  }
}

variable "dx_gateway_id" {
  description = "The ID of the Direct Connect gateway to which to connect the virtual interface."
  type        = string
  default     = null

  validation {
    condition     = var.dx_gateway_id == null || can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.dx_gateway_id))
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, dx_gateway_id must be a valid Direct Connect gateway ID (UUID format) when specified."
  }
}

variable "vpn_gateway_id" {
  description = "The ID of the virtual private gateway to which to connect the virtual interface."
  type        = string
  default     = null

  validation {
    condition     = var.vpn_gateway_id == null || can(regex("^vgw-[0-9a-f]{8,17}$", var.vpn_gateway_id))
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, vpn_gateway_id must be a valid VPN gateway ID (format: vgw-xxxxxxxx) when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags : can(regex("^.{1,128}$", key))
    ])
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, tags keys must be between 1 and 128 characters in length."
  }

  validation {
    condition = alltrue([
      for key, value in var.tags : can(regex("^.{0,256}$", value))
    ])
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, tags values must be between 0 and 256 characters in length."
  }
}

variable "timeouts" {
  description = "Configuration block for resource timeouts."
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))
    )
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, timeouts create must be a valid duration (e.g., '10m', '1h') when specified."
  }

  validation {
    condition = var.timeouts == null || (
      var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    )
    error_message = "resource_aws_dx_hosted_private_virtual_interface_accepter, timeouts delete must be a valid duration (e.g., '10m', '1h') when specified."
  }
}