variable "name" {
  description = "A name that lets you identify the rule, to manage and use it"
  type        = string
}

variable "action" {
  description = "The action that DNS Firewall should take on a DNS query when it matches one of the domains in the rule's domain list"
  type        = string
  validation {
    condition     = contains(["ALLOW", "BLOCK", "ALERT"], var.action)
    error_message = "resource_aws_route53_resolver_firewall_rule, action must be one of: ALLOW, BLOCK, ALERT."
  }
}

variable "block_override_dns_type" {
  description = "The DNS record's type. This determines the format of the record value that you provided in BlockOverrideDomain. Required if block_response is OVERRIDE"
  type        = string
  default     = null
  validation {
    condition     = var.block_override_dns_type == null || var.block_override_dns_type == "CNAME"
    error_message = "resource_aws_route53_resolver_firewall_rule, block_override_dns_type must be CNAME when specified."
  }
}

variable "block_override_domain" {
  description = "The custom DNS record to send back in response to the query. Required if block_response is OVERRIDE"
  type        = string
  default     = null
}

variable "block_override_ttl" {
  description = "The recommended amount of time, in seconds, for the DNS resolver or web browser to cache the provided override record. Required if block_response is OVERRIDE"
  type        = number
  default     = null
  validation {
    condition     = var.block_override_ttl == null || (var.block_override_ttl >= 0 && var.block_override_ttl <= 604800)
    error_message = "resource_aws_route53_resolver_firewall_rule, block_override_ttl must be between 0 and 604800 seconds when specified."
  }
}

variable "block_response" {
  description = "The way that you want DNS Firewall to block the request. Required if action is BLOCK"
  type        = string
  default     = null
  validation {
    condition     = var.block_response == null || contains(["NODATA", "NXDOMAIN", "OVERRIDE"], var.block_response)
    error_message = "resource_aws_route53_resolver_firewall_rule, block_response must be one of: NODATA, NXDOMAIN, OVERRIDE when specified."
  }
}

variable "firewall_domain_list_id" {
  description = "The ID of the domain list that you want to use in the rule"
  type        = string
}

variable "firewall_domain_redirection_action" {
  description = "Evaluate DNS redirection in the DNS redirection chain, such as CNAME, DNAME, ot ALIAS"
  type        = string
  default     = "INSPECT_REDIRECTION_DOMAIN"
  validation {
    condition     = contains(["INSPECT_REDIRECTION_DOMAIN", "TRUST_REDIRECTION_DOMAIN"], var.firewall_domain_redirection_action)
    error_message = "resource_aws_route53_resolver_firewall_rule, firewall_domain_redirection_action must be one of: INSPECT_REDIRECTION_DOMAIN, TRUST_REDIRECTION_DOMAIN."
  }
}

variable "firewall_rule_group_id" {
  description = "The unique identifier of the firewall rule group where you want to create the rule"
  type        = string
}

variable "priority" {
  description = "The setting that determines the processing order of the rule in the rule group. DNS Firewall processes the rules in a rule group by order of priority, starting from the lowest setting"
  type        = number
}

variable "q_type" {
  description = "The query type you want the rule to evaluate"
  type        = string
  default     = null
}