variable "name" {
  description = "The name or description of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_rate_based_rule, name must not be empty."
  }
}

variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this rule"
  type        = string

  validation {
    condition     = length(var.metric_name) > 0
    error_message = "resource_aws_waf_rate_based_rule, metric_name must not be empty."
  }
}

variable "rate_key" {
  description = "Valid value is IP"
  type        = string

  validation {
    condition     = var.rate_key == "IP"
    error_message = "resource_aws_waf_rate_based_rule, rate_key must be 'IP'."
  }
}

variable "rate_limit" {
  description = "The maximum number of requests, which have an identical value in the field specified by the RateKey, allowed in a five-minute period. Minimum value is 100"
  type        = number

  validation {
    condition     = var.rate_limit >= 100
    error_message = "resource_aws_waf_rate_based_rule, rate_limit must be at least 100."
  }
}

variable "predicates" {
  description = "The objects to include in a rule"
  type = list(object({
    negated = bool
    data_id = string
    type    = string
  }))
  default = []

  validation {
    condition = alltrue([
      for predicate in var.predicates :
      contains(["ByteMatch", "GeoMatch", "IPMatch", "RegexMatch", "SizeConstraint", "SqlInjectionMatch", "XssMatch"], predicate.type)
    ])
    error_message = "resource_aws_waf_rate_based_rule, predicates type must be one of: ByteMatch, GeoMatch, IPMatch, RegexMatch, SizeConstraint, SqlInjectionMatch, XssMatch."
  }

  validation {
    condition = alltrue([
      for predicate in var.predicates :
      length(predicate.data_id) > 0
    ])
    error_message = "resource_aws_waf_rate_based_rule, predicates data_id must not be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}