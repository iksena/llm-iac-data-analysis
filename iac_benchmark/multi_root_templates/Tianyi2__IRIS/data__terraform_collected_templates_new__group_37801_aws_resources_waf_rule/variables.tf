variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this rule. The name can contain only alphanumeric characters (A-Z, a-z, 0-9); the name can't contain whitespace."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9]+$", var.metric_name))
    error_message = "resource_aws_waf_rule, metric_name must contain only alphanumeric characters (A-Z, a-z, 0-9) and cannot contain whitespace."
  }
}

variable "name" {
  description = "The name or description of the rule."
  type        = string
}

variable "predicates" {
  description = "The objects to include in a rule."
  type = list(object({
    negated = bool
    data_id = string
    type    = string
  }))
  default = []

  validation {
    condition = alltrue([
      for predicate in var.predicates : contains([
        "ByteMatch", "GeoMatch", "IPMatch", "RegexMatch", "SizeConstraint", "SqlInjectionMatch", "XssMatch"
      ], predicate.type)
    ])
    error_message = "resource_aws_waf_rule, predicates type must be one of: ByteMatch, GeoMatch, IPMatch, RegexMatch, SizeConstraint, SqlInjectionMatch, or XssMatch."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}