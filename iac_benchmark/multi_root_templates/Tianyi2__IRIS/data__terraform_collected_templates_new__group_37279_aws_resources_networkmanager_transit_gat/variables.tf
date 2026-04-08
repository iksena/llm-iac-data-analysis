variable "global_network_id" {
  type        = string
  description = "ID of the Global Network to register to"

  validation {
    condition     = can(regex("^global-network-[0-9a-z]+$", var.global_network_id))
    error_message = "resource_aws_networkmanager_transit_gateway_registration, global_network_id must be a valid Global Network ID (format: global-network-xxxxxxxxx)."
  }
}

variable "transit_gateway_arn" {
  type        = string
  description = "ARN of the Transit Gateway to register"

  validation {
    condition     = can(regex("^arn:aws:ec2:[a-z0-9-]+:[0-9]{12}:transit-gateway/tgw-[0-9a-z]+$", var.transit_gateway_arn))
    error_message = "resource_aws_networkmanager_transit_gateway_registration, transit_gateway_arn must be a valid Transit Gateway ARN."
  }
}

variable "create_timeout" {
  type        = string
  default     = "10m"
  description = "Timeout for create operations"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.create_timeout))
    error_message = "resource_aws_networkmanager_transit_gateway_registration, create_timeout must be a valid timeout value (e.g., 10m, 1h)."
  }
}

variable "delete_timeout" {
  type        = string
  default     = "10m"
  description = "Timeout for delete operations"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.delete_timeout))
    error_message = "resource_aws_networkmanager_transit_gateway_registration, delete_timeout must be a valid timeout value (e.g., 10m, 1h)."
  }
}