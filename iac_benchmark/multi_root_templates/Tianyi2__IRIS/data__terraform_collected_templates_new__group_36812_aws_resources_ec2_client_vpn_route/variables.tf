variable "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  type        = string

  validation {
    condition     = length(var.client_vpn_endpoint_id) > 0
    error_message = "resource_aws_ec2_client_vpn_route, client_vpn_endpoint_id cannot be empty."
  }
}

variable "destination_cidr_block" {
  description = "The IPv4 address range, in CIDR notation, of the route destination"
  type        = string

  validation {
    condition     = can(cidrhost(var.destination_cidr_block, 0))
    error_message = "resource_aws_ec2_client_vpn_route, destination_cidr_block must be a valid IPv4 CIDR block."
  }
}

variable "target_vpc_subnet_id" {
  description = "The ID of the Subnet to route the traffic through. It must already be attached to the Client VPN"
  type        = string

  validation {
    condition     = length(var.target_vpc_subnet_id) > 0
    error_message = "resource_aws_ec2_client_vpn_route, target_vpc_subnet_id cannot be empty."
  }
}

variable "description" {
  description = "A brief description of the route"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration block for resource timeouts"
  type = object({
    create = optional(string, "4m")
    delete = optional(string, "4m")
  })
  default = null
}