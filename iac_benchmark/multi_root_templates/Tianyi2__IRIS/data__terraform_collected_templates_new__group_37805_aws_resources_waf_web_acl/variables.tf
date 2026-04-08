variable "name" {
  description = "The name or description of the web ACL"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_waf_web_acl, name cannot be empty."
  }
}

variable "metric_name" {
  description = "The name or description for the Amazon CloudWatch metric of this web ACL"
  type        = string

  validation {
    condition     = length(var.metric_name) > 0
    error_message = "resource_aws_waf_web_acl, metric_name cannot be empty."
  }
}

variable "default_action_type" {
  description = "Specifies how you want AWS WAF to respond to requests that don't match the criteria in any of the rules"
  type        = string

  validation {
    condition     = contains(["ALLOW", "BLOCK"], var.default_action_type)
    error_message = "resource_aws_waf_web_acl, default_action_type must be either 'ALLOW' or 'BLOCK'."
  }
}

variable "rules" {
  description = "Configuration blocks containing rules to associate with the web ACL and the settings for each rule"
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
      for rule in var.rules : contains(["REGULAR", "RATE_BASED", "GROUP"], rule.type)
    ])
    error_message = "resource_aws_waf_web_acl, rules type must be one of 'REGULAR', 'RATE_BASED', or 'GROUP'."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : rule.action == null || contains(["BLOCK", "ALLOW", "COUNT"], rule.action.type)
    ])
    error_message = "resource_aws_waf_web_acl, rules action type must be one of 'BLOCK', 'ALLOW', or 'COUNT'."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : rule.override_action == null || contains(["NONE", "COUNT"], rule.override_action.type)
    ])
    error_message = "resource_aws_waf_web_acl, rules override_action type must be one of 'NONE' or 'COUNT'."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : rule.priority > 0
    ])
    error_message = "resource_aws_waf_web_acl, rules priority must be greater than 0."
  }

  validation {
    condition = alltrue([
      for rule in var.rules : length(rule.rule_id) > 0
    ])
    error_message = "resource_aws_waf_web_acl, rules rule_id cannot be empty."
  }
}

variable "logging_configuration" {
  description = "Configuration block to enable WAF logging"
  type = object({
    log_destination = string
    redacted_fields = optional(object({
      field_to_match = list(object({
        type = string
        data = optional(string)
      }))
    }))
  })
  default = null

  validation {
    condition = var.logging_configuration == null || (
      length(var.logging_configuration.log_destination) > 0 &&
      can(regex("^arn:aws:", var.logging_configuration.log_destination))
    )
    error_message = "resource_aws_waf_web_acl, logging_configuration log_destination must be a valid ARN."
  }

  validation {
    condition = var.logging_configuration == null || var.logging_configuration.redacted_fields == null || alltrue([
      for field in var.logging_configuration.redacted_fields.field_to_match : contains([
        "URI", "QUERY_STRING", "HEADER", "METHOD", "BODY", "SINGLE_QUERY_ARG", "ALL_QUERY_ARGS"
      ], field.type)
    ])
    error_message = "resource_aws_waf_web_acl, logging_configuration redacted_fields field_to_match type must be one of 'URI', 'QUERY_STRING', 'HEADER', 'METHOD', 'BODY', 'SINGLE_QUERY_ARG', or 'ALL_QUERY_ARGS'."
  }

  validation {
    condition = var.logging_configuration == null || var.logging_configuration.redacted_fields == null || alltrue([
      for field in var.logging_configuration.redacted_fields.field_to_match :
      field.type != "HEADER" || (field.data != null && length(field.data) > 0)
    ])
    error_message = "resource_aws_waf_web_acl, logging_configuration redacted_fields field_to_match data is required when type is 'HEADER'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}