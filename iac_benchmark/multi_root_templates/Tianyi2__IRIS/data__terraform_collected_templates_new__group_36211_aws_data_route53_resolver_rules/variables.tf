variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name_regex" {
  description = "Regex string to filter resolver rule names. The filtering is done locally, so could have a performance impact if the result is large. This argument should be used along with other arguments to limit the number of results returned."
  type        = string
  default     = null
}

variable "owner_id" {
  description = "When the desired resolver rules are shared with another AWS account, the account ID of the account that the rules are shared with."
  type        = string
  default     = null
}

variable "resolver_endpoint_id" {
  description = "ID of the outbound resolver endpoint for the desired resolver rules."
  type        = string
  default     = null
}

variable "rule_type" {
  description = "Rule type of the desired resolver rules. Valid values are FORWARD, SYSTEM and RECURSIVE."
  type        = string
  default     = null

  validation {
    condition     = var.rule_type == null || contains(["FORWARD", "SYSTEM", "RECURSIVE"], var.rule_type)
    error_message = "data_aws_route53_resolver_rules, rule_type must be one of: FORWARD, SYSTEM, RECURSIVE."
  }
}

variable "share_status" {
  description = "Whether the desired resolver rules are shared and, if so, whether the current account is sharing the rules with another account, or another account is sharing the rules with the current account. Valid values are NOT_SHARED, SHARED_BY_ME or SHARED_WITH_ME."
  type        = string
  default     = null

  validation {
    condition     = var.share_status == null || contains(["NOT_SHARED", "SHARED_BY_ME", "SHARED_WITH_ME"], var.share_status)
    error_message = "data_aws_route53_resolver_rules, share_status must be one of: NOT_SHARED, SHARED_BY_ME, SHARED_WITH_ME."
  }
}