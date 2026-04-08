variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this rule."
  type        = string

  validation {
    condition     = length(var.metric_name) > 0
    error_message = "resource_aws_wafregional_rate_based_rule, metric_name must not be empty."
  }
}

variable "name" {
  description = "The name or description of the rule."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_wafregional_rate_based_rule, name must not be empty."
  }
}

variable "rate_key" {
  description = "Valid value is IP."
  type        = string

  validation {
    condition     = var.rate_key == "IP"
    error_message = "resource_aws_wafregional_rate_based_rule, rate_key must be 'IP'."
  }
}

variable "rate_limit" {
  description = "The maximum number of requests, which have an identical value in the field specified by the RateKey, allowed in a five-minute period. Minimum value is 100."
  type        = number

  validation {
    condition     = var.rate_limit >= 100
    error_message = "resource_aws_wafregional_rate_based_rule, rate_limit must be at least 100."
  }
}

variable "predicate" {
  description = "The objects to include in a rule."
  type = list(object({
    negated = bool
    data_id = string
    type    = string
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.predicate : contains([
        "ByteMatch",
        "GeoMatch",
        "IPMatch",
        "RegexMatch",
        "SizeConstraint",
        "SqlInjectionMatch",
        "XssMatch"
      ], p.type)
    ])
    error_message = "resource_aws_wafregional_rate_based_rule, predicate type must be one of: ByteMatch, GeoMatch, IPMatch, RegexMatch, SizeConstraint, SqlInjectionMatch, or XssMatch."
  }

  validation {
    condition = alltrue([
      for p in var.predicate : length(p.data_id) > 0
    ])
    error_message = "resource_aws_wafregional_rate_based_rule, predicate data_id must not be empty."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}