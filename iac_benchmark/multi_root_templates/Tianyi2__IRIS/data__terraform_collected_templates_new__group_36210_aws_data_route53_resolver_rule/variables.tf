variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name the desired resolver rule forwards DNS queries for"
  type        = string
  default     = null
}

variable "name" {
  description = "Friendly name of the desired resolver rule"
  type        = string
  default     = null
}

variable "resolver_endpoint_id" {
  description = "ID of the outbound resolver endpoint of the desired resolver rule"
  type        = string
  default     = null
}

variable "resolver_rule_id" {
  description = "ID of the desired resolver rule"
  type        = string
  default     = null
}

variable "rule_type" {
  description = "Rule type of the desired resolver rule"
  type        = string
  default     = null

  validation {
    condition     = var.rule_type == null || contains(["FORWARD", "SYSTEM", "RECURSIVE"], var.rule_type)
    error_message = "data_aws_route53_resolver_rule, rule_type must be one of: FORWARD, SYSTEM, RECURSIVE."
  }
}