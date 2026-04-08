variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name or description of the web ACL."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_wafregional_web_acl, name must not be empty."
  }
}

variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this web ACL."
  type        = string

  validation {
    condition     = length(var.metric_name) > 0
    error_message = "resource_aws_wafregional_web_acl, metric_name must not be empty."
  }
}

variable "default_action_type" {
  description = "Specifies how you want AWS WAF Regional to respond to requests that match the settings in a rule. Valid values: ALLOW, BLOCK, COUNT."
  type        = string

  validation {
    condition     = contains(["ALLOW", "BLOCK", "COUNT"], var.default_action_type)
    error_message = "resource_aws_wafregional_web_acl, default_action_type must be one of: ALLOW, BLOCK, COUNT."
  }
}

variable "logging_configuration" {
  description = "Configuration block to enable WAF logging."
  type = object({
    log_destination = string
    redacted_fields = optional(object({
      field_to_match = list(object({
        data = optional(string)
        type = string
      }))
    }))
  })
  default = null

  validation {
    condition = var.logging_configuration == null || (
      var.logging_configuration.log_destination != null &&
      length(var.logging_configuration.log_destination) > 0
    )
    error_message = "resource_aws_wafregional_web_acl, logging_configuration.log_destination must not be empty when logging_configuration is provided."
  }

  validation {
    condition = var.logging_configuration == null || var.logging_configuration.redacted_fields == null || (
      var.logging_configuration.redacted_fields.field_to_match != null &&
      alltrue([
        for field in var.logging_configuration.redacted_fields.field_to_match :
        field.type != null && length(field.type) > 0
      ])
    )
    error_message = "resource_aws_wafregional_web_acl, logging_configuration.redacted_fields.field_to_match.type must not be empty."
  }

  validation {
    condition = var.logging_configuration == null || var.logging_configuration.redacted_fields == null || (
      alltrue([
        for field in var.logging_configuration.redacted_fields.field_to_match :
        field.type != "HEADER" || (field.data != null && length(field.data) > 0)
      ])
    )
    error_message = "resource_aws_wafregional_web_acl, logging_configuration.redacted_fields.field_to_match.data must be provided when type is HEADER."
  }
}

variable "rules" {
  description = "Set of configuration blocks containing rules for the web ACL."
  type = list(object({
    priority = number
    rule_id  = string
    type     = optional(string, "REGULAR")
    action = optional(object({
      type = string
    }))
    override_action = optional(object({
      type = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.priority >= 0
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.priority must be a non-negative number."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      length(rule.rule_id) > 0
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.rule_id must not be empty."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      contains(["REGULAR", "RATE_BASED", "GROUP"], rule.type)
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.type must be one of: REGULAR, RATE_BASED, GROUP."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.action == null || contains(["ALLOW", "BLOCK", "COUNT"], rule.action.type)
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.action.type must be one of: ALLOW, BLOCK, COUNT."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.override_action == null || contains(["COUNT", "NONE"], rule.override_action.type)
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.override_action.type must be one of: COUNT, NONE."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.type != "GROUP" || rule.action == null
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.action cannot be used when type is GROUP."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.type == "GROUP" || rule.override_action == null
    ])
    error_message = "resource_aws_wafregional_web_acl, rules.override_action can only be used when type is GROUP."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}