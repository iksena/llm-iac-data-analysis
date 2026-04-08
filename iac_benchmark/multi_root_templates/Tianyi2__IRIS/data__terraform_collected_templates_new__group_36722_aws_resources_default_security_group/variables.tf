variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID. Note that changing the vpc_id will not restore any default security group rules that were modified, added, or removed."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "egress" {
  description = "Configuration block for egress rules (VPC only)."
  type = list(object({
    cidr_blocks      = optional(list(string))
    description      = optional(string)
    from_port        = number
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    protocol         = string
    security_groups  = optional(list(string))
    self             = optional(bool)
    to_port          = number
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "resource_aws_default_security_group, egress from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "resource_aws_default_security_group, egress to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : rule.from_port <= rule.to_port
    ])
    error_message = "resource_aws_default_security_group, egress from_port must be less than or equal to to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.egress :
      rule.protocol == "-1" ? (rule.from_port == 0 && rule.to_port == 0) : true
    ])
    error_message = "resource_aws_default_security_group, egress protocol -1 requires from_port and to_port to be 0."
  }

  validation {
    condition = alltrue([
      for rule in var.egress :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol) || can(tonumber(rule.protocol))
    ])
    error_message = "resource_aws_default_security_group, egress protocol must be tcp, udp, icmp, -1, or a valid protocol number."
  }
}

variable "ingress" {
  description = "Configuration block for ingress rules."
  type = list(object({
    cidr_blocks      = optional(list(string))
    description      = optional(string)
    from_port        = number
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    protocol         = string
    security_groups  = optional(list(string))
    self             = optional(bool)
    to_port          = number
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.from_port >= 0 && rule.from_port <= 65535
    ])
    error_message = "resource_aws_default_security_group, ingress from_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.to_port >= 0 && rule.to_port <= 65535
    ])
    error_message = "resource_aws_default_security_group, ingress to_port must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : rule.from_port <= rule.to_port
    ])
    error_message = "resource_aws_default_security_group, ingress from_port must be less than or equal to to_port."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress :
      rule.protocol == "-1" ? (rule.from_port == 0 && rule.to_port == 0) : true
    ])
    error_message = "resource_aws_default_security_group, ingress protocol -1 requires from_port and to_port to be 0."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress :
      contains(["tcp", "udp", "icmp", "-1"], rule.protocol) || can(tonumber(rule.protocol))
    ])
    error_message = "resource_aws_default_security_group, ingress protocol must be tcp, udp, icmp, -1, or a valid protocol number."
  }
}