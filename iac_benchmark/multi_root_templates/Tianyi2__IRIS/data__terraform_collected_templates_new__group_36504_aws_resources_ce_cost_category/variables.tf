variable "name" {
  description = "Unique name for the Cost Category"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ce_cost_category, name must not be empty."
  }
}

variable "rule_version" {
  description = "Rule schema version in this particular Cost Category"
  type        = string

  validation {
    condition     = var.rule_version != ""
    error_message = "resource_aws_ce_cost_category, rule_version must not be empty."
  }
}

variable "rules" {
  description = "Configuration block for the Cost Category rules used to categorize costs"
  type = list(object({
    value = optional(string)
    type  = optional(string)
    inherited_value = optional(object({
      dimension_key  = optional(string)
      dimension_name = optional(string)
    }))
    rule = optional(object({
      and = optional(list(object({
        cost_category = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
        dimension = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
        tags = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
      })))
      or = optional(list(object({
        cost_category = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
        dimension = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
        tags = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
      })))
      not = optional(object({
        cost_category = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
        dimension = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
        tags = optional(object({
          key           = optional(string)
          values        = optional(list(string))
          match_options = optional(list(string))
        }))
      }))
      cost_category = optional(object({
        key           = optional(string)
        values        = optional(list(string))
        match_options = optional(list(string))
      }))
      dimension = optional(object({
        key           = optional(string)
        values        = optional(list(string))
        match_options = optional(list(string))
      }))
      tags = optional(object({
        key           = optional(string)
        values        = optional(list(string))
        match_options = optional(list(string))
      }))
    }))
  }))

  validation {
    condition     = length(var.rules) > 0
    error_message = "resource_aws_ce_cost_category, rules must contain at least one rule."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : rule.type == null || contains(["REGULAR", "INHERITED_VALUE"], rule.type)
    ])
    error_message = "resource_aws_ce_cost_category, rule type must be either 'REGULAR' or 'INHERITED_VALUE'."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.inherited_value == null || rule.inherited_value.dimension_name == null || contains(["LINKED_ACCOUNT_NAME", "TAG"], rule.inherited_value.dimension_name)
    ])
    error_message = "resource_aws_ce_cost_category, inherited_value dimension_name must be either 'LINKED_ACCOUNT_NAME' or 'TAG'."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for and_rule in(rule.rule != null && rule.rule.and != null ? rule.rule.and : []) : [
          for match_option in(and_rule.cost_category != null && and_rule.cost_category.match_options != null ? and_rule.cost_category.match_options : []) :
          contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
        ]
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, cost_category match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for and_rule in(rule.rule != null && rule.rule.and != null ? rule.rule.and : []) : [
          for match_option in(and_rule.dimension != null && and_rule.dimension.match_options != null ? and_rule.dimension.match_options : []) :
          contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
        ]
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, dimension match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for and_rule in(rule.rule != null && rule.rule.and != null ? rule.rule.and : []) : [
          for match_option in(and_rule.tags != null && and_rule.tags.match_options != null ? and_rule.tags.match_options : []) :
          contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
        ]
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, tags match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for or_rule in(rule.rule != null && rule.rule.or != null ? rule.rule.or : []) : [
          for match_option in(or_rule.cost_category != null && or_rule.cost_category.match_options != null ? or_rule.cost_category.match_options : []) :
          contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
        ]
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, cost_category match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for or_rule in(rule.rule != null && rule.rule.or != null ? rule.rule.or : []) : [
          for match_option in(or_rule.dimension != null && or_rule.dimension.match_options != null ? or_rule.dimension.match_options : []) :
          contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
        ]
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, dimension match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for or_rule in(rule.rule != null && rule.rule.or != null ? rule.rule.or : []) : [
          for match_option in(or_rule.tags != null && or_rule.tags.match_options != null ? or_rule.tags.match_options : []) :
          contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
        ]
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, tags match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for match_option in(rule.rule != null && rule.rule.not != null && rule.rule.not.cost_category != null && rule.rule.not.cost_category.match_options != null ? rule.rule.not.cost_category.match_options : []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, cost_category match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for match_option in(rule.rule != null && rule.rule.not != null && rule.rule.not.dimension != null && rule.rule.not.dimension.match_options != null ? rule.rule.not.dimension.match_options : []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, dimension match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for match_option in(rule.rule != null && rule.rule.not != null && rule.rule.not.tags != null && rule.rule.not.tags.match_options != null ? rule.rule.not.tags.match_options : []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, tags match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for match_option in(rule.rule != null && rule.rule.cost_category != null && rule.rule.cost_category.match_options != null ? rule.rule.cost_category.match_options : []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, cost_category match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for match_option in(rule.rule != null && rule.rule.dimension != null && rule.rule.dimension.match_options != null ? rule.rule.dimension.match_options : []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, dimension match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for match_option in(rule.rule != null && rule.rule.tags != null && rule.rule.tags.match_options != null ? rule.rule.tags.match_options : []) :
        contains(["EQUALS", "ABSENT", "STARTS_WITH", "ENDS_WITH", "CONTAINS", "CASE_SENSITIVE", "CASE_INSENSITIVE"], match_option)
      ]
    ]))
    error_message = "resource_aws_ce_cost_category, tags match_options must be valid values: EQUALS, ABSENT, STARTS_WITH, ENDS_WITH, CONTAINS, CASE_SENSITIVE, CASE_INSENSITIVE."
  }
}

variable "default_value" {
  description = "Default value for the cost category"
  type        = string
  default     = null
}

variable "effective_start" {
  description = "The Cost Category's effective start date. It can only be a billing start date (first day of the month)"
  type        = string
  default     = null

  validation {
    condition     = var.effective_start == null || can(formatdate("2006-01-02T15:04:05Z", var.effective_start))
    error_message = "resource_aws_ce_cost_category, effective_start must be in ISO 8601 format (e.g., 2022-11-01T00:00:00Z)."
  }
}

variable "split_charge_rules" {
  description = "Configuration block for the split charge rules used to allocate your charges between your Cost Category values"
  type = list(object({
    method  = string
    source  = string
    targets = list(string)
    parameter = optional(object({
      type   = optional(string)
      values = optional(list(string))
    }))
  }))
  default = null

  validation {
    condition = var.split_charge_rules == null || alltrue([
      for rule in var.split_charge_rules : contains(["FIXED", "PROPORTIONAL", "EVEN"], rule.method)
    ])
    error_message = "resource_aws_ce_cost_category, split_charge_rule method must be one of: FIXED, PROPORTIONAL, EVEN."
  }

  validation {
    condition = var.split_charge_rules == null || alltrue([
      for rule in var.split_charge_rules : length(rule.targets) > 0
    ])
    error_message = "resource_aws_ce_cost_category, split_charge_rule targets must contain at least one target."
  }

  validation {
    condition = var.split_charge_rules == null || alltrue([
      for rule in var.split_charge_rules : rule.source != ""
    ])
    error_message = "resource_aws_ce_cost_category, split_charge_rule source must not be empty."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}