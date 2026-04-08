variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "network_acl_id" {
  description = "The ID of the network ACL."
  type        = string

  validation {
    condition     = can(regex("^acl-[0-9a-f]{8,17}$", var.network_acl_id))
    error_message = "resource_aws_network_acl_rule, network_acl_id must be a valid Network ACL ID (format: acl-xxxxxxxx)."
  }
}

variable "rule_number" {
  description = "The rule number for the entry (for example, 100). ACL entries are processed in ascending order by rule number."
  type        = number

  validation {
    condition     = var.rule_number >= 1 && var.rule_number <= 32766
    error_message = "resource_aws_network_acl_rule, rule_number must be between 1 and 32766."
  }
}

variable "egress" {
  description = "Indicates whether this is an egress rule (rule is applied to traffic leaving the subnet). Default false."
  type        = bool
  default     = false
}

variable "protocol" {
  description = "The protocol. A value of -1 means all protocols."
  type        = string

  validation {
    condition = can(tonumber(var.protocol)) ? (
      tonumber(var.protocol) >= -1 && tonumber(var.protocol) <= 255
      ) : contains([
        "tcp", "udp", "icmp", "icmpv6", "ah", "esp", "gre", "ipv6", "all"
    ], lower(var.protocol))
    error_message = "resource_aws_network_acl_rule, protocol must be a valid protocol number (-1 to 255) or protocol name (tcp, udp, icmp, etc.)."
  }
}

variable "rule_action" {
  description = "Indicates whether to allow or deny the traffic that matches the rule. Accepted values: allow | deny"
  type        = string

  validation {
    condition     = contains(["allow", "deny"], var.rule_action)
    error_message = "resource_aws_network_acl_rule, rule_action must be either 'allow' or 'deny'."
  }
}

variable "cidr_block" {
  description = "The network range to allow or deny, in CIDR notation (for example 172.16.0.0/24)."
  type        = string
  default     = null

  validation {
    condition     = var.cidr_block == null || can(cidrhost(var.cidr_block, 0))
    error_message = "resource_aws_network_acl_rule, cidr_block must be a valid CIDR block notation."
  }
}

variable "ipv6_cidr_block" {
  description = "The IPv6 CIDR block to allow or deny."
  type        = string
  default     = null

  validation {
    condition     = var.ipv6_cidr_block == null || can(cidrhost(var.ipv6_cidr_block, 0))
    error_message = "resource_aws_network_acl_rule, ipv6_cidr_block must be a valid IPv6 CIDR block notation."
  }
}

variable "from_port" {
  description = "The from port to match."
  type        = number
  default     = null

  validation {
    condition     = var.from_port == null || (var.from_port >= 0 && var.from_port <= 65535)
    error_message = "resource_aws_network_acl_rule, from_port must be between 0 and 65535."
  }
}

variable "to_port" {
  description = "The to port to match."
  type        = number
  default     = null

  validation {
    condition     = var.to_port == null || (var.to_port >= 0 && var.to_port <= 65535)
    error_message = "resource_aws_network_acl_rule, to_port must be between 0 and 65535."
  }
}

variable "icmp_type" {
  description = "ICMP protocol: The ICMP type. Required if specifying ICMP for the protocol. E.g., -1"
  type        = number
  default     = null

  validation {
    condition     = var.icmp_type == null || (var.icmp_type >= -1 && var.icmp_type <= 255)
    error_message = "resource_aws_network_acl_rule, icmp_type must be between -1 and 255."
  }
}

variable "icmp_code" {
  description = "ICMP protocol: The ICMP code. Required if specifying ICMP for the protocol. E.g., -1"
  type        = number
  default     = null

  validation {
    condition     = var.icmp_code == null || (var.icmp_code >= -1 && var.icmp_code <= 255)
    error_message = "resource_aws_network_acl_rule, icmp_code must be between -1 and 255."
  }
}