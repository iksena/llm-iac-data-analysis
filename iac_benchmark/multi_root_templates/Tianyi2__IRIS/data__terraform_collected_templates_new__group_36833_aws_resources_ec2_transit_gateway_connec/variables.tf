variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "protocol" {
  description = "The tunnel protocol. Valid values: gre. Default is gre."
  type        = string
  default     = "gre"

  validation {
    condition     = contains(["gre"], var.protocol)
    error_message = "resource_aws_ec2_transit_gateway_connect, protocol must be 'gre'."
  }
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway Connect."
  type        = map(string)
  default     = {}
}

variable "transit_gateway_default_route_table_association" {
  description = "Boolean whether the Connect should be associated with the EC2 Transit Gateway association default route table. Default value: true."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "Boolean whether the Connect should propagate routes with the EC2 Transit Gateway propagation default route table. Default value: true."
  type        = bool
  default     = true
}

variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway."
  type        = string

  validation {
    condition     = can(regex("^tgw-[0-9a-f]{8,17}$", var.transit_gateway_id))
    error_message = "resource_aws_ec2_transit_gateway_connect, transit_gateway_id must be a valid Transit Gateway ID (format: tgw-xxxxxxxx)."
  }
}

variable "transport_attachment_id" {
  description = "The underlaying VPC attachment"
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transport_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_connect, transport_attachment_id must be a valid Transit Gateway attachment ID (format: tgw-attach-xxxxxxxx)."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}