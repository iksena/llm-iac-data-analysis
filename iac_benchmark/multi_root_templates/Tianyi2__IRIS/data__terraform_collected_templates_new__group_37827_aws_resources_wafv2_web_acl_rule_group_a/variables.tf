variable "rule_name" {
  description = "Name of the rule to create in the Web ACL that references the rule group. Must be between 1 and 128 characters."
  type        = string

  validation {
    condition     = length(var.rule_name) >= 1 && length(var.rule_name) <= 128
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, rule_name must be between 1 and 128 characters."
  }
}

variable "priority" {
  description = "Priority of the rule within the Web ACL. Rules are evaluated in order of priority, with lower numbers evaluated first."
  type        = number

  validation {
    condition     = var.priority >= 0
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, priority must be a non-negative integer."
  }
}

variable "web_acl_arn" {
  description = "ARN of the Web ACL to associate the Rule Group with."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:wafv2:", var.web_acl_arn))
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, web_acl_arn must be a valid WAFv2 Web ACL ARN."
  }
}

variable "managed_rule_group" {
  description = "Managed Rule Group configuration. One of rule_group_reference or managed_rule_group is required. Conflicts with rule_group_reference."
  type = object({
    name        = string
    vendor_name = string
    version     = optional(string)
    rule_action_override = optional(list(object({
      name = string
      action_to_use = object({
        allow = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
        block = optional(object({
          custom_response = optional(object({
            custom_response_body_key = optional(string)
            response_code            = number
            response_header = optional(list(object({
              name  = string
              value = string
            })))
          }))
        }))
        captcha = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
        challenge = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
        count = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
      })
    })))
  })
  default = null

  validation {
    condition = var.managed_rule_group == null ? true : (
      var.managed_rule_group.name != null && var.managed_rule_group.vendor_name != null
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, managed_rule_group name and vendor_name are required when managed_rule_group is specified."
  }

  validation {
    condition = var.managed_rule_group == null ? true : (
      var.managed_rule_group.rule_action_override == null ? true : alltrue([
        for override in var.managed_rule_group.rule_action_override : override.name != null && override.action_to_use != null
      ])
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, managed_rule_group rule_action_override name and action_to_use are required for each override."
  }

  validation {
    condition = var.managed_rule_group == null ? true : (
      var.managed_rule_group.rule_action_override == null ? true : alltrue([
        for override in var.managed_rule_group.rule_action_override : (
          (override.action_to_use.allow != null ? 1 : 0) +
          (override.action_to_use.block != null ? 1 : 0) +
          (override.action_to_use.captcha != null ? 1 : 0) +
          (override.action_to_use.challenge != null ? 1 : 0) +
          (override.action_to_use.count != null ? 1 : 0)
        ) == 1
      ])
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, managed_rule_group rule_action_override action_to_use must specify exactly one action type."
  }

  validation {
    condition = var.managed_rule_group == null ? true : (
      var.managed_rule_group.rule_action_override == null ? true : alltrue([
        for override in var.managed_rule_group.rule_action_override :
        override.action_to_use.block == null ? true : (
          override.action_to_use.block.custom_response == null ? true : (
            override.action_to_use.block.custom_response.response_code >= 200 &&
            override.action_to_use.block.custom_response.response_code <= 599
          )
        )
      ])
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, managed_rule_group rule_action_override block custom_response response_code must be between 200-599."
  }
}

variable "override_action" {
  description = "Override action for the rule group. Valid values are 'none' and 'count'. Defaults to 'none'. When set to 'count', the actions defined in the rule group rules are overridden to count matches instead of blocking or allowing requests."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "count"], var.override_action)
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, override_action must be either 'none' or 'count'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "rule_group_reference" {
  description = "Custom Rule Group reference configuration. One of rule_group_reference or managed_rule_group is required. Conflicts with managed_rule_group."
  type = object({
    arn = string
    rule_action_override = optional(list(object({
      name = string
      action_to_use = object({
        allow = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
        block = optional(object({
          custom_response = optional(object({
            custom_response_body_key = optional(string)
            response_code            = number
            response_header = optional(list(object({
              name  = string
              value = string
            })))
          }))
        }))
        captcha = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
        challenge = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
        count = optional(object({
          custom_request_handling = optional(object({
            insert_header = list(object({
              name  = string
              value = string
            }))
          }))
        }))
      })
    })))
  })
  default = null

  validation {
    condition     = var.rule_group_reference == null ? true : can(regex("^arn:aws:wafv2:", var.rule_group_reference.arn))
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, rule_group_reference arn must be a valid WAFv2 Rule Group ARN."
  }

  validation {
    condition = var.rule_group_reference == null ? true : (
      var.rule_group_reference.rule_action_override == null ? true : alltrue([
        for override in var.rule_group_reference.rule_action_override : override.name != null && override.action_to_use != null
      ])
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, rule_group_reference rule_action_override name and action_to_use are required for each override."
  }

  validation {
    condition = var.rule_group_reference == null ? true : (
      var.rule_group_reference.rule_action_override == null ? true : alltrue([
        for override in var.rule_group_reference.rule_action_override : (
          (override.action_to_use.allow != null ? 1 : 0) +
          (override.action_to_use.block != null ? 1 : 0) +
          (override.action_to_use.captcha != null ? 1 : 0) +
          (override.action_to_use.challenge != null ? 1 : 0) +
          (override.action_to_use.count != null ? 1 : 0)
        ) == 1
      ])
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, rule_group_reference rule_action_override action_to_use must specify exactly one action type."
  }

  validation {
    condition = var.rule_group_reference == null ? true : (
      var.rule_group_reference.rule_action_override == null ? true : alltrue([
        for override in var.rule_group_reference.rule_action_override :
        override.action_to_use.block == null ? true : (
          override.action_to_use.block.custom_response == null ? true : (
            override.action_to_use.block.custom_response.response_code >= 200 &&
            override.action_to_use.block.custom_response.response_code <= 599
          )
        )
      ])
    )
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, rule_group_reference rule_action_override block custom_response response_code must be between 200-599."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {}

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_wafv2_web_acl_rule_group_association, timeouts must be in format like '30m', '5s', or '2h'."
  }
}