variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr_ipv4" {
  description = "The source IPv4 CIDR range."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_ipv4 == null || can(cidrhost(var.cidr_ipv4, 0))
    error_message = "resource_aws_vpc_security_group_ingress_rule, cidr_ipv4 must be a valid IPv4 CIDR block."
  }
}

variable "cidr_ipv6" {
  description = "The source IPv6 CIDR range."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_ipv6 == null || can(cidrhost(var.cidr_ipv6, 0))
    error_message = "resource_aws_vpc_security_group_ingress_rule, cidr_ipv6 must be a valid IPv6 CIDR block."
  }
}

variable "description" {
  description = "The security group rule description."
  type        = string
  default     = null
}

variable "from_port" {
  description = "The start of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 type."
  type        = number
  default     = null

  validation {
    condition     = var.from_port == null || (var.from_port >= -1 && var.from_port <= 65535)
    error_message = "resource_aws_vpc_security_group_ingress_rule, from_port must be between -1 and 65535."
  }
}

variable "ip_protocol" {
  description = "The IP protocol name or number. Use -1 to specify all protocols."
  type        = string

  validation {
    condition = can(tonumber(var.ip_protocol)) || contains([
      "tcp", "udp", "icmp", "icmpv6", "ah", "esp", "gre", "ipv6-icmp", "ospf", "pim", "vrrp", "-1"
    ], var.ip_protocol)
    error_message = "resource_aws_vpc_security_group_ingress_rule, ip_protocol must be a valid protocol name or number."
  }
}

variable "prefix_list_id" {
  description = "The ID of the source prefix list."
  type        = string
  default     = null

  validation {
    condition     = var.prefix_list_id == null || can(regex("^pl-[0-9a-f]+$", var.prefix_list_id))
    error_message = "resource_aws_vpc_security_group_ingress_rule, prefix_list_id must be a valid prefix list ID starting with 'pl-'."
  }
}

variable "referenced_security_group_id" {
  description = "The source security group that is referenced in the rule."
  type        = string
  default     = null

  validation {
    condition     = var.referenced_security_group_id == null || can(regex("^sg-[0-9a-f]+$", var.referenced_security_group_id))
    error_message = "resource_aws_vpc_security_group_ingress_rule, referenced_security_group_id must be a valid security group ID starting with 'sg-'."
  }
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string

  validation {
    condition     = can(regex("^sg-[0-9a-f]+$", var.security_group_id))
    error_message = "resource_aws_vpc_security_group_ingress_rule, security_group_id must be a valid security group ID starting with 'sg-'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k))])
    error_message = "resource_aws_vpc_security_group_ingress_rule, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_vpc_security_group_ingress_rule, tags values must be between 0 and 256 characters."
  }
}

variable "to_port" {
  description = "The end of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 code."
  type        = number
  default     = null

  validation {
    condition     = var.to_port == null || (var.to_port >= -1 && var.to_port <= 65535)
    error_message = "resource_aws_vpc_security_group_ingress_rule, to_port must be between -1 and 65535."
  }
}