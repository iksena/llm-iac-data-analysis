variable "core_network_id" {
  description = "ID of a core network where you want to create the attachment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.core_network_id))
    error_message = "resource_aws_networkmanager_connect_attachment, core_network_id must contain only alphanumeric characters and hyphens."
  }
}

variable "edge_location" {
  description = "Region where the edge is located"
  type        = string

  validation {
    condition     = length(var.edge_location) > 0
    error_message = "resource_aws_networkmanager_connect_attachment, edge_location cannot be empty."
  }
}

variable "transport_attachment_id" {
  description = "ID of the attachment between the two connections"
  type        = string

  validation {
    condition     = can(regex("^attachment-[a-zA-Z0-9]+$", var.transport_attachment_id))
    error_message = "resource_aws_networkmanager_connect_attachment, transport_attachment_id must be a valid attachment ID starting with 'attachment-'."
  }
}

variable "options" {
  description = "Options block for the attachment connection"
  type = object({
    protocol = optional(string, "GRE")
  })
  default = {
    protocol = "GRE"
  }

  validation {
    condition     = contains(["GRE", "NO_ENCAP"], var.options.protocol)
    error_message = "resource_aws_networkmanager_connect_attachment, options.protocol must be either 'GRE' or 'NO_ENCAP'."
  }
}

variable "tags" {
  description = "Key-value tags for the attachment"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s\\._:/=+\\-@]*$", k))])
    error_message = "resource_aws_networkmanager_connect_attachment, tags keys must contain only valid characters."
  }
}