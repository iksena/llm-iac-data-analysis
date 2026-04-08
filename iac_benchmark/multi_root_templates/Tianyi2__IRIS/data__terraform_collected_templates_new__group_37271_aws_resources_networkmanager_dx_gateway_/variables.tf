variable "core_network_id" {
  description = "ID of the Cloud WAN core network to which the Direct Connect gateway attachment should be attached"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.core_network_id)) && length(var.core_network_id) > 0
    error_message = "resource_aws_networkmanager_dx_gateway_attachment, core_network_id must be a non-empty string containing only lowercase letters, numbers, and hyphens."
  }
}

variable "direct_connect_gateway_arn" {
  description = "ARN of the Direct Connect gateway attachment"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:directconnect:[a-z0-9-]*:[0-9]{12}:dx-gateway/[a-z0-9-]+$", var.direct_connect_gateway_arn))
    error_message = "resource_aws_networkmanager_dx_gateway_attachment, direct_connect_gateway_arn must be a valid Direct Connect gateway ARN."
  }
}

variable "edge_locations" {
  description = "One or more core network edge locations to associate with the Direct Connect gateway attachment"
  type        = list(string)

  validation {
    condition     = length(var.edge_locations) > 0
    error_message = "resource_aws_networkmanager_dx_gateway_attachment, edge_locations must contain at least one edge location."
  }

  validation {
    condition     = alltrue([for location in var.edge_locations : can(regex("^[a-z0-9-]+$", location))])
    error_message = "resource_aws_networkmanager_dx_gateway_attachment, edge_locations must contain valid location identifiers with only lowercase letters, numbers, and hyphens."
  }
}

variable "tags" {
  description = "Key-value tags for the attachment"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[a-zA-Z0-9\\s\\._:/@-]+$", k)) && can(regex("^[a-zA-Z0-9\\s\\._:/@-]*$", v))])
    error_message = "resource_aws_networkmanager_dx_gateway_attachment, tags keys and values must contain only valid characters (letters, numbers, spaces, and ._:/@-)."
  }
}

variable "timeouts" {
  description = "Timeouts for the NetworkManager DX Gateway Attachment resource"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_networkmanager_dx_gateway_attachment, timeouts must be specified in the format '30m', '1h', or '120s'."
  }
}