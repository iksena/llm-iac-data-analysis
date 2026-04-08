variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the rule."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_wafregional_rule, name must be between 1 and 128 characters."
  }
}

variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this rule."
  type        = string

  validation {
    condition     = can(regex("^[0-9A-Za-z]+$", var.metric_name)) && length(var.metric_name) > 0 && length(var.metric_name) <= 128
    error_message = "resource_aws_wafregional_rule, metric_name must contain only alphanumeric characters and be between 1 and 128 characters."
  }
}

variable "predicates" {
  description = "The objects to include in a rule."
  type = list(object({
    type    = string
    data_id = string
    negated = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for predicate in var.predicates : contains([
        "ByteMatch", "GeoMatch", "IPMatch", "RegexMatch",
        "SizeConstraint", "SqlInjectionMatch", "XssMatch"
      ], predicate.type)
    ])
    error_message = "resource_aws_wafregional_rule, predicate type must be one of: ByteMatch, GeoMatch, IPMatch, RegexMatch, SizeConstraint, SqlInjectionMatch, or XssMatch."
  }

  validation {
    condition = alltrue([
      for predicate in var.predicates : length(predicate.data_id) > 0
    ])
    error_message = "resource_aws_wafregional_rule, predicate data_id must not be empty."
  }

  validation {
    condition = alltrue([
      for predicate in var.predicates : can(tobool(predicate.negated))
    ])
    error_message = "resource_aws_wafregional_rule, predicate negated must be a boolean value."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}