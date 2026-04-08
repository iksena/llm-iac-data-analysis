variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "The suffix domain name to use by default when resolving non Fully Qualified Domain Names. In other words, this is what ends up being the search value in the /etc/resolv.conf file."
  type        = string
  default     = null
}

variable "domain_name_servers" {
  description = "List of name servers to configure in /etc/resolv.conf. If you want to use the default AWS nameservers you should set this to AmazonProvidedDNS."
  type        = list(string)
  default     = null

  validation {
    condition     = var.domain_name_servers == null || length(var.domain_name_servers) <= 4
    error_message = "resource_aws_vpc_dhcp_options, domain_name_servers are limited by AWS to maximum four servers only."
  }
}

variable "ipv6_address_preferred_lease_time" {
  description = "How frequently, in seconds, a running instance with an IPv6 assigned to it goes through DHCPv6 lease renewal. Acceptable values are between 140 and 2147483647 (approximately 68 years). If no value is entered, the default lease time is 140 seconds."
  type        = number
  default     = null

  validation {
    condition     = var.ipv6_address_preferred_lease_time == null || (var.ipv6_address_preferred_lease_time >= 140 && var.ipv6_address_preferred_lease_time <= 2147483647)
    error_message = "resource_aws_vpc_dhcp_options, ipv6_address_preferred_lease_time must be between 140 and 2147483647 seconds."
  }
}

variable "ntp_servers" {
  description = "List of NTP servers to configure."
  type        = list(string)
  default     = null

  validation {
    condition     = var.ntp_servers == null || length(var.ntp_servers) <= 4
    error_message = "resource_aws_vpc_dhcp_options, ntp_servers are limited by AWS to maximum four servers only."
  }
}

variable "netbios_name_servers" {
  description = "List of NETBIOS name servers."
  type        = list(string)
  default     = null

  validation {
    condition     = var.netbios_name_servers == null || length(var.netbios_name_servers) <= 4
    error_message = "resource_aws_vpc_dhcp_options, netbios_name_servers are limited by AWS to maximum four servers only."
  }
}

variable "netbios_node_type" {
  description = "The NetBIOS node type (1, 2, 4, or 8). AWS recommends to specify 2 since broadcast and multicast are not supported in their network."
  type        = number
  default     = null

  validation {
    condition     = var.netbios_node_type == null || contains([1, 2, 4, 8], var.netbios_node_type)
    error_message = "resource_aws_vpc_dhcp_options, netbios_node_type must be one of: 1, 2, 4, or 8."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}