variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "cidr_ipv4" {
  description = "The destination IPv4 CIDR range."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_ipv4 == null || can(cidrhost(var.cidr_ipv4, 0))
    error_message = "resource_aws_vpc_security_group_egress_rule, cidr_ipv4 must be a valid IPv4 CIDR block."
  }
}

variable "cidr_ipv6" {
  description = "The destination IPv6 CIDR range."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_ipv6 == null || can(cidrhost(var.cidr_ipv6, 0))
    error_message = "resource_aws_vpc_security_group_egress_rule, cidr_ipv6 must be a valid IPv6 CIDR block."
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
    error_message = "resource_aws_vpc_security_group_egress_rule, from_port must be between -1 and 65535."
  }
}

variable "ip_protocol" {
  description = "The IP protocol name or number. Use -1 to specify all protocols. Note that if ip_protocol is set to -1, it translates to all protocols, all port ranges, and from_port and to_port values should not be defined."
  type        = string
  default     = null
}

variable "prefix_list_id" {
  description = "The ID of the destination prefix list."
  type        = string
  default     = null
}

variable "referenced_security_group_id" {
  description = "The destination security group that is referenced in the rule."
  type        = string
  default     = null
}

variable "security_group_id" {
  description = "The ID of the security group."
  type        = string

  validation {
    condition     = var.security_group_id != null && var.security_group_id != ""
    error_message = "resource_aws_vpc_security_group_egress_rule, security_group_id is required and cannot be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "to_port" {
  description = "The end of port range for the TCP and UDP protocols, or an ICMP/ICMPv6 code."
  type        = number
  default     = null

  validation {
    condition     = var.to_port == null || (var.to_port >= -1 && var.to_port <= 65535)
    error_message = "resource_aws_vpc_security_group_egress_rule, to_port must be between -1 and 65535."
  }
}