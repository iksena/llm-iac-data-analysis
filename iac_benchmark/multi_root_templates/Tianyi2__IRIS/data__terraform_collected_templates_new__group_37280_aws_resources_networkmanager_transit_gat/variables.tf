variable "peering_id" {
  description = "ID of the peer for the attachment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.peering_id))
    error_message = "resource_aws_networkmanager_transit_gateway_route_table_attachment, peering_id must contain only alphanumeric characters and hyphens."
  }
}

variable "transit_gateway_route_table_arn" {
  description = "ARN of the transit gateway route table for the attachment"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:ec2:[a-z0-9-]+:[0-9]{12}:transit-gateway-route-table/tgw-rtb-[a-f0-9]+$", var.transit_gateway_route_table_arn))
    error_message = "resource_aws_networkmanager_transit_gateway_route_table_attachment, transit_gateway_route_table_arn must be a valid transit gateway route table ARN."
  }
}

variable "tags" {
  description = "Key-value tags for the attachment"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^[a-zA-Z0-9 _.:/=+@-]*$", k)) && can(regex("^[a-zA-Z0-9 _.:/=+@-]*$", v))
    ])
    error_message = "resource_aws_networkmanager_transit_gateway_route_table_attachment, tags keys and values must contain only alphanumeric characters, spaces, and the following special characters: _.:/=+@-"
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      (var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create))) &&
      (var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete)))
    )
    error_message = "resource_aws_networkmanager_transit_gateway_route_table_attachment, timeouts create and delete must be in the format of a number followed by 's', 'm', or 'h'."
  }
}