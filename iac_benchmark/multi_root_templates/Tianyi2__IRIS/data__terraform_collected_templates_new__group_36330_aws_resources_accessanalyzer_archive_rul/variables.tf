variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "analyzer_name" {
  description = "Analyzer name."
  type        = string

  validation {
    condition     = length(var.analyzer_name) > 0
    error_message = "resource_aws_accessanalyzer_archive_rule, analyzer_name must not be empty."
  }
}

variable "rule_name" {
  description = "Rule name."
  type        = string

  validation {
    condition     = length(var.rule_name) > 0
    error_message = "resource_aws_accessanalyzer_archive_rule, rule_name must not be empty."
  }
}

variable "filter" {
  description = "Filter criteria for the archive rule. One comparator must be included with each filter."
  type = list(object({
    criteria = string
    contains = optional(list(string))
    eq       = optional(list(string))
    exists   = optional(bool)
    neq      = optional(list(string))
  }))

  validation {
    condition     = length(var.filter) > 0
    error_message = "resource_aws_accessanalyzer_archive_rule, filter must contain at least one filter block."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.criteria) > 0
    ])
    error_message = "resource_aws_accessanalyzer_archive_rule, filter criteria must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : (
        (f.contains != null ? 1 : 0) +
        (f.eq != null ? 1 : 0) +
        (f.exists != null ? 1 : 0) +
        (f.neq != null ? 1 : 0)
      ) >= 1
    ])
    error_message = "resource_aws_accessanalyzer_archive_rule, filter must include at least one comparator (contains, eq, exists, or neq)."
  }
}