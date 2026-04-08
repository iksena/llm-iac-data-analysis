variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "virtual_interface_id" {
  description = "The ID of the Direct Connect virtual interface to accept."
  type        = string

  validation {
    condition     = can(regex("^dxvif-[0-9a-f]{8}$", var.virtual_interface_id))
    error_message = "resource_aws_dx_hosted_public_virtual_interface_accepter, virtual_interface_id must be a valid Direct Connect virtual interface ID (format: dxvif-xxxxxxxx)."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null
}