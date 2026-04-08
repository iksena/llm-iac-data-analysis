variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "DNS queries for this domain name are forwarded to the IP addresses that are specified using target_ip."
  type        = string
}

variable "rule_type" {
  description = "Rule type. Valid values are FORWARD, SYSTEM and RECURSIVE."
  type        = string

  validation {
    condition     = contains(["FORWARD", "SYSTEM", "RECURSIVE"], var.rule_type)
    error_message = "resource_aws_route53_resolver_rule, rule_type must be one of: FORWARD, SYSTEM, RECURSIVE."
  }
}

variable "name" {
  description = "Friendly name that lets you easily find a rule in the Resolver dashboard in the Route 53 console."
  type        = string
  default     = null
}

variable "resolver_endpoint_id" {
  description = "ID of the outbound resolver endpoint that you want to use to route DNS queries to the IP addresses that you specify using target_ip. This argument should only be specified for FORWARD type rules."
  type        = string
  default     = null
}

variable "target_ip" {
  description = "Configuration block(s) indicating the IPs that you want Resolver to forward DNS queries to. This argument should only be specified for FORWARD type rules."
  type = list(object({
    ip       = optional(string)
    ipv6     = optional(string)
    port     = optional(number, 53)
    protocol = optional(string, "Do53")
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.target_ip : (target.ip != null && target.ipv6 == null) || (target.ip == null && target.ipv6 != null)
    ])
    error_message = "resource_aws_route53_resolver_rule, target_ip must specify either ip or ipv6, but not both."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}