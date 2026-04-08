variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_ec2_client_vpn_network_association, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint."
  type        = string

  validation {
    condition     = can(regex("^cvpn-endpoint-[0-9a-f]{17}$", var.client_vpn_endpoint_id))
    error_message = "resource_aws_ec2_client_vpn_network_association, client_vpn_endpoint_id must be a valid Client VPN endpoint ID (e.g., cvpn-endpoint-0ac3a1abbccddd666)."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the Client VPN endpoint."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]{8}([0-9a-f]{9})?$", var.subnet_id))
    error_message = "resource_aws_ec2_client_vpn_network_association, subnet_id must be a valid subnet ID (e.g., subnet-12345678 or subnet-1234567890abcdef0)."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the Client VPN network association."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_ec2_client_vpn_network_association, timeouts_create must be a valid duration format (e.g., 30m, 1h, 300s)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the Client VPN network association."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_ec2_client_vpn_network_association, timeouts_delete must be a valid duration format (e.g., 30m, 1h, 300s)."
  }
}