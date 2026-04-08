variable "subnet_id" {
  description = "Subnet ID to create the ENI in"
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-fA-F]{8,17}$", var.subnet_id))
    error_message = "resource_aws_network_interface, subnet_id must be a valid subnet ID starting with 'subnet-'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "attachment" {
  description = "Configuration block to define the attachment of the ENI"
  type = object({
    instance           = string
    device_index       = number
    network_card_index = optional(number, 0)
  })
  default = null

  validation {
    condition = var.attachment == null || (
      can(regex("^i-[0-9a-fA-F]{8,17}$", var.attachment.instance)) &&
      var.attachment.device_index >= 0 &&
      var.attachment.network_card_index >= 0
    )
    error_message = "resource_aws_network_interface, attachment instance must be a valid instance ID, device_index must be >= 0, and network_card_index must be >= 0."
  }
}

variable "description" {
  description = "Description for the network interface"
  type        = string
  default     = null
}

variable "enable_primary_ipv6" {
  description = "Enables assigning a primary IPv6 Global Unicast Address to the network interface"
  type        = bool
  default     = null
}

variable "interface_type" {
  description = "Type of network interface to create"
  type        = string
  default     = null

  validation {
    condition     = var.interface_type == null || contains(["interface", "efa"], var.interface_type)
    error_message = "resource_aws_network_interface, interface_type must be either 'interface' or 'efa'."
  }
}

variable "ipv4_prefix_count" {
  description = "Number of IPv4 prefixes that AWS automatically assigns to the network interface"
  type        = number
  default     = null

  validation {
    condition     = var.ipv4_prefix_count == null || var.ipv4_prefix_count >= 0
    error_message = "resource_aws_network_interface, ipv4_prefix_count must be >= 0."
  }
}

variable "ipv4_prefixes" {
  description = "One or more IPv4 prefixes assigned to the network interface"
  type        = set(string)
  default     = null

  validation {
    condition = var.ipv4_prefixes == null || alltrue([
      for prefix in var.ipv4_prefixes : can(cidrhost(prefix, 0))
    ])
    error_message = "resource_aws_network_interface, ipv4_prefixes must contain valid IPv4 CIDR blocks."
  }
}

variable "ipv6_address_count" {
  description = "Number of IPv6 addresses to assign to a network interface"
  type        = number
  default     = null

  validation {
    condition     = var.ipv6_address_count == null || var.ipv6_address_count >= 0
    error_message = "resource_aws_network_interface, ipv6_address_count must be >= 0."
  }
}

variable "ipv6_address_list_enabled" {
  description = "Whether ipv6_address_list is allowed and controls the IPs to assign to the ENI"
  type        = bool
  default     = false
}

variable "ipv6_address_list" {
  description = "List of private IPs to assign to the ENI in sequential order"
  type        = list(string)
  default     = null

  validation {
    condition = var.ipv6_address_list == null || alltrue([
      for addr in var.ipv6_address_list : can(regex("^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$", addr))
    ])
    error_message = "resource_aws_network_interface, ipv6_address_list must contain valid IPv6 addresses."
  }
}

variable "ipv6_addresses" {
  description = "One or more specific IPv6 addresses from the IPv6 CIDR block range of your subnet"
  type        = set(string)
  default     = null

  validation {
    condition = var.ipv6_addresses == null || alltrue([
      for addr in var.ipv6_addresses : can(regex("^([0-9a-fA-F]{0,4}:){1,7}[0-9a-fA-F]{0,4}$", addr))
    ])
    error_message = "resource_aws_network_interface, ipv6_addresses must contain valid IPv6 addresses."
  }
}

variable "ipv6_prefix_count" {
  description = "Number of IPv6 prefixes that AWS automatically assigns to the network interface"
  type        = number
  default     = null

  validation {
    condition     = var.ipv6_prefix_count == null || var.ipv6_prefix_count >= 0
    error_message = "resource_aws_network_interface, ipv6_prefix_count must be >= 0."
  }
}

variable "ipv6_prefixes" {
  description = "One or more IPv6 prefixes assigned to the network interface"
  type        = set(string)
  default     = null

  validation {
    condition = var.ipv6_prefixes == null || alltrue([
      for prefix in var.ipv6_prefixes : can(cidrhost(prefix, 0))
    ])
    error_message = "resource_aws_network_interface, ipv6_prefixes must contain valid IPv6 CIDR blocks."
  }
}

variable "private_ip_list" {
  description = "List of private IPs to assign to the ENI in sequential order"
  type        = list(string)
  default     = null

  validation {
    condition = var.private_ip_list == null || alltrue([
      for ip in var.private_ip_list : can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", ip))
    ])
    error_message = "resource_aws_network_interface, private_ip_list must contain valid IPv4 addresses."
  }
}

variable "private_ip_list_enabled" {
  description = "Whether private_ip_list is allowed and controls the IPs to assign to the ENI"
  type        = bool
  default     = false
}

variable "private_ips" {
  description = "List of private IPs to assign to the ENI without regard to order"
  type        = set(string)
  default     = null

  validation {
    condition = var.private_ips == null || alltrue([
      for ip in var.private_ips : can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", ip))
    ])
    error_message = "resource_aws_network_interface, private_ips must contain valid IPv4 addresses."
  }
}

variable "private_ips_count" {
  description = "Number of secondary private IPs to assign to the ENI"
  type        = number
  default     = null

  validation {
    condition     = var.private_ips_count == null || var.private_ips_count >= 0
    error_message = "resource_aws_network_interface, private_ips_count must be >= 0."
  }
}

variable "security_groups" {
  description = "List of security group IDs to assign to the ENI"
  type        = set(string)
  default     = null

  validation {
    condition = var.security_groups == null || alltrue([
      for sg in var.security_groups : can(regex("^sg-[0-9a-fA-F]{8,17}$", sg))
    ])
    error_message = "resource_aws_network_interface, security_groups must contain valid security group IDs starting with 'sg-'."
  }
}

variable "source_dest_check" {
  description = "Whether to enable source destination checking for the ENI"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = null
}