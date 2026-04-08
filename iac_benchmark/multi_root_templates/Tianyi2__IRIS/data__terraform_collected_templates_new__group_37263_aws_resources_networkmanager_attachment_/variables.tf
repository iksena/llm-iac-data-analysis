variable "attachment_id" {
  description = "ID of the attachment."
  type        = string

  validation {
    condition     = length(var.attachment_id) > 0
    error_message = "resource_aws_networkmanager_attachment_accepter, attachment_id must not be empty."
  }
}

variable "attachment_type" {
  description = "Type of attachment. Valid values: CONNECT, DIRECT_CONNECT_GATEWAY, SITE_TO_SITE_VPN, TRANSIT_GATEWAY_ROUTE_TABLE, VPC."
  type        = string

  validation {
    condition = contains([
      "CONNECT",
      "DIRECT_CONNECT_GATEWAY",
      "SITE_TO_SITE_VPN",
      "TRANSIT_GATEWAY_ROUTE_TABLE",
      "VPC"
    ], var.attachment_type)
    error_message = "resource_aws_networkmanager_attachment_accepter, attachment_type must be one of: CONNECT, DIRECT_CONNECT_GATEWAY, SITE_TO_SITE_VPN, TRANSIT_GATEWAY_ROUTE_TABLE, VPC."
  }
}

variable "create_timeout" {
  description = "Timeout for create operations."
  type        = string
  default     = "15m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.create_timeout))
    error_message = "resource_aws_networkmanager_attachment_accepter, create_timeout must be a valid duration format (e.g., '15m', '30s', '1h')."
  }
}