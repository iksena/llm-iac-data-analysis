variable "from_port" {
  description = "Start port (or ICMP type number if protocol is \"icmp\" or \"icmpv6\")"
  type        = number
}

variable "protocol" {
  description = "Protocol. If not icmp, icmpv6, tcp, udp, or all use the protocol number"
  type        = string
}

variable "security_group_id" {
  description = "Security group to apply this rule to"
  type        = string
}

variable "to_port" {
  description = "End port (or ICMP code if protocol is \"icmp\")"
  type        = number
}

variable "type" {
  description = "Type of rule being created. Valid options are ingress (inbound) or egress (outbound)"
  type        = string

  validation {
    condition     = contains(["ingress", "egress"], var.type)
    error_message = "resource_aws_security_group_rule, type must be either 'ingress' or 'egress'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "cidr_blocks" {
  description = "List of CIDR blocks. Cannot be specified with source_security_group_id or self"
  type        = list(string)
  default     = null

  validation {
    condition = var.cidr_blocks == null ? true : alltrue([
      for cidr in var.cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_security_group_rule, cidr_blocks must contain valid CIDR notation."
  }
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = null
}

variable "ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR blocks. Cannot be specified with source_security_group_id or self"
  type        = list(string)
  default     = null

  validation {
    condition = var.ipv6_cidr_blocks == null ? true : alltrue([
      for cidr in var.ipv6_cidr_blocks : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_security_group_rule, ipv6_cidr_blocks must contain valid IPv6 CIDR notation."
  }
}

variable "prefix_list_ids" {
  description = "List of Prefix List IDs"
  type        = list(string)
  default     = null
}

variable "self" {
  description = "Whether the security group itself will be added as a source to this ingress rule. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or source_security_group_id"
  type        = bool
  default     = null
}

variable "source_security_group_id" {
  description = "Security group id to allow access to/from, depending on the type. Cannot be specified with cidr_blocks, ipv6_cidr_blocks, or self"
  type        = string
  default     = null
}

variable "timeout_create" {
  description = "How long to wait for the security group rule to be created"
  type        = string
  default     = "5m"
}

