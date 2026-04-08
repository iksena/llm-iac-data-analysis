variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "transit_gateway_attachment_id" {
  description = "The unique identifier of the transit gateway attachment to accept. This ID is returned in the response when creating a transit gateway-attached firewall."
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_networkfirewall_firewall_transit_gateway_attachment_accepter, transit_gateway_attachment_id must be a valid Transit Gateway attachment ID (format: tgw-attach-xxxxxxxxx)."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the transit gateway attachment accepter."
  type        = string
  default     = "60m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.create_timeout))
    error_message = "resource_aws_networkfirewall_firewall_transit_gateway_attachment_accepter, create_timeout must be a valid timeout format (e.g., 60m, 1h)."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the transit gateway attachment accepter."
  type        = string
  default     = "60m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.delete_timeout))
    error_message = "resource_aws_networkfirewall_firewall_transit_gateway_attachment_accepter, delete_timeout must be a valid timeout format (e.g., 60m, 1h)."
  }
}