variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "The ID of the associated VPC"
  type        = string

  validation {
    condition     = can(regex("^vpc-[a-zA-Z0-9]{8,17}$", var.vpc_id))
    error_message = "resource_aws_network_acl, vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "subnet_ids" {
  description = "A list of Subnet IDs to apply the ACL to"
  type        = list(string)
  default     = null

  validation {
    condition = var.subnet_ids == null ? true : alltrue([
      for subnet_id in var.subnet_ids : can(regex("^subnet-[a-zA-Z0-9]{8,17}$", subnet_id))
    ])
    error_message = "resource_aws_network_acl, subnet_ids must be a list of valid subnet IDs starting with 'subnet-'."
  }
}

variable "ingress" {
  description = "Ingress rules for the network ACL"
  type = list(object({
    from_port       = number
    to_port         = number
    rule_no         = number
    action          = string
    protocol        = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "resource_aws_network_acl, ingress from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "resource_aws_network_acl, ingress to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.rule_no >= 1 && rule.rule_no <= 32766
    ])
    error_message = "resource_aws_network_acl, ingress rule_no must be between 1 and 32766."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : contains(["allow", "deny"], rule.action)
    ])
    error_message = "resource_aws_network_acl, ingress action must be either 'allow' or 'deny'."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.protocol == "-1" || can(tonumber(rule.protocol)) || contains(["tcp", "udp", "icmp"], rule.protocol)
    ])
    error_message = "resource_aws_network_acl, ingress protocol must be a valid protocol number, 'tcp', 'udp', 'icmp', or '-1'."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.cidr_block == null || can(cidrnetmask(rule.cidr_block))
    ])
    error_message = "resource_aws_network_acl, ingress cidr_block must be a valid CIDR block."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.icmp_type == null || (rule.icmp_type >= -1 && rule.icmp_type <= 255)
    ])
    error_message = "resource_aws_network_acl, ingress icmp_type must be between -1 and 255."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.icmp_code == null || (rule.icmp_code >= -1 && rule.icmp_code <= 255)
    ])
    error_message = "resource_aws_network_acl, ingress icmp_code must be between -1 and 255."
  }
}

variable "egress" {
  description = "Egress rules for the network ACL"
  type = list(object({
    from_port       = number
    to_port         = number
    rule_no         = number
    action          = string
    protocol        = string
    cidr_block      = optional(string)
    ipv6_cidr_block = optional(string)
    icmp_type       = optional(number)
    icmp_code       = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "resource_aws_network_acl, egress from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "resource_aws_network_acl, egress to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.rule_no >= 1 && rule.rule_no <= 32766
    ])
    error_message = "resource_aws_network_acl, egress rule_no must be between 1 and 32766."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : contains(["allow", "deny"], rule.action)
    ])
    error_message = "resource_aws_network_acl, egress action must be either 'allow' or 'deny'."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.protocol == "-1" || can(tonumber(rule.protocol)) || contains(["tcp", "udp", "icmp"], rule.protocol)
    ])
    error_message = "resource_aws_network_acl, egress protocol must be a valid protocol number, 'tcp', 'udp', 'icmp', or '-1'."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.cidr_block == null || can(cidrnetmask(rule.cidr_block))
    ])
    error_message = "resource_aws_network_acl, egress cidr_block must be a valid CIDR block."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.icmp_type == null || (rule.icmp_type >= -1 && rule.icmp_type <= 255)
    ])
    error_message = "resource_aws_network_acl, egress icmp_type must be between -1 and 255."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.icmp_code == null || (rule.icmp_code >= -1 && rule.icmp_code <= 255)
    ])
    error_message = "resource_aws_network_acl, egress icmp_code must be between -1 and 255."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}