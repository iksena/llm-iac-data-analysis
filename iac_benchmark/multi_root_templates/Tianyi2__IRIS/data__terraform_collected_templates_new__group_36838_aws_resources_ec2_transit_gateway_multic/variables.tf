variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the subnet to associate with the transit gateway multicast domain."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]{8,17}$", var.subnet_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain_association, subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "transit_gateway_attachment_id" {
  description = "The ID of the transit gateway attachment."
  type        = string

  validation {
    condition     = can(regex("^tgw-attach-[0-9a-f]{8,17}$", var.transit_gateway_attachment_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain_association, transit_gateway_attachment_id must be a valid transit gateway attachment ID starting with 'tgw-attach-'."
  }
}

variable "transit_gateway_multicast_domain_id" {
  description = "The ID of the transit gateway multicast domain."
  type        = string

  validation {
    condition     = can(regex("^tgw-mcast-domain-[0-9a-f]{8,17}$", var.transit_gateway_multicast_domain_id))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain_association, transit_gateway_multicast_domain_id must be a valid transit gateway multicast domain ID starting with 'tgw-mcast-domain-'."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the transit gateway multicast domain association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.create_timeout))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain_association, create_timeout must be a valid timeout format (e.g., '10m', '600s')."
  }
}

variable "delete_timeout" {
  description = "Timeout for deleting the transit gateway multicast domain association."
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.delete_timeout))
    error_message = "resource_aws_ec2_transit_gateway_multicast_domain_association, delete_timeout must be a valid timeout format (e.g., '10m', '600s')."
  }
}