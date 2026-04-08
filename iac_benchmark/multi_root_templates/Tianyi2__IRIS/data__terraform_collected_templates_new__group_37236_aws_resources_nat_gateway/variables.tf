variable "allocation_id" {
  description = "The Allocation ID of the Elastic IP address for the NAT Gateway. Required for connectivity_type of public."
  type        = string
  default     = null
}

variable "connectivity_type" {
  description = "Connectivity type for the NAT Gateway. Valid values are private and public."
  type        = string
  default     = "public"

  validation {
    condition     = contains(["private", "public"], var.connectivity_type)
    error_message = "resource_aws_nat_gateway, connectivity_type must be either 'private' or 'public'."
  }
}

variable "private_ip" {
  description = "The private IPv4 address to assign to the NAT Gateway. If you don't provide an address, a private IPv4 address will be automatically assigned."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The Subnet ID of the subnet in which to place the NAT Gateway."
  type        = string

  validation {
    condition     = var.subnet_id != null && var.subnet_id != ""
    error_message = "resource_aws_nat_gateway, subnet_id is required and cannot be empty."
  }
}

variable "secondary_allocation_ids" {
  description = "A list of secondary allocation EIP IDs for this NAT Gateway. To remove all secondary allocations an empty list should be specified."
  type        = list(string)
  default     = null
}

variable "secondary_private_ip_address_count" {
  description = "[Private NAT Gateway only] The number of secondary private IPv4 addresses you want to assign to the NAT Gateway."
  type        = number
  default     = null

  validation {
    condition     = var.secondary_private_ip_address_count == null || var.secondary_private_ip_address_count >= 0
    error_message = "resource_aws_nat_gateway, secondary_private_ip_address_count must be a non-negative number."
  }
}

variable "secondary_private_ip_addresses" {
  description = "A list of secondary private IPv4 addresses to assign to the NAT Gateway. To remove all secondary private addresses an empty list should be specified."
  type        = list(string)
  default     = null

  validation {
    condition = var.secondary_private_ip_addresses == null || alltrue([
      for ip in var.secondary_private_ip_addresses : can(cidrhost("${ip}/32", 0))
    ])
    error_message = "resource_aws_nat_gateway, secondary_private_ip_addresses must contain valid IPv4 addresses."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "30m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "30m"
  }
}