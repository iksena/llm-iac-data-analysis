variable "default_network_acl_id" {
  description = "Network ACL ID to manage. This attribute is exported from aws_vpc, or manually found via the AWS Console."
  type        = string

  validation {
    condition     = length(var.default_network_acl_id) > 0
    error_message = "resource_aws_default_network_acl, default_network_acl_id cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of Subnet IDs to apply the ACL to."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "ingress" {
  description = "Configuration block for ingress rules"
  type = list(object({
    action          = string
    from_port       = number
    protocol        = string
    rule_no         = number
    to_port         = number
    cidr_block      = optional(string)
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress : contains(["allow", "deny"], rule.action)
    ])
    error_message = "resource_aws_default_network_acl, ingress action must be either 'allow' or 'deny'."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "resource_aws_default_network_acl, ingress from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "resource_aws_default_network_acl, ingress to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.rule_no >= 1 && rule.rule_no <= 32766
    ])
    error_message = "resource_aws_default_network_acl, ingress rule_no must be between 1 and 32766."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress :
      rule.protocol == "-1" ? (rule.from_port == 0 && rule.to_port == 0) : true
    ])
    error_message = "resource_aws_default_network_acl, ingress when using protocol -1 (all), from_port and to_port must be 0."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress :
      rule.cidr_block != null ? can(cidrhost(rule.cidr_block, 0)) : true
    ])
    error_message = "resource_aws_default_network_acl, ingress cidr_block must be a valid network mask."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress :
      rule.icmp_code != null ? (rule.icmp_code >= -1 && rule.icmp_code <= 255) : true
    ])
    error_message = "resource_aws_default_network_acl, ingress icmp_code must be between -1 and 255."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress :
      rule.icmp_type != null ? (rule.icmp_type >= -1 && rule.icmp_type <= 255) : true
    ])
    error_message = "resource_aws_default_network_acl, ingress icmp_type must be between -1 and 255."
  }
}

variable "egress" {
  description = "Configuration block for egress rules"
  type = list(object({
    action          = string
    from_port       = number
    protocol        = string
    rule_no         = number
    to_port         = number
    cidr_block      = optional(string)
    icmp_code       = optional(number)
    icmp_type       = optional(number)
    ipv6_cidr_block = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress : contains(["allow", "deny"], rule.action)
    ])
    error_message = "resource_aws_default_network_acl, egress action must be either 'allow' or 'deny'."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "resource_aws_default_network_acl, egress from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "resource_aws_default_network_acl, egress to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.rule_no >= 1 && rule.rule_no <= 32766
    ])
    error_message = "resource_aws_default_network_acl, egress rule_no must be between 1 and 32766."
  }

  validation {
    condition = alltrue([
      for rule in var.egress :
      rule.protocol == "-1" ? (rule.from_port == 0 && rule.to_port == 0) : true
    ])
    error_message = "resource_aws_default_network_acl, egress when using protocol -1 (all), from_port and to_port must be 0."
  }

  validation {
    condition = alltrue([
      for rule in var.egress :
      rule.cidr_block != null ? can(cidrhost(rule.cidr_block, 0)) : true
    ])
    error_message = "resource_aws_default_network_acl, egress cidr_block must be a valid network mask."
  }

  validation {
    condition = alltrue([
      for rule in var.egress :
      rule.icmp_code != null ? (rule.icmp_code >= -1 && rule.icmp_code <= 255) : true
    ])
    error_message = "resource_aws_default_network_acl, egress icmp_code must be between -1 and 255."
  }

  validation {
    condition = alltrue([
      for rule in var.egress :
      rule.icmp_type != null ? (rule.icmp_type >= -1 && rule.icmp_type <= 255) : true
    ])
    error_message = "resource_aws_default_network_acl, egress icmp_type must be between -1 and 255."
  }
}