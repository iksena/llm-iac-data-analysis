variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Security group description"
  type        = string
  default     = "Managed by Terraform"

  validation {
    condition     = var.description != ""
    error_message = "resource_aws_security_group, description cannot be empty string."
  }
}

variable "egress" {
  description = "Configuration block for egress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    description      = optional(string)
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.egress : (
        rule.cidr_blocks != null ||
        rule.ipv6_cidr_blocks != null ||
        rule.prefix_list_ids != null ||
        rule.security_groups != null ||
        rule.self == true
      ) if rule != null
    ])
    error_message = "resource_aws_security_group, egress must provide one of cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups, or self."
  }

  validation {
    condition = alltrue([
      for rule in var.egress : (
        rule.protocol == "-1" ? (rule.from_port == 0 && rule.to_port == 0) : true
      ) if rule != null
    ])
    error_message = "resource_aws_security_group, egress when protocol is -1, from_port and to_port must both be 0."
  }
}

variable "ingress" {
  description = "Configuration block for ingress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = string
    cidr_blocks      = optional(list(string))
    description      = optional(string)
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.ingress : (
        rule.cidr_blocks != null ||
        rule.ipv6_cidr_blocks != null ||
        rule.prefix_list_ids != null ||
        rule.security_groups != null ||
        rule.self == true
      ) if rule != null
    ])
    error_message = "resource_aws_security_group, ingress must provide one of cidr_blocks, ipv6_cidr_blocks, prefix_list_ids, security_groups, or self."
  }

  validation {
    condition = alltrue([
      for rule in var.ingress : (
        rule.protocol == "-1" ? (rule.from_port == 0 && rule.to_port == 0) : true
      ) if rule != null
    ])
    error_message = "resource_aws_security_group, ingress when protocol is -1, from_port and to_port must both be 0."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the security group"
  type        = string
  default     = null
}

locals {
  name_validation = var.name != null && var.name_prefix != null ? tobool("name and name_prefix cannot both be set") : true
}

variable "revoke_rules_on_delete" {
  description = "Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Create timeout"
  type        = string
  default     = "10m"
}

variable "timeouts_delete" {
  description = "Delete timeout"
  type        = string
  default     = "15m"
}