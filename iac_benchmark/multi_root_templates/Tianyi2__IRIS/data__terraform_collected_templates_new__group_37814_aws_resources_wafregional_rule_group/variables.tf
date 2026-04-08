variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A friendly name of the rule group"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_wafregional_rule_group, name must not be empty."
  }
}

variable "metric_name" {
  description = "A friendly name for the metrics from the rule group"
  type        = string

  validation {
    condition     = length(var.metric_name) > 0
    error_message = "resource_aws_wafregional_rule_group, metric_name must not be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.metric_name))
    error_message = "resource_aws_wafregional_rule_group, metric_name must contain only alphanumeric characters."
  }
}

variable "activated_rule" {
  description = "A list of activated rules"
  type = list(object({
    action = object({
      type = string
    })
    priority = number
    rule_id  = string
    type     = optional(string, "REGULAR")
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.activated_rule : contains(["BLOCK", "ALLOW", "COUNT"], rule.action.type)
    ])
    error_message = "resource_aws_wafregional_rule_group, activated_rule action type must be one of: BLOCK, ALLOW, COUNT."
  }

  validation {
    condition = alltrue([
      for rule in var.activated_rule : rule.priority >= 0 && rule.priority <= 99
    ])
    error_message = "resource_aws_wafregional_rule_group, activated_rule priority must be between 0 and 99."
  }

  validation {
    condition = alltrue([
      for rule in var.activated_rule : length(rule.rule_id) > 0
    ])
    error_message = "resource_aws_wafregional_rule_group, activated_rule rule_id must not be empty."
  }

  validation {
    condition = alltrue([
      for rule in var.activated_rule : contains(["REGULAR", "RATE_BASED", "GROUP"], rule.type)
    ])
    error_message = "resource_aws_wafregional_rule_group, activated_rule type must be one of: REGULAR, RATE_BASED, GROUP."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}