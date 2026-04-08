variable "name" {
  description = "Name of the rule group. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "metric_name" {
  description = "A friendly name for the metrics from the rule group"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.metric_name))
    error_message = "resource_aws_waf_rule_group, metric_name must contain only alphanumeric characters."
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
    error_message = "resource_aws_waf_rule_group, activated_rule action type must be one of: BLOCK, ALLOW, or COUNT."
  }

  validation {
    condition = alltrue([
      for rule in var.activated_rule : rule.priority >= 1 && rule.priority <= 99999
    ])
    error_message = "resource_aws_waf_rule_group, activated_rule priority must be between 1 and 99999."
  }

  validation {
    condition = alltrue([
      for rule in var.activated_rule : contains(["REGULAR", "RATE_BASED", "GROUP"], rule.type)
    ])
    error_message = "resource_aws_waf_rule_group, activated_rule type must be one of: REGULAR, RATE_BASED, or GROUP."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}